Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A3DCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7ED6B008A; Thu,  8 Oct 2026 07:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98766B008C; Thu,  8 Oct 2026 07:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87CA6B0092; Thu,  8 Oct 2026 07:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8868A6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:03:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDA3B1A0235
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:03:11 +0000 (UTC)
X-FDA: 85299172182.01.BD62DB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2F96620007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:03:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAVmJjBI;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791457390;
	b=h8yoB++98gEKy9t0pY67KcqRqanBqUSzjQgCXyWdPjtTwSkNVnOqxMx0hD8PkYCz9y3f1y
	cuc6VXwlM8vJnqQ6eTdyRxe/NvWe/mLD0goSkLzLoC80KzEY2HojnHYBEKald55EOaLPWu
	LsJb7zaNoauBnOPd3uLC+Dl1ptQwjiY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAVmJjBI;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791457390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNz03hoQuLTPLmODe4X22Nqc2wYePi16QvJhZl3Ebqg=;
	b=HlCC4Oq07BZVtDV83Gt9C2yEDLz+AlyT034E9wMVZ0IyLXhj+yYxBhUlnRuv4khUx6anPQ
	VNvySSCQ6iyMpjNy7yLlI365t6P4YYV653jjU/3EC7foRp2LY7qWfr3NZmDfkTMQYOblvF
	NlrAerLPde+LC5VHrz/CqyWxVUzjEwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52624437BE;
	Thu,  8 Oct 2026 11:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D0B1F000FF;
	Thu,  8 Oct 2026 11:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791457389;
	bh=gNz03hoQuLTPLmODe4X22Nqc2wYePi16QvJhZl3Ebqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAVmJjBI8cvnQku+ApaPK1GU9jP5riZ4R1FzJs98f59m9C76SLWmBxbPZ6XwBO4mg
	 aozhZJbItKm3nDk7GreN8xj9OmnxWQW/er+sYb1ZgZ+hkO01B+RAaejwnGuQ+iiJmD
	 MruMd5LJhnV2qIrPSyH+1mQY6NyLou6dcAu6meVb1lqudko1eDamV/BhxZXxB8XAWZ
	 BCqzU0PEek2oNz2XW8RAoHcmp67j7eGhvlwyt1ad7Smud3qmEWFmywfBwZWGDPJ62Q
	 DiSC7veZwPhKDu8TLK00WmmuhwxcQoeNewyakyr4RGLHygmE+NIwl9qxx4M4wEk6AP
	 mcERGONh1poUg==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
