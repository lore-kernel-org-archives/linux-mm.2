Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDA6CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 17:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F598E000B; Wed, 10 Sep 2025 13:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56D88E0001; Wed, 10 Sep 2025 13:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C933D8E000B; Wed, 10 Sep 2025 13:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B53FB8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:33:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F76384295
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:33:20 +0000 (UTC)
X-FDA: 83874036960.15.2F707DA
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2347180012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:33:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=ZauiXeVo;
	spf=pass (imf16.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757525598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gI/tjHs59XSw1Z7ga1ZDRXQNdOcJy76Xz3GGRpxfHcE=;
	b=yQDXfh/lj/LtFjcEgtHNw8PpZe1FkttYuQWgl1xZ7kLn2CbY5+Fd55frgUpmoaFTuHCyNV
	3GqYkpxSpBYQmUaaAQT070klpoc8xZA+iMl2hJV8wCSeRNYDlQqx/n9UAdUG6XJG7ZsZTb
	/etxk/dxtHMiUG3/ygkZxwMN0zxeQU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757525598; a=rsa-sha256;
	cv=none;
	b=z03Gbesc4vtYbGWkElDNyr1rII7su4pvFK1Saw+7mras9Lo+oWXXP04IAFcLTzJ1aOlO8z
	IUOCtKknzo7iovOlegyXYCxPyhREdu6xDnjiXDLge6YfdU8PapZXLuRZeE3CxMAI27Mb9c
	pDUsczSJs53SFq+mOuU4MKx8j2hLym0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=ZauiXeVo;
	spf=pass (imf16.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757525597;
	bh=VPOBUT7G/nFmhNG03qHZmCe5FzXyRf1EgbQKpSi6ByA=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=ZauiXeVo6n6Wt2pCSVQgUBJYBZUU3s1V7ogX51OG4Yq15YES5talMPTMlddRwU18f
	 uLyDb04cxaMPHszDDbfwYONEJg0pMOORUPTRD1BV2TDC07m6zmZcbM6JvuxCcDEVv8
	 yqVV7jrC5gMfdIEhFr0gGt+TiGtKnOm3UEYma9Rs=
Received: by gentwo.org (Postfix, from userid 1003)
	id 880004033E; Wed, 10 Sep 2025 10:33:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 86A194033A;
	Wed, 10 Sep 2025 10:33:17 -0700 (PDT)
Date: Wed, 10 Sep 2025 10:33:17 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
    Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 05/22] mm: Constify compound_order() and page_size()
In-Reply-To: <20250910115507.1991829-6-willy@infradead.org>
Message-ID: <95825dd2-1247-c346-0f8a-3c82afa49a46@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: oumzyn58mxoc3fynhu3n87hroi9hbsat
X-Rspam-User: 
X-Rspamd-Queue-Id: B2347180012
X-Rspamd-Server: rspam10
X-HE-Tag: 1757525598-524747
X-HE-Meta: U2FsdGVkX1+kwq6mcFN0kaRUwpYdvxw6rTzPRQJOEBrWKGHPzUpx44hRTDm3CXzR95ppjGBMj3ICHXwDw/3xsG/AxYw3UixJ6OIoomRgl1tzGRQuRgo1l11wf43YoDZxHE3CRy4qXXxihDRpJ6jL47+Qi/PmDio6NV+fh9+NEXzCxog12qGXpokXVzzVbsbHR+ety54FhLL0P1s6tE6+7gtWMUazFnJpLDkc+kZeFFTrr07yGdciqOak0FZBqewUrwG5nXsCz9imt/znUbsM9v4TT87kz4MSIN71oQExa02DwjRC5IgsRJT0I0o7JmdBpjUvs20aCoJxV98YCbvM6oXt/xtg7QbRtupdIAY93jLo5HWNYotavks3m1uObatCZpuqbMKHTV75EII0mfkLfjyu4OGHgwGqz5lU/vzaF24j12FxAUxCeX5NJ/NsHK+/nI08ppAvUQNV5+x04jLVzR1BtlQ0dNno/VG8L6qa2dQApr3QTAAIUnteXJ7qDKbiLTonZOq8R9CC+kLjZuANSxgp1whrnXu0pcqEclbUnP9fdrnoQFyLEI/uei75+wFqUJkX5zqIYWP8r1IRztSmYu+gwUUUUZKxLtUn4QHLViW1iuKuRidQ7czRc0/430e3z5d1CcXCedYW5K0wA49Bg2Sqn3JWQIFe9Cv/LYMW1u5KRCbw40AsOEIl6UvVqr2vQnV4XpwjLXEbeGqi3xY7Xjwo5Ppc/MTJxc2/qNRyj1PA5Q6JI+KK6ByL1N3unl1lorpsTUkHTLmbshAy4OmLve2B66f5sCy0q06v9B/8xYhxyuQ/elbAdI2lu5o9P8E0D6tvFXKGHPPkMmohBT6q0NedunHJQBWvGOXNyIWUoug5aJj0FPHfhN5w5TLJwmpX7mgYAhBRMmrYAELp6XlNikfzaBQgqN+WQWOGdPVngRUzREUNQVldJxl6PHOBsjQxPwLaT+t2co5vh0pS34H
 3jUErtlX
 stHdHVOylDRz3dSPYeu3iTJjfSRF4VL5SU9PkkQst/VshjFQrCKVkIkXuKvrXCg2BWQWLf0HkuxPbiwbVnQhU4wZj2LVrC6DnZHkzZ0Q9I7SN3YD6B9lqOOEAlna5/rOLZSnp98/SotB0s78s/i6rXNhpX4V4pbYqU8vECWjb4wDzju4VlVoNw6kChD04eYABE6NUGSFJV1uXQNwoQOllBR6c0xcxvQOLyqSt8jWxrmq+JJOnIi1N2+922cmAY+d3z4e1ixVG6N9QwNFGcBDEpDd7fi4QH2dtT5lRgG3IiTZ0UeSH2kM5+DtI39HNVLtA+9v24BwUvvWChfroxjNz0QoezwULaTCWbpjxI/7pb6FbE0DYXdPWW0P8NyBDg+0YU2k9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:

> These functions do not modify their arguments.  Telling the compiler
> this may improve code generation, and allows us to pass const arguments
> from other functions.

Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>

The patch looks like it could be merged independently.


