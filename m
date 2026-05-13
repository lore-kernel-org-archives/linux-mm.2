Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E85CCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70156B0093; Wed, 13 May 2026 03:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B205E6B0095; Wed, 13 May 2026 03:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37BD6B0096; Wed, 13 May 2026 03:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93A986B0093
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:53:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34C9A120792
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:53:05 +0000 (UTC)
X-FDA: 84761630730.01.E027480
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 59CDB18000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:53:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZRXn/oFm";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STHxK4qvqeQ0RbAPJE0Gc4vNM5XKJnXw+gBlPnD0MgQ=;
	b=K8cxoNKA1j20JWLw9uH2ilH1vRDljY3Q77LuhQoqT41+f6kj6LfaxqQHBPoq24yUfhMGMR
	DPLGwxrkY+lPeTtNA03OG65a7yZ8QdDkxQWhqg0ev1VHmi2l82w22AHkC9vVMuVPE8QEYO
	L/KPe31WTa3Qnayu65Dx1TPO0FMfRc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658783; a=rsa-sha256;
	cv=none;
	b=8UUwXkHn9/HY6ZIt1i/evVp+G8qKyUtiWrMpru2rRgyCLzrFXSzCT/AIeRTp1eZcxNgWvy
	xyHUtE1n3trhx8y94daguLyMCC858IUTd2rEUG/dNKxNFpsOlR3IgYTMKSJ6EEZyRZm7Y1
	XlAGkf+VWJaQ0+vdy0I/KkfODPecWQk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZRXn/oFm";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488ad135063so51575515e9.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 00:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778658782; x=1779263582; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=STHxK4qvqeQ0RbAPJE0Gc4vNM5XKJnXw+gBlPnD0MgQ=;
        b=ZRXn/oFmf8aEXYR4inj1T8O1w+Lm6c4XBTq/Zmp6gDQDaaG8fJbq7bjjWueutD4dl4
         D225O9QfwyzHYLbaVVAjSGIuQ2NcrQ3Ufz8oHT9dG4JvqFrGrc1jvc/ZZfx0CBuzjdAU
         a/JTKD1PgRuvYYCz9uzQSb5vuA4QL/F8nuDLtCr+Qd91Rsu2zG4yoiNqrHSOp2A+qXuk
         AOWRMCfXWhVywOJ+Jj5gP4gKMkfK9Z/Rfjpj5EzN6bRAtEPKMqjMPs+eu8Nw23jlEphK
         Mzen5ceNzu4MGiX5wXbIyvFaLYkthx8/qzu7S61QypkOA8ZO3EU94WrSLnqKYgp2tGeL
         ZSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778658782; x=1779263582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=STHxK4qvqeQ0RbAPJE0Gc4vNM5XKJnXw+gBlPnD0MgQ=;
        b=KHhDSypSD5NbZ4XG0iXltSUFLiibbfAt1sPn/lHa9irj579gIeJGiC43TaqB6ck5+V
         FQDE1YuOgg3INETITU9xYFzODLegB00b9DBc+Qr29ujgQPd5AGFZ8+sTE2FXn7wPudoC
         TF0NWVd7GF7ZulS3RuN86xeiQE+NiweyBusbAI0YvBWY/nWScY8JpkOKdZIFh5SbCYVs
         aMR9xnisMNjy7HgwnAr0hmf0KMt1SbqJ1qvQgRFsE6VJA+fX2ke4rO73XsIW1u/zP+nl
         wf2ZcAUlQra20hn+rhQ1RqheE9QwyFcvth3DI6o2Dpf4N+CddH7y5G8+DinKiPM4DHYP
         CssQ==
