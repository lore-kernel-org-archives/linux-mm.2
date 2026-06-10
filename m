Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A34CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 08:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21E46B0005; Wed, 10 Jun 2026 04:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D23B6B0088; Wed, 10 Jun 2026 04:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8D96B008A; Wed, 10 Jun 2026 04:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6666B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:24:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD376165309
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:24:44 +0000 (UTC)
X-FDA: 84863316888.22.0EA577F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0BEF3120002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:24:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/ngp8hc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781079883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxfrfbUI9GGDqUvaj1onis34PFT9knXsHoMZo2Kt22Y=;
	b=XNHB5lfQs2+4a20WGBweZLupEs/RC2DfkoRozb1MNPt6GRS2tYdrTkCxUPWvaBL3UzNs7e
	xiNPwFtfKC/0ACRME/ytdsX9aba1gbiMs3uC7CYR1ahNmoSW8bDQED6S6BU136jDmI/d3l
	A4C/qMwJdgfJgLFOIjgt2/a6hptk08U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/ngp8hc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781079883;
	b=gDrZsd02o+/K2xMOUGudW/brQyAAkeBVouNpn/Z0mpy0n+Ul4Nrcg3lmTrtZcP2q2dkEmO
	EvRThk/84OOlE1DRVAfIq5RZZe6iFcBCgLPbVAPleBM7acgbQeb5sMSgHiFHYCAcgUDjaN
	no5Cdgl0H0258rrtkFyP1jB8zsMcI6Q=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso54983885e9.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781079882; x=1781684682; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UxfrfbUI9GGDqUvaj1onis34PFT9knXsHoMZo2Kt22Y=;
        b=T/ngp8hc8hNlW3D0K2skidhmiwmeXqx3F9jLXnCl6n9vRdJfN8Fy1enXj0hrKq73B1
         vEzlsGkuUzOZewJuHXEJsWJcKgAciF8uwJmpka2fwpUQPf3OH7JbML6Iy+EiP9CCC8fR
         J974MsXPF26vZDTpMkoK8KARqBdwKXVUr/a6RikQDeW1WA/XE+0nIBx5rvgHeS1q43i8
         dmJ6ooTK3vkKAlSaLbG7TTSk+WFt9EgtGckU+GZZNkNq9f0cZ9JPZtOtjiMBWGEUIr6r
         mk10NvMmF+9kL2siRFBsKpNzj90n02P90O6VptQc0Tl/KpF9AMj5l60OQTajQsy/HzqB
         txyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781079882; x=1781684682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxfrfbUI9GGDqUvaj1onis34PFT9knXsHoMZo2Kt22Y=;
        b=BGA4jr/edCGUQTuxDi6JmUDkY6r0XDvGWwgX9tHCH8Id7P5yN87/SEMFtzBg6kqmUL
         1M0V+KehjpMutjb/O0Uo2u5LfcV19PxFQ79EdEMSlH+djEM2UMKIsfnwIT/qWwXbEP/0
         /4jbrsgMkC1FDC0tcEQl33k1cEPop7E4eoYRoLylFaqAP6No4eIXsD8iXa1+RrD++zbx
         ier5nnFMYlBVkweetaf+AunPUCpnpWDoCoVOeY38/JGPZK+UsNefX2PLHgw8WwRMIksM
         rm4/shESKP9hGkEGCPBh8wxJZqyhdZ7+hxA06B9nJIZ3BVdbYeL17DM9I2zVrfFaYnkK
         mtuA==
X-Forwarded-Encrypted: i=1; AFNElJ9LAOTgm/ov5x+ZI8raIjTT8PKd6uIgeH0z0PvMnCYdUQnKqJmnU/7zlnQh3wpzjAijFAE+F+UHyw==@kvack.org
X-Gm-Message-State: AOJu0YykS9z8KkdwNWb9LlyWupV028BMi5FwDFSErsWzl7BWm0hDFiau
	OJv7fUQ8N1w5aEyzWZelCS40TOmLgLoNAszcoh3eA5eEMsbtBI2MmPyR
X-Gm-Gg: Acq92OGhPsqVz4n2XVd95+BYbcvlcCTDr8gKn6ICt1zPBHwCsf9sp93NbLeuOe5g1gP
	272JCkEJYjawPTXSukS1Rz9OHpjJuyvzANWbAAcVJynaP7aV5gA+08Zr4twb+djoVz8ofXsuQ4d
	PNyA7kS5AXz8pca78JlV4/P5VxqjN1IMt92c2njMV5eYymxQSuRDZa44hF+0MKo7BKiZecbQsiW
	vQKjHNpsRX4wGQmpiEIXn6TClm0z6Jwv0CAKcs31Img7qzEkvHdoFvkGE7phfKmp1fgCgwcXTNm
	kNszZ6x0qZSrUpGnuApR0q7naIO+jRHdS+ZpKWSeXrh1Xr85E+LBVFVl8zIEomdYErXaNJfuUU/
	6lthv+9+St/nPuubKqw7zq3QgfQ/tJOO2oUnBUrhvFVMh4kbzWM367Y/oWt36xD3d2E1JPZ/yJx
	Cg8y3IRUv5RG3VVQVJ5SADWs7AqIC/9K2f1XqP/JGeO4c6d88LRFN8MeL1lY4DApEf1OgBClb3Z
	VOooOTTTeoMRYXie0Je6AInVackU5KFgXXdUsiFe9jd
