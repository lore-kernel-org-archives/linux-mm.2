Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AFBC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 22:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079A76B007B; Sun,  2 Aug 2026 18:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A316B0088; Sun,  2 Aug 2026 18:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E851E6B008A; Sun,  2 Aug 2026 18:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4A786B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:19:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46681160585
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:19:54 +0000 (UTC)
X-FDA: 85057747908.06.FEB75B9
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7F32D1C0002
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:19:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EfiyZGNi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785709192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9PxmJvgH++4wFP7ID3jQ6AJu2hUuoRabft5a9u/mZc=;
	b=RE2hLMYGPiSI8Sl9o6HjCoUwR5agsCCByhCteFroNnXNArFZvkDyFDSSqKwHtHSPwUD87Y
	EaYVEH9orosjBP5e1DWj8h04Zoufdja0XzAoVb5BAAHuaqYNpdt7bMFX9FweMKPGdhrszL
	kdmwnR7xma4o1Z/XM/fnjl4QNKcp1jI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EfiyZGNi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785709192;
	b=d48GhQoQcaFiEeN98Bm9hr5vjS/3vG8H4d1n53uP7y9UsdTXGP/DKvEVBC7KKEkRhyAD4p
	rpWCqYMz5KlQGw0qmZlHe5kZou7b8dvMDqib7c3DjtvuMIVJ0X6gd/+JIwWD5TqwU6QDuT
	k7kaQHKaltuQKz8h4GA81QKFKuezLL4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ccdf36f63dso83265ad.0
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 15:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785709191; x=1786313991; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9PxmJvgH++4wFP7ID3jQ6AJu2hUuoRabft5a9u/mZc=;
        b=EfiyZGNizHT0gb2WzOVebjJRZHaQfzrOeSN8h6ON4Q7ld41Hvlwu8DKEIMWlp6E0G4
         Jv+EcFLKOTc5046d8z9Cf42MZWU7IBFYNrqdld4gJ64nPHqQla8ED+y9B/Ou8AMDs7d8
         zNzK5LpiY/CVijHHrV3/vRxqzijT4UGZmud7j6MyKd5vtOLgMn9v8NjDVm6frC8jKaPc
         Za/CUOjVVujDQBGJXvXYIX/aAnv5yEMVfKEtPU1ekX8YfzsWAwrelZ/WJSWlUE5ezrTx
         CD2M9/97txAzKMYv2+WdSVAw8WzSBpE64ckWoKlMVSAi/85HwXEQz0pee9GOHzP/L2tv
         IAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785709191; x=1786313991;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T9PxmJvgH++4wFP7ID3jQ6AJu2hUuoRabft5a9u/mZc=;
        b=rGSAuePxJtVuQQWWwUJPxkAC//glH6uyspSyaccuWoeueLTjdIsgeJbMFu4JiMKWxo
         WVw4HsJvM9NcXZfBPUhNgFFHgTr+oO+gIN1H1mH6BtWWLqpHTSg4LLYd5oJHSnFUzR09
         wJj6mAo21YCeF3+daBKxZ3PC2qaxQMlFZVIsCDp1FlKTloSaUO/OTtvauNyUqXC6o52/
         xGZEjq4vhfvpU8fHY/4vci3NZ5cjSYweJgP5YjDzUmARH/VSUf/GZ844IYDIjfOlC33F
         EydL1W8OarX/WpkCuFF+EplkBkwAGjzMxtiYNxIVGrIOq+DCsWKlDlRdAB6BsE6/nTm8
         Xb9g==
X-Forwarded-Encrypted: i=1; AHgh+Rpf3MTqbSDUAEH/RvdxzlfL58/RF8Vp2eE1QdX0100e1LKd0lRw4W/mlhYxT2PIrmCKflyCXfSY7w==@kvack.org
X-Gm-Message-State: AOJu0YyNKkPO32s5iOG0dIpJfO1GM7tA/TWhCp7d2td8+YoNGP8F9XX5
	kkcXi9jGbiClzWStu/sothO/xVzs38AwXsJdTxRKylmsufB78ovuAmvs4y2ptyMFbQ==
