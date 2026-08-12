Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48B37C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B35C6B016E; Wed, 12 Aug 2026 10:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065276B02A0; Wed, 12 Aug 2026 10:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F986B02A1; Wed, 12 Aug 2026 10:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C169A6B016E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:09:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5091F160391
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:09:01 +0000 (UTC)
X-FDA: 85092798882.07.44563AC
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B8ED40012
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:08:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k6ol7Waw;
	spf=pass (imf27.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786543739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nzV6WlxbIAg8UqrumPBkuydUfiC8qMZf5ogneGtVSg=;
	b=4X2IbA3gjpED8A5iN3ioI/a1Cq7Re8965CCHVxQP52nJId8nlDYsFKSpZIAM2NJ+qUjbLE
	sDDSLqjpiD0Q8B9wyveiJmn2okpdVUkmVpjXq8g9FiAcKoykmBxtsiWiryjEQaX7sfXQ1w
	i3mZAWMa2PEjmz+axrHtsXYNvjhHvlI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k6ol7Waw;
	spf=pass (imf27.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786543739;
	b=0Q4DuG/M5pWToQFHj+wwXdrt1GYCNzAYFNJD90nFatAMSDfXmaBb9oZJ+zVaY8Y63eqMab
	A4fdrx5XFM9YQB76zOoAQ9Bufh1tXvxhfszntHGAxjY/TUZ8Lx5au8SQSEyNkygptwAgE/
	wZp3UrwahcPVE9DeGRjNmm+UlmQWv3E=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2caea3f742bso13999545ad.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786543738; x=1787148538; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/nzV6WlxbIAg8UqrumPBkuydUfiC8qMZf5ogneGtVSg=;
        b=k6ol7WawBuXncmFKS1vPdvg88rbL1ImHLW5HWTAT+N3j1rPwO/E9Rtf/rO8++ICMqT
         tkiHjZQq/5JeEgAK41oDwxq8lzac48pgPOFyLFUP4Lpv4KxXVmpR6wMjOlm5mPPHOIHS
         IrIPcuxYiygGqhdjyQ+BECP+TInTkL7wzKsSgRRHJqlCWJXXbH20bTPbTchrW/i4dgQw
         mhC6ZnOO7YCIpvugfHIYjH7iCMMmy7/O2MH+vSWlLPdEIn9GOUMW1zh0iFXqHgVij6EE
         Q/tX03Ezd6Jpf6O6Xeg1JILaW7cUA5/AyidJe/YtjHu5gdLEydHRqxux+w2UNfRTm8Qy
         tKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786543738; x=1787148538;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/nzV6WlxbIAg8UqrumPBkuydUfiC8qMZf5ogneGtVSg=;
        b=LN1vg4VQlFuTi8FJqjE/Mr8isW6yTwOS+nhnTGqCOxcAvcrH/+TU6iuvhusM/Swaxj
         ky5CBjDlhuSlo77jKoV31dkIuKszWD4f/N3qmzGLVxdF7IAKomt+4gelBPG/hF53oLjw
         sR3lR2socsRNHUhC6/iosU/goaKci0QrLYIR+nvXQRsHvj/h7p3KZa9CMU6v7ggkhwiG
         dpHQEKhlwxGchqLlC8ZrkL0qawYEu6828hnQ5y0mFygwpfM9WAhzhxQFdsK8ZAyDw8DM
         BA8OxP5+7SPXtAwn/M7PUxxMdee4MijR42/co0kD/tthtQChxSOzPn0lzV/v5OPjrR3G
         qFEQ==
X-Forwarded-Encrypted: i=1; AHgh+RrSgquSAlAJkVBYeI8kyK1lD2yIK+/pJUfulFKfq9xGfIjqddrqYJqEVm57wIuCYthiC0boyUK8VA==@kvack.org
X-Gm-Message-State: AOJu0YyegKyB61sTgO94qZJ0MQdYyok1pNUCD17MwowcKJNg2xL5yPs4
	vyK6JY93ZyIuTIu7/rG+w3NTRAxlePfunfWDR3DPrGnFH9ctv93ukVvY
X-Gm-Gg: AR+sD10HNXu91wE+AJG6IwgqWzvgmfM/nCe6IpEi/cjffi6VgbBtAou+yqOmCjN/t7e
	wTlJJgKYynlH9irk1084TdtXac1u5tdZoVJ178gEAs8Ct839VMPnZ0LUUhEMzSFVCHDEh6wOALz
	9iFxCsHhdul8aWGgqhfhCeI55zaJg55abjHyzBI3o6tncjY+I/i6f9wbRnCpW0ykPgbmDtqn4EA
	hfdkT+NvoB14huLJOQJs92ufNc6Hea1JPCjqIYs4VxRgcURRMUrhwK3WAIU+L5b0T97yd3N2gsi
	uJHNEEMqyDfPuvAeeV8qXLOJfc4AfyOgpg1MdBNklUNyO51ZZoKy3daVyxLdYjZjnq9bXkOJ6Ke
	AiCpCfpoxs/n10kKRtA9/rjC1pRGnuJnPFWuBBHFYrXwFwnGzNBzggJq/Ei/qTJh7Jw27ETj4Q/
	8ylaDmdiWw0KuXoO93nyT7lYyQ4e1drlbQisBVcVHsl8GegCH4ce2dwEjyMQUwRjJq6HdIu5eX
X-Received: by 2002:a17:90b:268b:b0:37f:e177:f58 with SMTP id 98e67ed59e1d1-3930145ea9emr6278923a91.9.1786543738282;
        Wed, 12 Aug 2026 07:08:58 -0700 (PDT)
Received: from localhost.localdomain ([49.79.111.198])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f88d2a8esm3901229a91.7.2026.08.12.07.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:08:57 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:08:49 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: don't pass swap entry value to
 trace_mm_khugepaged_scan_file()
Message-ID: <7328756b-ad4f-4cfe-8d55-4659510212de@gmail.com>
References: <20260811133655.267739-1-vernon2gm@gmail.com>
 <20260811121225.fe45676262404b82270843a1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811121225.fe45676262404b82270843a1@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B8ED40012
X-Stat-Signature: 3sjggkxkfbrg73dusef7z4i9gqnqwgh9
X-Rspam-User: 
X-HE-Tag: 1786543739-834800
X-HE-Meta: U2FsdGVkX18jFQe2ET/ogWFlVpHIyhKzVBs4yRtJeA8QV4clxuJoldsn9kfu7kk79xolVnrxgMdpyP3D94bbzx3qfjQI3vHdLOr5En621b8vjL+SMpE1F6N0lXmCows3FoZrAJkxupK6xUBtNT8XEncWB2KsEh4/63KCnWbg4Xi8eLfdD45DsrhfC6ZlwYNi/dUlniA2TlofY77uNDOmDFni5e7xdf4JA0f5Yj/BjM/blSlLxE0SJiZ9t70D+b1ChUbsTz/Cz0gSn5+gRBj0qsrx/L6s0zFDdHiOQSrisM8OwoNP+67ROgo6j4F/LNScPi3lEcr9YOORaSwv8iq96AJqoiyBuC/Uk7TQUberzTcBa66XtKCcKP01PRuHI8NZQBfGOjV2VfSDOXMgPbjNhO/ITl3k0SiuP1qoHpB6YtsfABmEm7EeN+kp65+JWU/qewxVCabJS2EQin4mf0IH8njY+vXFVdDmSKUbubuy3yHz7iOZtwFVuC86TRFUIx5vIyn8dnWVVWgxP7D1Ip+xjcunLyz25l8gqNhV/2D8sfNyfABZgYHBgld7ZrbdCu6WwviYcj5kV3UxnhgP+U9pJg90JeuMWOECPMEZ8Pc2NVz/vf2AL6CvX/tIsxZvb63w/XGN47LADudp2NyqtNw52T3DoX5eGsmYtMug+Xg6snzTu/ZC3aiqVLvRsUDXzwVKNFFoODDkTP29nu0gJZtNRPUcODo/tlnOt5p2e5dfrVpaEjGSee8rOHoM5+cq/xyx5/JAn21xTXYQw0ymq0P/wua9WYTUr6LTWBISnTKXUhylUdHiqwa/GOKJwn+AkswL0C/B6RHvw1F7WHSABWszSoQE+hiSk9kGrjab/1+Ixl802tGENtSVUX5oKTRh+1fWbl70McnsH+VXChAfobiNiLSwRZ43ssIsfzt/CLXuFJ3W1aO0/kaGw379OeG6fY5kuu36exFXAL9slvignjc
 k0BsOoel
 e5EwbygJq+gAgZCObvLivVqM2a1AaBkkM7L5tj/m4K9BfYWGldYJndD74zytC/Iz0vwHMD0ZqIJ0CgH5RTpleDHjviT4lOsiXwoPV+PIxNWhr+uDliCtoag2GO2Z6Jndw+V35sws7fpPLW6j/v8CW9S+X3giwrsffKxNUWw1cO6sQUqChUHHyfWXJGyXJQUMWc1SgZTQuqlgtjaE7SIl9lQRd0hC0cgIuoEzgBPjRIp7ZtK039A6k0rGUQT4xFQIOqMsuthrap5YjG2OItgYZbVEZFAVJJYKV0Dp1EoflRT7bPx3J4khZHvN2BbjurCbJHt8RhgcjI1S9Vcy4cjMGhBmELR6ayZGy1TT+/RuyiwrHIabwrxR2C0O58mVHLfU/5Uxno2K/Tb4XuA3fXs3g9PaRxiISSmwSMxUt1v0dONgyEL5A+3U2p4aEVe6JtqzxxDffotqcGfVUJIDEOZ0jbM8jvYmdpw6Mlxb7lFdppguanguTFnXt4HfgZ7EkZ6Yn8633K/MREeEj05LLzuq+UQ6CV8JMg0q4mtaeBaoldVtr5bkSN/Py0WZIGeU8xVyyNf8A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 12:12:25PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 21:36:55 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
>
> > When the swap entries found exceed max_ptes_swap, the loop is left via
> > break with folio still holding the xarray value that encodes the swap
> > entry, not valid folio pointer.
> >
> > That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> > to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> > plain pointer arithmetic, so the trace event merely prints bogus
> > scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> > dereferencing the tiny encoded integer and oopsing khugepaged whenever
> > the trace event is enabled.
> >
> > So set folio to NULL before breaking out, the tracepoint maps NULL to
> > scan_pfn of -1, just like exhausted scan naturally.
> >
> > Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
>
> Added in 2022.  Why so long - do people not use tracing?

For most architectures, SPARSEMEM_VMEMMAP is the default, where
page_to_pfn() is plain pointer arithmetic, merely printing bogus
scan_pfn. Only on classic SPARSEMEM, the swap entry value cause
khugepaged to oops.

> Sashiko might have a found a couple of other tracing bugs in this code,
> which I suggest are on-topic for your patch:
>
> 	https://sashiko.dev/#/patchset/20260811133655.267739-1-vernon2gm@gmail.com
>

David also mentioned "Using the folio after dropping the reference",
and the same issue exists in
trace_mm_khugepaged_collapse_file()/trace_mm_khugepaged_scan_pmd(),
which merely prints a overdue scan_pfn without oopsing khugepaged.
However, this approach does have potential issues, just that they
haven't been triggered yet. I can fix them together.

I will add PATCH#2 and PATCH#3 in the next version of the patchset to
fix the other two trace_xxx() functions, rather than mixing them
together into one large patch.

> Also a possible bug mapping large folios which straddle i_size, which
> is a separate thing.

Yes, I will submit a separate fix patch later to resolve this issue.

--
Cheers,
Vernon

