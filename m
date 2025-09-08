Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D29CAC585
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 16:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC858E0005; Mon,  8 Sep 2025 12:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4408E0001; Mon,  8 Sep 2025 12:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1158E0005; Mon,  8 Sep 2025 12:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4568E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:47:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADF35139C5C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:47:32 +0000 (UTC)
X-FDA: 83866663944.24.C9312F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7091A1A000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:47:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=Xljewnqu;
	spf=pass (imf19.hostedemail.com: domain of "SRS0=isGX=3T=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=isGX=3T=zx2c4.com=Jason@kernel.org";
	dmarc=pass (policy=quarantine) header.from=zx2c4.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757350050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHuXjtnGIwA8Zzr3bT7RPQh03xIe4TvMRJ0gk9Qtcas=;
	b=Zs1iL8PzE2phcPYv0g1rIja1YbEQHiaB29Yc2Vux0keprXRAzCVK6aYpzzGW0P8iR7ZggU
	+G5vL+k68R+/jze+cv4SLHx6HaKxdAiwzAMQpxf3efCgR2R9vLusosKaHSb3pJwzOygqfW
	4vPJt1Up4k5oTgyz8Uq+t7iKi8g6Cqc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=Xljewnqu;
	spf=pass (imf19.hostedemail.com: domain of "SRS0=isGX=3T=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=isGX=3T=zx2c4.com=Jason@kernel.org";
	dmarc=pass (policy=quarantine) header.from=zx2c4.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757350050; a=rsa-sha256;
	cv=none;
	b=ApxxSsMPR+ip4Qa5HhQVJF9Sjnqg8cjwq7VhT5XMuZPmJ4E/z4nhBX7amT4CGKfgd/lm6U
	G1b0rlMNvx/a8Bo0u4gLwhgkCLM1IIb2vIfjjysjgTDPUvYM/CCeOelBHpdV+of3vGFLii
	RvAqXUqP5R40dsn3gxcyKmmHph7MzF4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29F8D44862
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BB5C4CEF9
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1757350042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHuXjtnGIwA8Zzr3bT7RPQh03xIe4TvMRJ0gk9Qtcas=;
	b=Xljewnquq+YctTo5JATPHR1MZHDXoI79+kGomlCc1eCG+TF1KFpPNGPjgGgJ2eyL9t7Zjn
	9biPRJbSKpqslyEKR3leW33R1mqvnTuz7Lwht5N6SjYJEP2YGAgAppqfCHzPAnVKAINjLL
	MsEGjyeUnvWaxgUSVvlw0rheoasfYJI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 184749dc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-mm@kvack.org>;
	Mon, 8 Sep 2025 16:47:22 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-621998aecf8so198499eaf.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 09:47:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX4zhQXt+CYU430SaGiLh308Pmu/O3YsTN8SiH0YOJqQsYatQqqxLNEw1qCA3HvWhOE7C1/YXg5dA==@kvack.org
X-Gm-Message-State: AOJu0YxBbTXeI0k2PLRd/KICTaj54IYuJfb0i1WuSSTTDWiY9e3zFnT9
	6lwC7LA6afyVVE35vX0nyoav/zB9ZB0OE6gZqObX8vyZeWDi0bgRNWI0uOlhi9KovygGf111mDV
	lhwQRtq9zj5o39Xkd/L8X8epcMMkaBP0=
X-Google-Smtp-Source: AGHT+IG1lksSpt4e4b7wpOLuoBOgU4CtzIVFITSYKRy7vIMNnTgG60R226zI8so9rVaf/KD14awSBHuCM8l64s4kZfU=
X-Received: by 2002:a05:6808:2e4b:b0:438:37eb:62b2 with SMTP id
 5614622812f47-43b29b952ffmr4287499b6e.44.1757350039548; Mon, 08 Sep 2025
 09:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-6-david@redhat.com>
In-Reply-To: <20250821200701.1329277-6-david@redhat.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 8 Sep 2025 18:47:08 +0200
X-Gmail-Original-Message-ID: <CAHmME9pO-g4qUUsbF+XZqcPcwfP3-N7AxR+MX6G73adc2-NAkA@mail.gmail.com>
X-Gm-Features: AS18NWDayNVnEOpkO7Cmy5o2hUWkz6cio8gfE7ZsOxyaASSZD8l09i-KslFVPvE
Message-ID: <CAHmME9pO-g4qUUsbF+XZqcPcwfP3-N7AxR+MX6G73adc2-NAkA@mail.gmail.com>
Subject: Re: [PATCH RFC 05/35] wireguard: selftests: remove
 CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, 
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7091A1A000C
X-Stat-Signature: rhrqdrn64t1dqepoqzs4bzdtn7ztu1eb
X-HE-Tag: 1757350050-260035
X-HE-Meta: U2FsdGVkX19h+641ExD4PmWNuuk9G8vmuDKMKO1e0Kod5qO5aRvL+g+g1yaqojlAzGReMDZrTE/7AsP/Ahlt4VSjS/t+dr7OX5Y4YFDoIINhnDSAxMXPWqZBYWl62XNuM1ptQBvRQsyd1Wzh/mJ1wndcmGWh0tFxNAkmNz3tcFtNDUxWWvUg49bijoT2wv9L4eWiF9yil4I9CJUdIShw71BPBdXTsT0ZEgCMK96wYvHaTdkyg4/Pu+2pVf0NS6KeDXb4UGT+6EOrgZWS7q4lTNsLlHjk1r/S2jTH8b09hHeaKkWfE3lQ3mW6WfFqU45iopVv9+oe/NE5xJlE9JYsAS0fbef1l9yaQq2cPLWGzWi5nP4O/b3xFIEVN89SoSSQJI5pje7ZShZcggpQ/bGOk5QvA0WMwPZyQOvVFju2taFVARURM7w7W7H0DhwIN2Tw63IWS6Sprtq6NdXT+opU2ObZYa/3kKXIt+KqvQFz7JF7w5i1AAYjC6e04IbPvN17rOE8a89RUWy8HUibL66VJz0jxT2nD5zi3yp1xEF1pp6dRIx/1ibF4CwSGtrQxO0hjfwVZZo2m7jKZ0LnxFyi50PAk0j2RpRl6ACnH57iFeTsqaNilXS1QMJiGfwzkibFvAOfeR1WfJ72XonG+yRd6SrbJWULP2A0z381YHbBzBfQ1FfH3Pl8eKRkr96qNbRgxlHLD9aCGXWV0CZu2efVhKUySV9ozrJbMsn/jHF0/XnhQu+TQV+IwyJcSjqK1lqTs/kxucb9CVJ6zQdBacZx8rECrHSXQFkbSa13TXfbTiPCS8EB29gPsLxx8kdRMP21IXsdvqZAivXJrE0K6rhgj1gNVEy1BmLFUhYrW2NBCj1rZgY8XDom8Bg+Oz7LzoNb6PGStDtChz8X55B0WhGQlitAv4imzq1krgsJN7KHu0h1XPX7uH9QRz2OEP3pjvH5dk0FQhRkkB2CYYkMgKe
 r/uZXZtO
 daNtslYFwNlYEmrh6nsIUfnXzaOeC3IUAG3locnfSOGy+HcDlfrqbb6Xyo9MGJ4XHqtrofd8fSxnqFB4Pzt7dpIOwGZ61tpsYUiRkAxAV6dvKLrgo4sBPNjmPBvn6N45rBdoxuywszrjT/6uUK6PLhMIQKYp9kqZuJZHWfi+fdLBMEUsWvezvrinvB1QNYD4VzfR+uIK/4AKRDzsKAZluFXNCjwzmKuBw6/f55qR/MtSSZxZ2vnUy+Zj2APIsqTrpm8s8hd5uswRU9Bc4r2vhb0JsDKWZcZ957K2W2L6z0YAmteuR/ENdLloQQa79FWrknWHeG9U/xdE6dpI1IqgUlCu40/6xoqk6+bYxrHjZw6UgwK5a/z2ppcnmWQUW+cT0s8eKb7db2R5jRMvGFFyRgA1G+d6XfQdix+zYUyAzY1uiU31yp/o6TVBHCOx0x2Qkuc3TIQ78bOHnB1nWsE8/FLcQO48TLPpcUTj8s3IeYEJEzUw/Xyth+N+Jh6gHsWpDSkWs6gxmm23twgKOuf/5+gj6TVfpTZqsQQzOOgVUY91r6uc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied, thanks.

