Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E436BC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C726B009E; Tue,  7 Jul 2026 11:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4356B00A0; Tue,  7 Jul 2026 11:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22066B00A1; Tue,  7 Jul 2026 11:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE6B6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:21:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 001FD404A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:21:56 +0000 (UTC)
X-FDA: 84962345832.10.44B6254
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A8FF18000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:21:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2vOWI17;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783437715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZqNR/hJXyHATC8osIHWTwdsl59/ylbDsciT2VvP7vg=;
	b=ovIIddDjxWqCWWdz5jSM0XxO4rR9s1eDic3K0LJYkFrD20I6tQ1LRLD/4gdKB/Pha6hnvK
	vxi2Bc5u7IHYr0fGNqHu7LBobQBEjIdVmZBm/98epkGrgwIleYVECwbw5k4VkiXaZ64W9y
	nLCpl6KWVODtMIWcZLvuXMwS8ey9+Kg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2vOWI17;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783437715;
	b=YJhpEczryzLRNNHXWmYMZyBxHJvb/mVs+hecUz41LHxiCOTMAkvwzTZZ6alJu6DS/AJ/jE
	9VndZ3PmsGzoMBab2TNOonzTZXWoAgmPvHDg5METbjVqLATiRd28XBn2qK6iGYNZ0NBX/e
	XL9aRW1M1HV+qWjKQxE1NYBeXHf3L/I=
Date: Tue, 7 Jul 2026 08:21:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783437713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZqNR/hJXyHATC8osIHWTwdsl59/ylbDsciT2VvP7vg=;
	b=T2vOWI17ZaQmdSdcTfCIq8RSHmwO1JxMP+uS0DshR7eLGTIruOYdwVJhBg4rsQ+yP7YCEy
	tVn7G5NKc/4cfFHNY3AnOjDNirTR4OXin3Bh/koAzLcsRgac1epGqj/A0SLwmEkKGbBkVc
	GL2bNfd9Xm+0SVTXxLJubUZCOMqRbso=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shikemeng@huaweicloud.com, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <ak0ZSNf1CulQasME@linux.dev>
References: <20260701235955.36126-1-baohua@kernel.org>
 <20260701235955.36126-2-baohua@kernel.org>
 <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A8FF18000E
X-Stat-Signature: jkxxcc5owtbnk5wxqj8oydwsh8nme53f
X-HE-Tag: 1783437714-956853
X-HE-Meta: U2FsdGVkX19NNt3IyNsCexNFcYFIEhAGSQcA4v0ZIOikaz3cLjYKQ4RLiRt2SDy9t4ngTALSKrT21JkBtnZ6c8NVsWWtUrNqOUQDggB8xmGp0/k6U6Z3GpahzePhvgcJeLXkBnPPYX8CDznndQq4t1zUb4/zjG9gSperqQSfTKTn1VBqHWGZzEr5vAfD778KmMe+107zAIXxBMrNL72UgfS5mxgLkcm1inJd3ca5nMJI+yRuZqDOMhIRa036vo3SZzrlqCMQAW6V4/8K2+MwGgKLbym/krGZLzSZABLHk+A2LjSTY+yyiI8zvbIdmw86xarndc80zjyLIZ5EdJ6Iaf4eyRobgXNw/8Qud2pSR0vfxMz8LGXQGjGIXuLz3lPvRua14TIWF2YUKdx5UJQVCqB1nWH2xQX/zKkLoExqAdv6laTfY18XkbmOhiAC9F2zOWTLX0L+Pss0C/JmvhlsHov1PDA83veZDb+MKYv2Qljm5oYgO/QcFzdP2j1CizAUueb7D0fsqpVeLzvp4mJjv3woyFCWnLFz9KJaFdaIlofEFN7o9kHCuGfAbG7+y0sIpkXTbytW4MUpCgbiXnjd8n1pcQAyNv8BUpb6VPwGuMM0qAxA7yFMYIi3Smx1WXDLjxhgC/0QzuVUeKQy1wRAFSeMhiPZOB2Um+trVXlz3ClWzxlRrWXJb0NQ5H1P0l//0LUvHHOBGYtssPVl6ofswqL0AC91U+h3GhIMYapbEw6fNW2m7j0rqPMwp2QEP6UDcG8OVoQMJQz5y91iMx5GFTFVsUfQ1N3N30NIwMF6TQvI32LalP3QFZwMxGXkwFYPuxQpmOqECsHoNAiBSni9TlFjYqs+eBfkroHWkXq2Tm//ZsS9uVoW47pkylpWIZFIoN8dNsN/4QO9goxQcqoAE1G3x0mb6HbU/U/i0QJCVGlmby1uRLRiw5o83gLW6tSVkMfBERRuVoAGEFsJK2r
 2ZPJlI1L
 OysYq6Ksz8QoclFpgMtUEjbPVDfDuNLPCxqdQqZ9+iuHfpTv+51wanSP8yjejfEWQzIsm/Sqgkwv595oqCVGeqTmPqsa9BCfo2ps7gsHOV2aGhxUzZL0FCTwhwIUWNIljeXqLCrIWNTdk2wbGxe00OyPyoJYkA9EM7XIrwXk1khPA+OujTambt3Z4sPzXbnbB5W3xUKMJIxYACileMq2JOIMNTVVNIUktcRXjrYpj7IkGQYoZlEWpnKf2DFVGFxY9KeMGalZBpkyYDG3+zEsR2lWw69I3zipkSfLmbMuUi9gTGV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 10:05:48AM +0200, David Hildenbrand (Arm) wrote:
> On 7/2/26 01:59, Barry Song (Xiaomi) wrote:
> > There is a case where `folio_ref_count(folio) == 3` and
> > `!folio_test_swapcache(folio)`. In that case, both
> > `folio_ref_count(folio) > 3` and
> > `folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
> > false, causing an unnecessary local LRU drain.
> > 
> > During an Ubuntu boot, I observed over 5,000 redundant local LRU
> > drains. For a kernel build with a minimal configuration, I observed
> > more than 20,000 redundant drains.
> > 
> > Fix this by checking against: `1 + in_swapcache + in_lrucache`
> > instead of hardcoding `folio_ref_count(folio) > 3`.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> The other folks should probably re-review this patch that changed quite a bit :)
> 
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

The code looks much better and Barry can keep my tag.