X-Gm-Gg: AR+sD13YxJbITrUH9iNkd3zssMa6KuKMEIgrPO0mvbmVIde5/mXXjoqrpAzAfG+kYB8
	aMlh0WmF2HdH2jryc84ogm/n9qOP+eE1aVpu8xRX1J4hGEfZbHZGaebt8pls4gYKVq8v9Od8nLF
	w5Qrt44lfFhVm7RP1IsSI2F8FenH2pxMYj0RdvnOLyopI4urftABwVvkbUj+EEI6bjOifEMYtZJ
	HJInJ5gFZZYkVGcXNSsWeZmRXZTOzhKTfEJ7Y3IDOzVUTWVqKg9p9eVp1j5K/ecZ7q6gLpMn0iB
	4kjHtxsaKGlrN4AfhhziT+4yRXt0v7u9CaweV0zPJb9FlShc3UvPc7W1jMYnSJ3VpVs1QKv+2YF
	pSFBJhTci7Ba1N5YqpjoMCA148LhKNcxJaD+qj3GJsh0ztgRTWX43HwbQFbXbAK4W3A7w4ZNXKi
	vQ0N8mZy3p07GSBdK6WO6/pRxezz/Q9qjSelz2wHTdABjTXeqYeVHo4I/cI9nzDDPaScWJuA12G
	AN6n0jFrYXdxpYaw+KLsBd84waj7wT6kTHZFLiKkcP96MqIbN24HmqUmjnsFyidky5ZKDdR4Cbo
	hplHrYkK/XWDfZBzgLCTd5mgTpU=