Date: Thu,  8 Oct 2026 04:03:04 -0700
Message-ID: <20261008110304.41485-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007154851.45368-3-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F96620007
X-Rspam-User: 
X-Stat-Signature: 7c9ihhpu1mf53cper5wppbkxzkbnnrat
X-HE-Tag: 1791457390-812077
X-HE-Meta: U2FsdGVkX1/dH2S962C/UfVBD4Aqwx54ltzn6n/qFo+dBfB5c9LoHCbylDw4mAP6/OG4sQdRs72BO6PfNe6Llql54cHzG4iXyRTuL91nYJMWL9wm6hczI+VTfJBg3qm3LhLdWLgDB0o0UDOfBX2XfSD6efVjVSzUwP4vUnYssm35YNvVmukspnKccwtBgyI4ScwLwkOuH262B6gMo6zBNC4Mc/vzAPd3hkZnr/E8yWCzI+L4ikqNtqoTyFsgUqWk2VFDyXZluhlF2dC+IUMOAQUaB04/wVC06tfceOLtm88Wv4ovcsUJndluNekY/NXbvC3dH3CyxrjdFvQmgidPbKl9DP7vEOOkD3xNmVKTLLZb6WqfxMz+yF6KmjlHFOl2Ppq17D3mnWs48gpuLcz1fy880KcKGmtc2DTWfWejBOd7kz9jbd+4CFEMMCY7oRyEPRKh0q5Pl5SSgCS2yRQbqtJKPtCeivDx4We6v2srwp8LiX5OaZ/XwKN723uNETNd0iqs3itb6voY2rzG2G5JzDXdRUPZBx5iTFGLjEzrQ1n1GslF9pzHc/v+QGdBkGik7+xhzrpTUHBTYVVyA3l+I1wiigFFHANMaqrdYR8rZLp8NuB0+oFs9Mr4LAMqz7+E2Be8AdcuIv7jRMnLVy0j79F/n9+dJ7/jKabTVpo70kQoWsfqZUY2UzRFiqRz6kLHXZLsEd2uO+Er2zxXyBKnZDrRc7x1GhZ/U3MxbFd06mW3GdJV0TbD1szL4tq+dmwv6vTX9oQqEGQ6fO7mjbsssEKcR+ePhnwVuvHP2O3htBAhKcFyhvDNmWyvo4XHrkoYYIS7l7HuezlG+ATgkXhFjwxx/W7BW81W8goIoVT1LhZo1vd86U6RCPyuE7F7tPskaBhEscijUSvEL0PyRcBWhjCgITGeun1noW4vAjbC88RdBPQDL9+BJMAnDrh5mN7m957a76Q5hgfq/PaIX5V
 bV9iDUSE
 0i/mqVzoats3FRGdEWr9SgaE+xFiUAinOeEjd6mIbh3rNlV8wfK5SoY4Hys1frLWvt6f2TGmtxbW43M/tpx+574cmxiLBjd7MhUHIuJcuskhYmUVMCBrcLOluAoDix8OQgZ2EPBXVeq6kxTzAW3rYYPSIjZS5lrW20a4IhTSm3V32O4oykLVrvfhJfXkn8AShtaS4RLOxIYrBZ+3s8tgtd6vfxOjHwb+R0yEiQ1+QxGHvXSa5ADgL4+e9pCMeCs09chYPCuTk04R6bfP0n6jMQ2xq0bHdxejt9ooCWlT8AEWZUu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Suhaas,


From the next time, please send a patch series as a single thread, with a cover
letter.

On Wed,  7 Oct 2026 21:18:46 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> In damon_split_region_at(), we copy the entire probe_hits[] and
> last_probe_hits[] arrays of DAMON_MAX_PROBES size. However it is possible
> that the number of probes installed is less than DAMON_MAX_PROBES, in which
> case one or more iterations is/are redundant. To remedy this, iterate over
> only as many times as the number of installed probes. To do so, accept a
> struct damon_ctx pointer in damon_split_region_at(), and update all
> invocations of the function to pass the new argument.
> 
> Also update damon_test_split_at() and damos_test_filter_out() in
> core-kunit.h to supply a context to function paths that call
> damon_split_region_at().
> 
> Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
> ---
>  mm/damon/core.c             | 42 +++++++++++++++++---------------
>  mm/damon/tests/core-kunit.h | 48 ++++++++++++++++++++++++++++++-------
>  2 files changed, 63 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index a3af5ee685e1..025df4d19e20 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2049,8 +2049,8 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
>  	return sz;
>  }
>  
> -static int damon_split_region_at(struct damon_target *t,
> -				  struct damon_region *r, unsigned long sz_r);
> +static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
> +				 struct damon_region *r, unsigned long sz_r);

Please wrap lines for 80 columns [1] limit per line.  Same for below.

[...]
> @@ -2494,9 +2494,9 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
>   *
>   * Return: true if the region should be skipped, false otherwise.
>   */
> -static bool damos_skip_charged_region(struct damon_target *t,
> -		struct damon_region *r, struct damos *s,
> -		unsigned long min_region_sz)
> +static bool damos_skip_charged_region(struct damon_ctx *ctx, struct damon_target *t,
> +				      struct damon_region *r, struct damos *s,
> +				      unsigned long min_region_sz)

Please update the comment above to document the new parameter.

[...]
> @@ -3643,10 +3643,12 @@ static void damon_verify_split_region_at(struct damon_region *r,
>   *
>   * Return: 0 on success, negative error code otherwise.
>   */
> -static int damon_split_region_at(struct damon_target *t,
> -				  struct damon_region *r, unsigned long sz_r)
> +static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
> +				 struct damon_region *r, unsigned long sz_r)

Ditto.

[...]

[1] https://docs.kernel.org/process/coding-style.html#breaking-long-lines-and-strings


Thanks,
SJ