X-Forwarded-Encrypted: i=1; AFNElJ+UxbJ2kUGUicStkyrjSK/n3TYIfFf2NBsMHGdglB/qeJOs3QTb/boLGDemO1zWBJCn2p2FCkqcKA==@kvack.org
X-Gm-Message-State: AOJu0YxXr9nQL6phCWGp77Ov1J1yuN0eQgLl2YeqjRakIpKOLyi7p421
	pZ1tv6N/dEOnr72aQyhY5zgJdyd7JtTNaNM4ReZqfF8v/gwfXUZeoj1C
X-Gm-Gg: Acq92OHGbOWr6A4Q7y4FHecCeK71ORAN1huU9CjGMAKHUJg25QTTgLyYHlb3og/nry4
	WA8f/S7iLFoGKtteeThSY5E/I0jYxiwBIClwMUiIWZVeIDgYeOo/0iHf3pA8IHN7G/Qxb+oM1mm
	leycFlrK0xk4/O/xe+Bw99Wkcl03JH8nESH/6dHLtsG81B9jzDvP5vgMNGEIuKAlYXNiGAAtJL0
	Fv74zDenQ6aeBapHWy7lQqAQZ6TFkcFcgF5ReXMrDsMiYnvm94j0skugS84EwlEQPH9blrvnq2m
	RrDX4++yoO2MiwLtocJatJ7FuEU9z1vBSw+2yqpua+t7NJvohUhqE/4X9KvLFnCYzr7NXnP/xOo
	7LomSoZfCU+6fQoN6t6wr0LROY0giz8bqI1Nkc6yHkm/1/uwLHpZXdxC/i9Y7ilzLdMzpAwupha
	tkI3SkbTWdPVcipuDgvySBxoC5LNjVaciJnw2A5VVlMkkTvJ7Xa5cLKTZXd/HYNbdfS/eqhrgtl
	TCeniHPtK+7mTOlobubNbcuu6NWR9Ilsx7D/Mh6Z+wa
X-Received: by 2002:a05:600c:1547:b0:48e:8499:4bd7 with SMTP id 5b1f17b1804b1-48fce9eb099mr21737525e9.17.1778658781539;
        Wed, 13 May 2026 00:53:01 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d19974sm52175545e9.2.2026.05.13.00.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 00:53:00 -0700 (PDT)
Date: Wed, 13 May 2026 08:52:58 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: fix page_cache_prev_miss() when no hole
 is found
