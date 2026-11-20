Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B690606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=SADf/MPm
Received: by kanga.kvack.org (Postfix)
	id 2508B6B05B1; Fri, 20 Nov 2026 08:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201406B05B2; Fri, 20 Nov 2026 08:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117FA6B05B3; Fri, 20 Nov 2026 08:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0DFE6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:50:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5694DC0E67
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:50:19 +0000 (UTC)
X-FDA: 85455631758.16.D1FBAF4
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 528D1C0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:50:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="SADf/MPm";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182617;
	b=ed+5bf86wuZZIC2R8lyKyNH+eAPsh4pD58T0G8JOAFlgc+elspK4NO0igavMQhokdKbhg8
	gDvrM87MZ0UKV6wnTswhE87g6z6vqRyz6KFJPg+LHiqXXLU1l9Kd6fgrr5xw+QVG8XfLyn
	TfaIYLYjOh6A43Jy6RUu17ajktwGKmY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uU+g78pFe3woDmujMNPfhZ/0Qi8mHsxDvK4Ws3nTpkw=;
	b=HNqCTYv9/tB21j8dI861wbdq1ATspNMox4wK8svKTi/bCZ3rvcKJyu7SOL755UYMAA2ZUG
	Aw2ilX//axfR4ykDt7ergZusDq1rrr9DquPzaNjDm80dfu5IeZFNB+R6Id9DAvmGDvspJl
	QytARz1HSNqsF0O3FF1lQCQQRiUya/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="SADf/MPm";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-949680e6d82so131311785a.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795182616; x=1795787416; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uU+g78pFe3woDmujMNPfhZ/0Qi8mHsxDvK4Ws3nTpkw=;
        b=SADf/MPmdH8AbW1yhxN/KqtEyq1AOcZsUPdjDP35sNaFhiwZpP6cbGiwe9HoFsTOus
         FP7Trl8jNd6ydLBnQN6DeS4IRgn9O07JP/19eIeumkUsWf0KwzOOt+/R4QeB9wRXXCrE
         iVNwAWy4xXtp5ZR1r71oOi7r26jnH6qDXByw42oCZT538F3/Au7G67dpbrEimtBDdLU/
         C84aqeHNRMW+SCI+96IPdnuPXtTjHpK5Hu152xYxPRYH/fYSTfduae/DnEfAsNIh/fs6
         2g/rAA5jxYUbJomj+RagZK7sCFNyZ86zKZ3PFFLpHcWJqCfAo/SEva2bA3QRv7vQo01V
         KBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795182616; x=1795787416;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uU+g78pFe3woDmujMNPfhZ/0Qi8mHsxDvK4Ws3nTpkw=;
        b=qP2IU4XcuF+mML7+xv/M5B02Acy1iUtI5vtJtfw3Nzad2b3phBAb3uF3OZ9eTy8VNE
         wYDUMVZ5N+tMAapJ+8yUYqYqKClZZDYGLfi5C7cYwQrIXaOcrptnCkwIUwAnV4uhGKTV
         iVoY++DgtcIwrHFhE+/9kn5Jjx3sQI7nZRa745LEdqnjRxxnfPkZsEKOvKF3s4roDl9u
         klwVBqfdD7+0u5KfnHba1QLHWE8FGmT3K+3KkJwO1/n9qEbrAhUrAibZOO6wGgLD22PX
         MJH69te/v/NvUdcGal1m7zLmLj/T8qmBL9UlRN6MEvB+Q3DczM5oMb6mjbXs9aQzDDLf
         /y+Q==
X-Forwarded-Encrypted: i=1; AL+hErF/nMiqo90/mgD8DDE1aCyWSTZ4SYj5hxIo28NlZCUPAl+nimi1V+SG3Gy4BC+RrCpsvV4pVldSiA==@kvack.org
X-Gm-Message-State: APuU4Z/DZOqH2Nnli5Q+e16MM6/emotUL31jBZUpa8V2+OBc327t9OvG
	06cXi62VX3Bo5c9S4qLWbwdJiBiWML0dPzWMXd0sMMzT0l3SqfbZdY+zBbyU/yCiWLk=
X-Gm-Gg: AYBFou1qjBwAnzNftskCptrCjCG1SFTxTJMmRrC1devHn5bj2XdL6YQE5GiwQKKetld
	aWbeDMHmrLQmOE46dsUNikswKlsKeo81F2zoxmyGIpUEbJ2n2yTvud4giNXRDJglB5pVuMpBW1p
	LdZ1+RZXpyg3ZPAKzqDA7r7gz9PkxsW5B89+U4SD4u5Bf8dlr/aVLI788KMxHyBPXvmIvfuq98t
	GEpLPOOqgEcS/2bXA+2hSgoMEEN4TBzzQ0GT15noBdNGg8Bj0nZ1HlaDFsRxWlQv7Q0PwWpY8Y4
	Jllc47DE6hfFrJ1hxzVqg30NsoHcK1u74mvxNgNy9pO4UO86gN/qlp0p2kKcT45n6qdBcirJ6sF
	5zUKjvy7LKiL1ZdjSSNprBSYnJ+N5mMXQyp5saKkyaxf32Nnu0qJtHBYYZzjNyFFDDzK5InvXra
	I/mygcuo7KETLSujwOfT+IJhD5oth4811oVDNgCw0WGENnI6GnFDkZKsWngRgN5Kjfv33A+X1iw
	asCu+5XXY+DAiIEaQtqRDZP0cgAekXB6DTODD0SHZiPScm7JqvvPP2w/KGCw2ar5dGOKuMlZhk3
	2MeTAQ==
