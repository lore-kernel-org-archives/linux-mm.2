Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA77CCCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 23:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE1F8E0005; Mon, 20 Oct 2025 19:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C55A8E0002; Mon, 20 Oct 2025 19:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8021F8E0005; Mon, 20 Oct 2025 19:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F09E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:28:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F0A2119A4E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:28:10 +0000 (UTC)
X-FDA: 84020083140.09.4DC3CC8
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B2B440009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:28:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=STSep3YB;
	spf=pass (imf11.hostedemail.com: domain of david@fromorbit.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761002888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5x+1UXqj8C++nudO2r6ht89eY6krRyEDQJSgyqLqDY=;
	b=j+Cc3olEW7eocWIsXdf1ioqsP7mTUvyHTISHbg0DrAzgMc4KnzHfxEgTGRdyA1wEF00NPX
	RzFLRoNFck1OjhTWqGaoU4BixzDS/XOS6MHxkGyOQHpWW2GxjqGRtUTAA0VLTnEdlEPBZm
	UrUljiidw0tx9Yb4K5ALY4P4YcQSS1E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=STSep3YB;
	spf=pass (imf11.hostedemail.com: domain of david@fromorbit.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761002888; a=rsa-sha256;
	cv=none;
	b=p7E1JcDP62VI2WYQKMeALt7FZCNrlgRXVZES9Z7lDUqS4rBMdXKSHi926qZ1NtyIdte5bc
	joMArjHubG2A7EtKv49+XDkp2BCN+Ypj6WUhtozKA/rr+fwGhaW9fVkXaE0JnvfbrpjcWC
	g62nbR1YY0hCANlpEe71r/zGNSG8YI4=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-339d7c4039aso4280161a91.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761002887; x=1761607687; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E5x+1UXqj8C++nudO2r6ht89eY6krRyEDQJSgyqLqDY=;
        b=STSep3YBRVuJKgcISFnKLoZ/dnbkSlwuDFWzvw0E0dnRZ1Y0hrF8p6PrNQJk5xMbL1
         zs3bp5HBMPx5qmL9rVLJxZFIROUSrwcyaZ4HkO+k7iH6WTn2d1YmUaPYd33sAERaC3Cd
         SxoZu4wa7nRAnLJe1NhXF3sY36F+vqQBvKmguH7xBM46ooB3zEzuyeCFyDtdl3u1Wq/n
         8KuEiX3hwlVLfh6s4MEz7W3WEU832VT/1e8Bklnu6PbNzz0gCS1QRyU0BLtxS6ZWDo4r
         2DdjIvWq2KpshXFTqiXofb6z3959WYlZYJOlRfhxLm8PcpJ7Xg7+dj4unFYcIKHfHQA3
         dB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761002887; x=1761607687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5x+1UXqj8C++nudO2r6ht89eY6krRyEDQJSgyqLqDY=;
        b=kUgI08sno7ZZckAgZrkjmKU8MtYB/ZjGDP2OEXQ/u4TswysOlJVROebySSD2/A5rR9
         OnCAd5b+Sr7fCiSIdQyUdVgTbq+KvNWrsEZtBaQE3h6VHJ+zMMUweP24Rbj7t4+EGqWr
         lrJpT2UQ4gB1NOSHTc8yiuOt+KU6SxBORwMWaqmbVj9zq/MnikfGheyuqO+4/vwZpdh0
         aTDVysjpM93aJfCNc781RZ1lyCrfXjTVDJKm2eMFe0YHCOb/uXHuuYr+habfYmIUqIiv
         bs5mYyH+kRuwYXtu+jnsax7831aL0411NLx0fG3FXFNgBAaFO+3lDFZSC0Gi37xqIGJZ
         iVGA==
X-Forwarded-Encrypted: i=1; AJvYcCU8B9jizCGBbJXU83kugNiu0X6CC9yeTybWt4B0Z05XYORGa1/LmgDsq97aMHT9GYuoHaaXaMswfw==@kvack.org
X-Gm-Message-State: AOJu0YyhKqkxhVJjY3NrKx8f6vSZjGJKUJQwNsdC61mjd81Kn0TpM4i/
	PcMkYnyAoPn3g2kqOHjh4YoEODg+9A+ni/RTU4ZwBFC0Q4kDkcFfxUZbYMw1n1mLEtk=
X-Gm-Gg: ASbGncuJaP6FmgwrBeN2d8o0+UdywahKw/QNpjBXbZ9Wyh936t74vL1K31BgyEx6mJH
	ZMbd2QWZ2rJzYh3Av4Gxr5ZMYqcsrX853SJ/y9q4L5aSTQQuabSzjjVUvOooV+HfHPCzik0llUL
	Hq583GiaIwqCF2iF4+6SRgLH1a13gNKkzPfW4oBuKpFjf0ekNXve8O59VzEAVE5I3rSk/jdn8aQ
	T8Kh80e8G5wRQc2K6qpMTbxXboEdGro21kUiDqPJB5X/Dqb2nanwuRTttV+uAWQuAlaQXByMKO7
	qLulTrDFLBlK1VpXAEyIj+PVPxM46EVTMTZKaFqmo/xwVMGLLMMdYgF/ZMkM2AejKHfjzrgQpbs
	ng9DjB/PHxy58YJ0YYaHQ8mdk9tqQMpO1Dvq+RKqPWoHo+Oh3Lx15DdcWA0pTNEgYGeNi5MMwsu
	xf4IB3IuypCSXoit4Ue93sbmLBmYPQqnFTNXgzjZtzWRbxQ9Rd0VXYntXYZ2s3zg==
X-Google-Smtp-Source: AGHT+IHcdNH2fOOHB1cm0EXB4SOj6iMNk8Mq9qAcSjpJ0ejuGeU6N8u1EfzBX4tQCCgAhIt/5tgbDg==
X-Received: by 2002:a17:90b:510a:b0:33b:6e60:b846 with SMTP id 98e67ed59e1d1-33bcf87478dmr19465934a91.11.1761002886592;
        Mon, 20 Oct 2025 16:28:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33dff3f6c2esm192671a91.6.2025.10.20.16.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 16:28:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vAzII-0000000HWu0-1ddK;
	Tue, 21 Oct 2025 10:28:02 +1100
Date: Tue, 21 Oct 2025 10:28:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Message-ID: <aPbFgnW1ewPzpBGz@dread.disaster.area>
References: <20251020163054.1063646-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020163054.1063646-1-kirill@shutemov.name>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B2B440009
X-Stat-Signature: rfeyfb8c7hfooa9q4ybhknefgubz1zuf
X-Rspam-User: 
X-HE-Tag: 1761002887-563103
X-HE-Meta: U2FsdGVkX18kgzl0wvJuFCKP3uQ7wTfx8ycH3ec0RjAlGPwyNZdIrlUKznfaJp1nkz6+4Id8pLu26x964McEfhM89d4/iQkpN989ILlBPVabhKz9TLFLlyt1ZHt/mj6IVh4AdR3L1tVl1bevvF0Hp3WWzUJICA2GQS8Mssp/FkEXBcOZLIiS/9/7QvCRio6+qbQfyALZAgFipPB5LGk+p0Lzi2VvtTdo2ImRTeSkFTIBEIguADqArOc0UHgIZD9an0sCoQOXB/FNtoFZv64cAXx6Pr+J7LtzSljQz+YykStqacGIpITZUFacIuAYNBZb7lH+xaz7QHXesN9A0NBUIN0i2SH/9/v8QNGfhoh3OQF7eFFOn5ts6EM+zJHXMd6vbQ68BLpkSnMg4LomAyLZs+QMRGehMZzSLc7pxcoMKEM1PcxGI2Gvt60Mx5WMqfXaIOvGQ4P+rQZBJPEVh5x00oMHldMcBAYhumBVEQcSTaijMeJr7u1LLX1uSZJ1v+IQaLlWys0dmVzjYM73DhZnohO85zWqc8k6DsVkmqey5BcMFy3BpHoI8I2n3S9X1JA87zHsHIiLzWLM/lyu3HLUTBs0ODcsGQw+O7ugTNIssrV30FNpTPKnGFC3o1XN2136kbuelAUfSPSMXoo9l/qDhGfUz9nE2+YVrbmanLlH/66b4hLXbUzR0B7nhQN4amnptcwQ8wbXTNml7m5xEl63g3iW7MTg9C4L5Dp064qumVep8O5FPueoh9touYz4vlPl836WNcJ6uu3Cum4rF9uJL57ldXSuNen39B9WoFpWhiU8CMSMFzLLYFVXuII28fq09+riGzZXxHXuWpu2dBDVj1tJvysaKazK50E1kvMVsYef/L6houMbgwcz4YWTgKmcwNc1qMb20UCVILO3JgvIWYpZvCaeENEMM+KtTm6yqWMmYXFW8KxFrkn8XUJmYpvQ3WrVxSWChMQ68QhGAuX
 RZ9Suepb
 WiiKUaQzQCrgVzHHPg1WYqsAtJmZ16LsV9CQ/pCLVWI051psuNw36Onr+1M/sMA2t3UsyA7xY8IMALEWrD/B0P8Jgeu1kM++jcQ+FcvlNHLB7y/KFtjn5b/W0I5RbZsYTttyRr4T4EeVi0B4RlqcfIxqNThbQWzq8NgVcUjjA+zAB7jQUOxZywvjQX/GICjOZ2+ZDQc8/AZM71ZlicMhVXDY1gfRZrmFqbYClQQ1c2zcQkhoyzaFpArBqQ+/UtOCR86dxzoTYP06jIqZCSnCat113l7aWH7wU2idAniVyAsMnOMJuVMzSo1HAqLZADnJ6Pii5GQOwZtI2NgzLm1mtipqCBEIw7SceHBlx2TBNiTiRXbSQiAzhy+isB91tIfcXu+yGVvWrwQBJusjRYQpCoHxC6D9aWn2FuD2rued1t6a6FE3jc+IPCvSqQxpXbUMYXNqFZi89g+wk5eCclPQXGAHt8HzIZsb3qPv2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 05:30:52PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> I do NOT want the patches in this patchset to be applied. Instead, I
> would like to discuss the semantics of large folios versus SIGBUS.
> 
> ## Background
> 
> Accessing memory within a VMA, but beyond i_size rounded up to the next
> page size, is supposed to generate SIGBUS.
> 
> This definition is simple if all pages are PAGE_SIZE in size, but with
> large folios in the picture, it is no longer the case.
> 
> ## Problem
> 
> Darrick reported[1] an xfstests regression in v6.18-rc1. generic/749
> failed due to missing SIGBUS. This was caused by my recent changes that
> try to fault in the whole folio where possible:
> 
> 	19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> 	357b92761d94 ("mm/filemap: map entire large folio faultaround")
> 
> These changes did not consider i_size when setting up PTEs, leading to
> xfstest breakage.
> 
> However, the problem has been present in the kernel for a long time -
> since huge tmpfs was introduced in 2016. The kernel happily maps
> PMD-sized folios as PMD without checking i_size. And huge=always tmpfs
> allocates PMD-size folios on any writes.

The tmpfs huge=always specific behaviour is not how regular
filesystems have behaved. It is niche, special case functionality
that has weird behaviours and, as such, it most definitely does not
set the standards for how all other filesystems should behave.

> I considered this corner case when I implemented a large tmpfs, and my
> conclusion was that no one in their right mind should rely on receiving
> a SIGBUS signal when accessing beyond i_size. I cannot imagine how it
> could be useful for the workload.

Lacking the imagination or knowledge to understand why a behaviour
exists does not mean that behaviour is unnecessary or that it should
be removed. It just means you didn't ask the people who knew wy the
functionality exists...

> Generic/749 was introduced last year with reference to POSIX, but no
> real workloads were mentioned. It also acknowledged the tmpfs deviation
> from the test case.
> 
> POSIX indeed says[3]:
> 
> 	References within the address range starting at pa and
> 	continuing for len bytes to whole pages following the end of an
> 	object shall result in delivery of a SIGBUS signal.
> 
> Do we care about adhering strictly to this in absence of real workloads
> that relies on this semantics?

We've already told you that we do, because mapping beyond EOF has
implications for the impact on how much stale data exposure occur
when the next set of truncate/mmap() bugs are introduced.

> I think it valuable to allow kernel to map memory with a larger chunks
> -- whole folio -- to get TLB benefits (from both huge pages and TLB
> coalescing). I value TLB hit rate over POSIX wording.

Feel free to do that for tmpfs, but for persistent filesystems the
existing POSIX SIGBUS behaviour needs to remain.

> Any opinions?

There are solid historic reasons for the existing behaviour and for
keeping it unchanged.  You aren't allowed to handwave them away
because you don't understand or care about them.

In critical paths like truncate, correctness and safety come first.
Performance is only a secondary consideration.  The overlap of
mmap() and truncate() is an area where we have had many, many bugs
and, at minimum, the current POSIX behaviour largely shields us from
serious stale data exposure events when those bugs (inevitably)
occur.

Fundamentally, we really don't care about the mapping/tlb
performance of the PTE fragments at EOF. Anyone using files large
enough to notice the TLB overhead improvements from mapping large
folios is not going to notice that the EOF mapping has a slightly
higher TLB miss overhead than everywhere else in the file.

Please jsut fix the regression.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