Message-ID: <agQt2ohpc3TwR2Xa@fedora>
References: <20260512-prev_miss_fix-v2-1-4af8e5c1ae62@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512-prev_miss_fix-v2-1-4af8e5c1ae62@columbia.edu>
X-Rspam-User: 
X-Rspamd-Queue-Id: 59CDB18000D
X-Rspamd-Server: rspam04
X-Stat-Signature: x4p7mtes3uzu5dk4xsibx9jspy79cikj
X-HE-Tag: 1778658783-473094
X-HE-Meta: U2FsdGVkX19webOQjTKWos0pa/TFoJiIg76tl/HRPQvod5P71FrMOG26rNOxWs6C+4jfUGxvcZ57VexwyIoec2yheYXnupkF6tWtTS1us9jI03TNZ1UATb593KgbLx5WCtrwKzhucBgzpQRhi2ngApfjXW5Bp43PBBKYpmQZWj0F3ZR2vnUEj3XzRZsiC2IDmwztZGFKxo5kzqmzzZnFpNruJs9Hn0+08Zy/ys9acFnX2lcFNE7BJeCd3eCaQunjWQWt+7balnC8t7KrcbDlX4n3lWpjy9uzgyieeugxr0XHkHcU69a+7JwokiZsrNl6wEthuH2g3DBb40Y8j+VzQZ40cEGCCaUIKbHFMI4flOgmgBE2/J0IjZ8Sp4BGVxYecOYLqS0RMMuOsa9uu/Os9FkLjx1HeqOwvYVmV9RjlHjDHsfZF3Xe9Z3dvSHLOdrTJCzeL7RMWsspXmpRMzgKkahzMToZvDldjE7Bw2t7aCRfdSFAUdXKVhC/Bb8q5PSAaWC06soYI/2ZzAX1qBcH9+QDMBzhSTZgiS4tAqJKO5/ELjrmMYcjs3jY0w2zd/v5zXEiZ8AmUI3zHyNJnb/7J+efhgy7FSts/wleuqB1GdvscCeJN2cTIfXvf40qwOI6xpwy2X7g5dBJI3VdUtPTYywvfjbnpvKnNFk1CG4Ov280N0jlw/ollhy3guYlarmUdie44d0GptPGWOg0hvA34IAMdvtETA7bYVHEy8J+l9IyLILvcfCC9QcqDyQVOKlpia5s5MPThu76BgjRvq/mTQG0nP2tm14v2wFnfoEkXvZzgPc4FsCmJOVxIAyAdWAL4dLSkWlqlyv+AFmQ82hSNSGPLU1+8hst2lhiq6+l1JEZ8h16vrIf+sBIsu9w80QCDNJM1SGvjzCr5mXwKyGVfVprGVLSjBuUJ0Yu6W+1OF0Msrl9uMdNbIOzbeQo5xexif/eMlZTfE6fLCPf0sD
 FF3ylC3f
 ZBsZMLWFRPVBoyaH1aOa84EjIHYFDGZlPTAPQLXzPz9O3dG0sVlddyTuQhYONhN527iU89pSZ3i4KVo2KhH76ESkzrqir41ghq8mZXvJTsfEbPnMBgg2cmr6N1AVHezqvYsX+FidRx4nLHjOKkJioxTLLrJQjsZBr+gnifydWFjaVwY0xyNCC+yWHmSsc8mRjLBE6D38859nAazp6e6Cnsw8a/ExLdYTEHMEUOChW8LPSdromZKMmvA6xOqDLRhWSvSpzWtWUk6aSYbdPv1jd1cfJiXylfSSjMvFyIfw6OpcT1tfcMFGVtUaj1BQQwAfyOEI+DCueKgtduAkfu2eSZESrCu/ka4g4FSXAxf89uWWPpSZ06oTFuocftUjM2tauBgZpaMmMS7seGTEB3gWeLPScsNWqoA2gaJEDCvCSTebq8ayMwFFDFsqxGFxoCzOh74cF8E4pH/nbxI6BkLibxgsiXKuakbDQLiAco0HuqZQXhxt8Pf0E8WU7NhJq6nvyJXKL7r//EdTq7W1c5fsWwWPwHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 04:45:59PM -0400, Tal Zussman wrote:
> page_cache_prev_miss() is documented to return a value outside the
> searched range when no gap is found. However, the no-gap-found path
> returns xas.xa_index, which after a successful loop is the first index
> in the range. As such, that index is misreported as a gap.
> 
> The sole caller, page_cache_sync_ra(), uses the return value to estimate
> the cached run preceding a sequential read. In some cases, the buggy
> return value can undercount the contiguous range by one, shrinking the
> readahead window or pushing borderline requests into the
> small-random-read branch.
> 
> Fix this by returning the start of the range - 1 when no hole is found.
> Update page_cache_next_miss() for clarity as well.
> 
> Both helpers were previously fixed together in commit 9425c591e06a
> ("page cache: fix page_cache_next/prev_miss off by one"), but the fix
> was reverted because it caused a hugetlb performance regression. hugetlb
> no longer uses these functions and next_miss was subsequently refixed
> in commit 901a269ff3d5 ("filemap: fix page_cache_next_miss() when no
> hole found") and commit bbcaee20e03e ("readahead: fix return value of
> page_cache_next_miss() when no hole is found"), but prev_miss was not
> addressed.
> 
> This was found by pointing Claude Opus 4.7 at mm/filemap.c.
> 
> Fixes: 0d3f92966629 ("page cache: Convert hole search to XArray")
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

