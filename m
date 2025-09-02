Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4326CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE248E0008; Tue,  2 Sep 2025 16:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5A88E0001; Tue,  2 Sep 2025 16:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2E68E0008; Tue,  2 Sep 2025 16:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F223D8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:09:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BE1685734
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:09:44 +0000 (UTC)
X-FDA: 83845400688.07.ECE328E
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id A31BF2000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:09:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=hbNGd+q7;
	spf=pass (imf03.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.46 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KILA1nOXWe5H60A4yyJFsYPaQBIG7c2xu7zOWE6LZ5o=;
	b=TKO2TZalPBTbOnw9eHms+v9McP3tXxKgo9IasfYsN0FArdn54W8lgI0VgbX6/eu2gtDhL9
	3/JldQHf1mazVXHbDvm3SKOCYGtP7fCbYMdZYalovbCDEP4ismvPxFXm7QT5yAeiqEwTJC
	OHD0/ewBlSvwZt+UG3w1EvjLR/if7yM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843782; a=rsa-sha256;
	cv=none;
	b=k2CM1M6fP9AM4u52gm7o9OEh6xZuvQrCmx0OgjMlPCOgF1KR0D1CSKdB85ALDcTS1crjRQ
	qP3IQsjkeZkWCNgZ8SMoZhd1F/4oBtARkLyinAmOVM53zlaBrpyEUN46Sz19iNpEl6UoKZ
	cJ9ItpRtGN07aVCtEei2s/nyl/lrYOo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=hbNGd+q7;
	spf=pass (imf03.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.46 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ce772ce0dbso4086895f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756843781; x=1757448581; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KILA1nOXWe5H60A4yyJFsYPaQBIG7c2xu7zOWE6LZ5o=;
        b=hbNGd+q7tKQ1XJKvcAZIJbpBNr7WSDNUD92X7BlgxX4C/IxEWxddWOnINhDpLZLsJC
         KorF6cNintX+0B9tJ27xBNKovXHWVVozXfaBm/dXDq6PmTeGoyBlJVLyRUDcF+CCR0Bm
         tq9sGvq+BcW+5Liu2zTbIQY+Ugi9PXRrkwf8snWVqQryUhrPqzZA3lwktez5lEkZOf1e
         VAr5GiVCClQIV6yQofwqRe/Q9u7v0hFkdheCaT9SB0ROPAmOgRz3N6iiHMD+WdhtnXdn
         kV08adsB6u5O2Yeb90UlyJURx8JyCyazTSqaXW67gFPdlizWcb0YCkn3CNJsnnOX9T5k
         7aLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756843781; x=1757448581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KILA1nOXWe5H60A4yyJFsYPaQBIG7c2xu7zOWE6LZ5o=;
        b=DkE5i3SBAvgcA119CuUfzC1VxEMLVyidSKHtER8it6jraqmP8EUez6Yl3Ht09+yB73
         t2X6urUrhotMm27Ydm3gYSrEfPANql6LZP9tZXcejuyRbjV/2GrW+l6Hw4cp0ONSgzBN
         uLszTge00uw67cGP5CeWNu4yTw0lzyab1KR+I86TbVnPPNHDNGR4epHLSi0yHv2Nt49N
         /ezzBIBMSgk5fAN53dDP6IC3gq6ojnAS0f8mfXEHRc08iCCEvobFz7cZgKjeT97ZQf2i
         RII2uUDCtPH4gzXZjU0U+IdIYLu8ZRQncT+bAP1Kf+jGs5oVLyRiy8hc8gtmBbs2B/6S
         Z7dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNrJcoBJoboLOC15dhoQc94yUABc8nUWx5N6OBLmfFQHN1p/Erh/y4mkREg0rP1WsWMeaH8rY+6Q==@kvack.org
X-Gm-Message-State: AOJu0YxieyULXT+oYKo7vRrctQq+D8QvMqa7SpgE1YwLJf9Eg1UvayUy
	3q9cj0MzwvrbfOocKM0IZMB7ndDdCSjyBf7UmEg73t1+yV361BqG6c6/5c1httHkGjs=
X-Gm-Gg: ASbGnctYgFqB7kxgbyU57Fy5PNbgJj4MZEfEthJB/Esn5mQffEcGuupJHkOsFKpdIIV
	kPgoS0M57DD2JbPkGpXqOgVf9gX/HSP193m+e3DHWGMJVbZg7cVNUU3hOg5w6GN0jxyJxhpTsTT
	5wh9MCVaZKlaVRErlGU4IumXMVbXc9SUEQ9bRKWO+q3IF8Z69R9soVEj18rU4T3CiEfflFujI7q
	e4nBYwBr2P0jjEYLN14lj/LjT4W71Ac/rkHnZbXke5d4fHaa9XZGMd6o3X4oDfS2foS+poY5Ajw
	Xlu7RmYqbjft4MfZCF2QkpvYMz4wakCbrzrNDwKDeTteRryKNM0dj4Iy8K7uKPhJURFf2cVyVV4
	3D0fqLqBYhHF3l7S4nCDrkSXS56o=
X-Google-Smtp-Source: AGHT+IEIxQjayoH5EzypYQlnrWOGJYnR/qiP28eRuIMS858TgK3CgPb/5uCIk1kXNto7Dyp8KsOhyg==
X-Received: by 2002:a5d:5d88:0:b0:3da:484a:3109 with SMTP id ffacd0b85a97d-3da484a361bmr2462735f8f.38.1756843781021;
        Tue, 02 Sep 2025 13:09:41 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf3458a67esm20853436f8f.62.2025.09.02.13.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 13:09:40 -0700 (PDT)
Date: Tue, 2 Sep 2025 23:09:37 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <kees@kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm: Fix kernel stack tagging for certain configs
Message-ID: <aLdPAa54rrZsOFm_@stanley.mountain>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
 <aLdFxtVpOX-qf0qc@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLdFxtVpOX-qf0qc@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A31BF2000E
X-Stat-Signature: 8bui57upy3an91m7hemumr15pworxbnu
X-HE-Tag: 1756843782-597370
X-HE-Meta: U2FsdGVkX1+lX7OPDo87CvUtrQ2rlxvuS6rbXhEZqANZB/3RVs4JBYHdylLt+X3oF2GfQbvkoiCtYfCcw4SCSfMv1TIq8v8gmWCrrqpyFoE8c4sD2b38gfUwId90FKlMaLBwdSdd5G3bT94P1P88gXYw/5lqWCV5DKtXmXd9Dhc+EOghXYnxllRWUSmpsdh8ydb59sf2j9u9L42W2YRVCJdj9LEUGFi/JR76rBiaPMRJQ9gwjFwiC3Gv+zdKMAI1TPG9V/kE76uvl2XM/urf6oE9JFLzWnBipsF4AMsl5PIcAsb6RJ+GI7hCs3yxZnmTVfJ4eC7ePMRqMfqqUl3SFppY9GO3keN8/0sw+rY4NSN1/9mg/rxYb0xed3nINFZsOexwfUEZgmatpud/RQyF/tU/Em7ubAf0EbuvgqEtobb/jF/MDaJW0kh/a6PZcNgJoxCWjOWms+EEgMzAloJbGHth3BJ6azHawxGazx4gRJ3aNIWOGHTZn39O56SKfCQj+BBb8MkKdo3X2Q2h2CbbRTPVrLO4N4x0HUm6/DPm6Zg92ZwMSTj4gJCSwoOaKP0fDCYkI8jJPjL9F11Ns7vI5bwvveNn2Jdj7SR6lzG6Zb7MVfrFq20hrPkBRz0M1Z2afCQ7u1+zbqf7nxlxRy6Xb7FmzG5gobYDTsJrHsZnCCZ9+ojBizI7Rs0NFxauI8KlHYOjOANWFkbej9WsC+y9/BPIJ38fVnQEaGyTvOFSQWZi2e8FQciaK442ugPzaYSQ0cE7+c0CS1yCfzakOVOg/nzZvcSTuU4U87IuPK6zhFr5PCQqnouQCvmpH5GZv0BpXcRR63ZxBNsRl+EGtOTcYWUpS77kR3kFEt09NSOtMVoZhjhVhCbk3NFSGpqSOeLcMx1pxNZpm7BeZvp/MNyo0hZ+pCjqYi3FzhdSnTZZsEMIpFVbWfTj3AjhFOyCi56bh0QuGj5mfVTcKq5v5zo
 FvRJem8B
 twAGaBK8GcF/568ykHV4PN5AJvvmgezIlQz0o+g0NiB9Fn+ReND3bFOkeQQIqXViKvju+1/i45enMPxmnG/hcbvacSKWAPOq6IyMTQbD2OJklP5Rlna89/hjMiYruWiPbceBk23YTom/9wNVloJZ9gxrmojHBN/tmXsr7qPPuTU09qZE3itGa+MGVbyFhYUA+L6VpDZRQGom/r5X4VofWzbHMjiPWo0x0IiWktsRMXm/tpcuG7k8S7ljVBLqLwAgDCoPRG3xoTdjY6ZLPpEu1ltySstwWw/UOtY9jHMrOs7dXsZGB5eisINBybsaCEQ98urpxWpzMZKdTLSs+vRll75WMy9L069rFsqLfXH9inUczJ+YTYjRlsyUQuxahFjL5JaurMn08AWmb2EA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:30:14PM +0100, Matthew Wilcox wrote:
> On Tue, Sep 02, 2025 at 10:59:03AM -0700, Vishal Moola (Oracle) wrote:
> > There are 3 cases where kernel pages are allocated for kernel stacks:
> > CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
> > These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
> > respectively.
> 
> I missed that the third case existed ...
> 
> > In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
> > than 0, and pages are tagged as expected. In the third case,
> > THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
> > This meant that in those configs, the stack tagging was a no-op, and led
> > to smatch build warnings.
> 
> I didn't see those smatch warnings.  Were they cc'd to the mailing list?
> 

I messed up and accidentally sent an email with two Message-ID headers
so maybe it got eaten by your spam filter?

https://lore.kernel.org/all/202508300929.TrRovUMu-lkp@intel.com/

regards,
dan carpenter