X-Received: by 2002:a05:600c:a088:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-490c25fc129mr372415685e9.16.1781079881432;
        Wed, 10 Jun 2026 01:24:41 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344558sm66583318f8f.18.2026.06.10.01.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 01:24:41 -0700 (PDT)
Date: Wed, 10 Jun 2026 09:24:39 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 6/6] mm: Remove __folio_index
Message-ID: <aikfR2wWke8lSyab@fedora>
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608210618.3437216-7-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0BEF3120002
X-Stat-Signature: 5o8stxhra54g84tatqq3n94jwz7t1xow
X-HE-Tag: 1781079882-238877
X-HE-Meta: U2FsdGVkX1/Iwfn5/yGjV42eKfTZ2fNPvjkngJTcQzqFAN+mb4qFzuyAf1jF/0h+3h4mJJw1PiGrXPtRVHcu1r1numYM229tGKBtLPdXPVs1y2RngorC4M5joiWH46vceriZZUOKQrfk2haVAp0F8gNIFbfGW0/h0H2nATjdAA9X0p5IJu8pXMcugjYCPoTtcEFsdT6njhCUXV41XIfmbO5bBqdq5/7RU/r5Wx8HNp0laDx2AnFTNWex5W5PjXUtPvL/5sn0GjVsqL7zsStnPTsV/ADCpm13vrvfbWhdom+5zBy0196b8DtvZ1Z0SlTNVZcpkdWjJwdBl4P90QLd9E42ul0r07BpOHPqK8cXN9+kXZylf+8awwjG63hzeQDtC3CM5Sx/pSa79SXVzE1+nE/NL9O9nPugNrFQHEQDCiiUS/b+YNvWZWlR5NXUhdznp9Md4gVPbWStAJ10ch6M5pi8FE7jpenLgTt/QyEai1gVv0EFFsHopZ02z09666KPYtOQXHV2ThzLOT++PGXP0EVgrKKwl8eLngpumxoUn7KSjSCp7xcISjdidp0Fh76Ca2qH+66UYQaUo/vDiRZyKp6EOF302HCUYHgXPlztZ8G27Qs8c6jnuaFgI3nvWB+lA73W91/H7O0PIXz/F/hh2EmXWuOSvFFPSD92vaC3v98DfaKuyal7WxbgdP0LmGTYuNlOmA09ESlucSpXvRHeLQie9iuDTXGsU8HeZIgNmkMrAmnxFj68pS4awlndFO+kDS92odUrMAeSzf6zHKXl5k8XjaaXqLgd+s1fS3yUgMFEBvxWNw7/y9OHuFQgwv5hpZE9XtOIalMwNTWOhAHow08SRjVg9KPW5S7ExNwvVPdOYZZK89ADtP8TwYL7nzFQ+eFJGmVDK5pvYoR9B+8rFxE4nm7kavFtU6c9xE+o+TA6SyDjvSvqAKZjg3fy9GQLi4uAv9ZZM0nUPkKeKrH
 /eNBPDWV
 MyrJV+dMS6rzu7uM6fuySNb8JmAq2nLkEOFem+vhTMvfbMogXixzez2MhALfcvk9jkHv7S2Y7+36+7AcmYb/dWq8wT2TzwbF+ImTUAvb77VoCGq7cOJ6GykvL3IevWD45HYHfV/W2GdWVRbE4QXiAjI0F2Q6+V/em915NaV5X2mw6jxba4d2EBfatajo3IFMT28v/ZrRzmjjdlqGbEGaM5ut71CjOB3LXzUbhe7sptaoKQ6ouHn0IGHkySIDAK1fawmb5qGz3fDBEbe3Hx3Fq3QYLogM/l0mHl0y8o1nd9TTa8gvS9Aov5j1yvBcaGNk5bmm5mapAJjpK3PsX3YuTqRQrAnqJGmOXaYM4OYxoD1dgptt+AVTUZyfRyZZ6VuuYSMfLBNq7xc9wHTZmDQQHSjbGvl2xr3qdjDSF8UP5ig5creptdLZnPEzGzfIDRSDrtwYAFz0hgQbKPum2JDXGfW8SJjeoP9fSTZd7DMSD8ofkMBN1TIOIOAB7Wl3xFClpkr2WS2Nrxy9l90OihHO0WUSlEdJFBVGXUWjE/xupDKVnsOmFAlBKQaPp/s7ZKQZ6pglZXKe9F6W86kLZLIxJ2FqMIKLj86o5INxVcISZ6+G5hU6KjH+alCm7Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 10:06:16PM +0100, Matthew Wilcox (Oracle) wrote:
> People have been abusing the existence of __folio_index.  Since that
> was too subtle for them, unname it entirely.  Now we can't use it in the
> FOLIO_MATCH, TABLE_MATCH and ZPDESC_MATCH macros, but that's OK, since
> we don't care whether these fields alias index or some other field.
> Also remove page->share since all users have been converted to use
> folio->share and I'm absolutely certain somebody will start to access
> folio->index through page->share if it's not removed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