X-Received: by 2002:a05:620a:4111:b0:939:5cd5:e243 with SMTP id af79cd13be357-949ba80f8acmr491343985a.6.1795182615989;
        Fri, 20 Nov 2026 05:50:15 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3f7cf3sm190597085a.31.2026.11.20.05.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:50:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xUP0H-00000003hHG-3ovL;
	Fri, 20 Nov 2026 09:50:13 -0400
Date: Fri, 20 Nov 2026 09:50:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Luigi Rizzo <rizzo.unipi@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Naman Gulati <namangulati@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <20261120135013.GO3115493@ziepe.ca>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: um1w5jaoqiq9pckfzmnpxhqhd1bqd8d8
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 528D1C0005
X-HE-Tag: 1795182617-567496
X-HE-Meta: U2FsdGVkX184HDf810AAlXPKo2UoHBY8flE0TF8Ha97JcpWkemiutIjgyMdZwWALSFaqu9mu5u4D/VulHROBMej5jaBqrTV/pVYWzxn2udzWc+jd4arYx6VlcXdgm/7M58jPVQo1dwWofP/E1FqsZMoDDesMZtcKKhXY6Hr+SbIUaCY6b0DFSnusQqF7wfaqZ1Q+i+rnQlG/Oo5gib3KpV7PRL3JGHOqDXhFiiju7AKdQDtU4B2Ia8IIsoaPl07FLjDDAmsc8X/CLTA38FNsw+uguJQnqMO2jy6T/+eJw/l/Ck7WoZkPe2nwZuoJNZrtJ/YSz/NcCvIvXebvHS84k8WAEaTCQhS+CZjojqjTOqQy0s4S5BjstZ1e5zMrExai6HetF1673QClGtGni6dh1y4bPU1WQPBvrvHZVvT3agsrHpaBMSmjvjY5Ia3XzBjXWjZ06LM/og0LoFlXS5hS59ex74jO/pj6DkBSoN8wUl9m751YPe94ozqPrJ8q6ZPLU7xaldBuA904xfYtVKbuQKB+1EwFE4Lcp47tVqDzLBKwMDS5byqrMN/fINWuwDck3QetsGn/g1nK2l+IMu+ILKSMNWjRiNpU0f6v79LPyViL/0a91RICFjoHoGFXfthCDzvhcVkCbAulvZOlpnmYqCWq5j3WCpwkbtXbhqXISQjdyGdBSqEZypCIRM8ZEjtbgHu5Qd+oiX0J0fWrv1pAk9uqsaJLA3Ef2uo8HZT4ndpFec0vCJphqT35dFUVMafCWFrbVNZIEvWFsLZ0dRZ6uA4E+pLJocaslnOZeFExBElzVn1MXIKy2U46jiObxwd/WK3P2neblxOCXvRyehCK2AHgQk9Y5yO25nSbtTPu/u+4X0to1ebRU3taCjlZ+3gUWu7K5/D1UskEPuq3w/7kmPfzMJjzvN1vV5wPfUsY4faFv5lP/N824vcwLWP/XToHxOT/Egupzy+fthSUelb
 uu2q++1R
 r7AU0fAKnBxglsno1IjrGrMZjdoH5le6ZDwVpc22DnY3fZp5g00zEoiitN4E9Q9enJqVm+Huy/nxVFLQjLWggre9DNFmXxsw/0iH44PiDNKczWKVD7q874xIw8nk/tFMIn4pvEYBKOjzgaxx4mciu7ZJB65asfA2UT6ETx1l5NZm0LH1KIY14VRbAYry9fPfcE2fLxI4UhZWoxSuVkNkwHzzUwlNguJAX98VM3id98Fpg9rEwQ5uYJYauNUCaOu3ggGgSwzFy9A/RE2dz/FUtokckKnX7rZfVg0TF5j0M2SIVvsBU7G8UdUWAsvJIK/I9IlU8EpokxdJzQU5m+76r1OrGXecRw1+bAboAK/dLUptF/aJjU8YJI9iKR25gEmH5/vcF9Rcl7BFsGfeTfxQRsS3IF0ZZ4L3D20D4lemRFGnQ14VlJ+F6/2Y3QTQpDmSoh7W/MBr/4M86xG8/ftksSFgvlKfLFH7UgK0Vs2YAM4hE28PeC895LhWpq9pD+2Db/I1qCJc5wXjqiL/HRNn89uoXhWtnFL1JkfLuPFuAYtkJ4f9YlBguPlD3ER4rhgN75DP1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
> ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> Documentation/core-api/pisa.rst (patch 25/25), which has the details.

I thought the conclusion was to just do this stuff in netdev pagepool,
now you come with an enormous AI series spread across the entire
kernel?

> - Needs bounce buffers: in Confidential Computing VMs, PISA allocators
>   pre-decrypt 2MB pages in place, avoiding swiotlb bounce-buffer copies.

It seems this was ignored too. We want the bounce buffers in CC. They
serve a security purpose. You cannot loose control of the shared
memory buffers have have them leak into SKBs, user mappings and so
on. It is not secure.

I don't see how any of this is valuable or necessary for CC,
especially when we really don't even expect to have an vIOMMU for CC
very often..

Jason