X-Received: by 2002:a17:902:da81:b0:2ca:6bf:5bac with SMTP id d9443c01a7336-2d0547c255emr7641115ad.8.1785709190721;
        Sun, 02 Aug 2026 15:19:50 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:b3ef:da16:936a:c7c9] ([2a00:79e0:2eb4:9:b3ef:da16:936a:c7c9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc29f2b9sm2774436b3a.35.2026.08.02.15.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 15:19:49 -0700 (PDT)
Date: Sun, 2 Aug 2026 15:19:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] lib: add synthetic MM benchmarks
In-Reply-To: <cec6f48d-8857-49d6-a24d-b072482bf0c8@kernel.org>
Message-ID: <c76621a4-cc8c-b6a7-732f-633d372477ff@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com> <cec6f48d-8857-49d6-a24d-b072482bf0c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F32D1C0002
X-Rspam-User: 
X-Stat-Signature: zghax9j7ffs6qrqiqqi4ye1augngkddf
X-HE-Tag: 1785709192-144436
X-HE-Meta: U2FsdGVkX18CbxIepQbhNePHZ5RX699FyWBprP5z5CPB5EgK1hZoQmR1feJPHE6P6o8gXj2h4V4kVevcZ5yFxjdsyHk/Dn+Xkpf9JCQOGRbp+8etR2UyzXBRY3iF4sUiece2EfYVN7s12F13t04TH/udeki6WGi4FzlnrD1pGhfXCaKKpaVhebjY1f6dKl2SYgS0P30AmBO0CQwwt2cjTmnmaT1m6hCAL/wzGBBbWjAxwx87V+Y7vWGW6GC1xhfRuPcWcjh5blX3i1F17nGrRwzhd8a2iWehfNyk1+dBSyywS3HtByP527gvKxcHtBsYGSdGWWQ1TdSUXCVfCU3iLP8ee3yRoTRZpzmDLkLOP+NvMZ+5ifcE8hZyK3uDlvwFTJLXdbcF7BPcY92xiRVSM+K9oUeJC+eawnLCOaD67TeGyfGid6s9dY+LHUcJIQS/pj6FaOwwOi4B3EfIgp11FhblUdEnmc8VxIshWz6J5GpMCnJDEsOQRjcUyWb9URnupl7wrGGeH2GBHpmzP50JWtKFGIvNr/tYWXJabjIAYLrHAZrzNT3BAq6QuQoHsWkir2X9/w14xxVhLUml2eIjYDRVB11Ihw7Q5G5CHluuyUV6Z9SOZpWmRcWmUMIX84I5XOgt6KLWQlJtkSPTtGDk/kDDutz4ZKlzVG2iDZkwelGeONuUW8cBTFZvJ3jkmoD5zeBnk9CiDkxTQ5qY83t9BJCtT5XBQaYkKnnphhL+k0bPmHANk1nB+V4OTftBvTqxrAzOqoYXBfWQuKTM5LRUqoOhOmtGH15n3bP6ouKNAZX4lpbnErG2GOE+DhGjSOv9x09dyUmkZ8qc2bp18nRgnfleG7I1oUakon3QxB+2H2DIvlBxm0omqfFEYKES2BbU1jzPfR5FTHVLT6bOTiq3Bw2hVEw58ChUxF6aGeX8ZAeCFLSTUHHjWq0B3fSe6dsYzwQRpjJhPOpDo8CkC7C
 tPwta/4k
 iezOMivsBK6bXXN5TGZh9NvL83aXoTIWWZFtFYviad/jjXYMlk64CJ5j68z1+hRbUAwIFn/mNHx5lxfbb5UDqmYYL6zUIV3n1B2E4WNrkoNE3J/FUR0Ou7UVREAL+omVhZsjoYeMRLoEQe4QTO5Ko4+r3FuKvklPl2ZqM4Wm3Ut0cIsN9Ym99Dec+RVcAikONHbgHPoTXQCyAQt5BINxakSXxOYmgBZlXVQx3G9OEYIOm6gd9KULamn8fsey0G+IGD1VxoAg1QKHdRmlT5PIAnK2PZ2dUhfwNIgvhXkSZ88ADqnFj9nv0f5j8WRzW2dzlofzNnDaWDM+R1usa79CbiLED1CbPzZIuSqGqo6xgdDhLrt1cP5Z1hOQD0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026, David Hildenbrand (Arm) wrote:

> On 7/31/26 06:26, David Rientjes wrote:
> > A blast to the past :)
> > 
> 
> :)
> 
> > We've been carrying these synthetic benchmarks in our kernel tree since 
> > 2009 because they've been helpful to identify regressions in hot paths, as 
> > well as quantifying any improvements that have been made for new changes.  
> > Hopefully they can be useful to others as well.
> > 
> > The synthetic benchmarks are run by loading the module at runtime.  The 
> > modprobe will fail intentionally so that the module gets insta-unloaded.  
> > The test results are emitted to the kernel log.
> 
> 
> Ideally we'd have an easy way to actually use them in autoamtic tests.
> 
> E.g., loading fails -> error, loading works -> no error (and unload)
> 
> > 
> > Proposed with permission from Christoph.
> > ---
> >  lib/Kconfig.debug    |  30 ++++
> >  lib/Makefile         |   3 +
> >  lib/test_pagealloc.c | 337 ++++++++++++++++++++++++++++++++++++++
> >  lib/test_slab.c      | 375 +++++++++++++++++++++++++++++++++++++++++++
> >  lib/test_vmstat.c    |  95 +++++++++++
> >  5 files changed, 840 insertions(+)
> >  create mode 100644 lib/test_pagealloc.c
> >  create mode 100644 lib/test_slab.c
> >  create mode 100644 lib/test_vmstat.c
> 
> This looks similar to tools/testing/selftests/mm/test_vmalloc.sh and friends,
> that can actually be executed as part of our selftests and do a modprobe.
> 
> Can we have similar scripts to execute them?
> 

Thanks for looking at these tests!

Good call, I agree these could be loaded with a wrapper similar to 
test_vmalloc.sh.

All three of these tests don't take module parameters (yet?) so right now 
this wrapper would just do the equivalent of check_test_requirements(), 
usage(), and run_test() where we'd pass in a single option for now, 
"performance".

> But I also wonder if these test modules could be placed then in
> tools/testing/selftests/mm/ instead (or some subdirectory for test modules).
> 

I thought about the same and just followed what appears to be the standard 
convention (like test_vmalloc above) for lib/ for now.  If they should all 
be moved under tools/ somewhere, perhaps we handle that in a separate 
series?

> Last but not least: MAINTAINERS should cover them.
> 

Ack.

> -- 
> Cheers,
> 
> David
> 

