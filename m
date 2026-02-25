Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30FCFF357D9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CC06B0005; Wed, 25 Feb 2026 02:16:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4144F6B0088; Wed, 25 Feb 2026 02:16:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B116B008A; Wed, 25 Feb 2026 02:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 229356B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:16:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 231E758EEC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:16:00 +0000 (UTC)
X-FDA: 84482119680.25.BEC3035
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6975040004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:15:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPsNsUYr;
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772003758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWwc+3WhfGI/84k70ziS6yHLTtfdR1yXxWsitRXEIr0=;
	b=iR312ZLWCzcl8yEcU0ZnnbMr3UbdsWfT/lh0piGY63NCYcsFstOUtBGkW/wmGJT5foFGt3
	9Igg5smMDxYCp0D8a4qAs4cOZ0RN4CIZJvyf6FrhUUXID7WHjfpRfOLzlQJ8RbFyEaaXP7
	JJRmpnbgKufO4LvlJuGG3ByRC+j2ewM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPsNsUYr;
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772003758; a=rsa-sha256;
	cv=none;
	b=I1nVNmyK9bASwxlGgko7IggtN9CjSvCIYanv6paDUTqeQMN0s2HKpWxGIcimKcfPwEqKKF
	q6oUhOSjXPoA8ZKyj5pd+6Ypj47RbFg0UEBc9pxdb6YrpEAR+cwx2nstJRMK3koX50hWOg
	dH9YXd8kAxtI6Vtf7E+N42/LZcK1poA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3293D42E5A;
	Wed, 25 Feb 2026 07:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F77C116D0;
	Wed, 25 Feb 2026 07:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772003757;
	bh=4BdT8DUi7UC7RFjd1x4PTnvnw1YSgTjXNR2GltKSXTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPsNsUYrj+Fqdw9dRfQKzsT3tMy3u1TDm4AoZVBqag6LtBFdGVjQyJkZDYJvSIZv3
	 UjSI7y+1GvByJHwvgqLudsQOdYwaRmrynMtukU13oBcSaciaWPKin04/z2QqQtTdiA
	 6FDGYyxWb3782DVe463sw1ddADZdDarAmN8KVGLvBip6S33WPCtbuxqqDACYBKIJIs
	 3+mqFvc/t4xLOXV5LMmmafzBzxdSZVHm/4/GKJ6TDUaEyN77k+mNDhpG0JOv1oVmK3
	 F+3HyOYmbPQsqvDC//7ryRqieJd4h18nPei3J6gQJT3INmw77pNNy56DJ/z2R2PmPo
	 vwIJtt4WMK3Kw==
Date: Tue, 24 Feb 2026 23:15:56 -0800
From: Kees Cook <kees@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] slab: Saturate to SIZE_MAX for allocation size overflows
Message-ID: <202602242315.C9D5430C7@keescook>
References: <20260225013954.work.319-kees@kernel.org>
 <aZ5zjIpYZYoc-LSX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ5zjIpYZYoc-LSX@casper.infradead.org>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 6975040004
X-Stat-Signature: k5doxqzf4hzbaxsb7btknafdp3rsrnck
X-HE-Tag: 1772003758-616146
X-HE-Meta: U2FsdGVkX18u2lhSdxSVmh8gZbEpHBFAlxDP62v2snBrt6W7ii0okYStZzMTEjdVeoARM74LjzZS+RVkrO4bdQZzeNrYQ1lT8RWpKrNM2jl4fMGMcPxXqqoEpnwEZq7BXjMxOamYEds//Y9c6md88oxs0iDy2APDQG8MpHxJK9cNynTgwQc4k0Y19cNoQGPH4gBU3cS13dQ3dLZ3d+YKUslKiicqha09AtffFsre9I6cs01RiRGS0WzUfxVksfsLf4YNdo/ynal3c2lnyJfWpwaEyfLyS0jrr7+GcVPEDCvLxrzcpThwE4IzMsvAaAPL7cbipb+9NyO1geJ/PEffeC22YNDOqpSsTaNMyhFhgRGbVN0ZknDmkDYdS3qb2B365rglkss8brHM/O4nx4lD77/atgKH8JfAoSnaD/MzGp+91Ut2NGRvwShOcTX1qBUx7VsoQiSilCXw2wtIxpJCf4LNALDcu7KpHYNjYVwlIK1UX6su1HHTEwq6IOPPE54z+/LPRbkT9EZXp1jZX4ivtv3InrKLoaAyKg0az7PUNfqHsGuHjGQZdsDo7HUews13nfVmI3HaV6FEhAEZHzUhYihsS98nTLJ61b/7NXjOb5rUfSvo+mYV9kvICJAmAXHuHtixpHs+uShfuljm54UKKFKcStc0yHPB7x48Fr1k9SUHarmzKH4t71XzcXXdPUXlo7G0D2trkn4dPyIyF10WAV0h69DgTgqtLgI9cr61inFSw9OPcIvEjLQX342+6UI6dbp6ivgZEA56wcLNfgkRzXGX2efkUpHDyZ6hdG1xw1/gggZ2zMe3rKbtEq3zjvzY9ehzz3uvyadLD9rFN6/gNmI0Ri6IRoJhmi+O3ldCt6mbGbptYsnqU/4pcirYEILCOZFd6Str/AnYHc/QJ/40cv2x+R7leqzLAxPCqTcjwW4iYJKtXVaDjQFGoJ/VN4lCbqWer0qPPHftitqKHvk
 /PT0vqXB
 MpdVD1BEqKv9BG2VDEtmNewhj84ZforY4Xgw1qfk2aEjI65oy9rCjxkWVlu3KChqT+Incdj3F2oypNqUnBt/8nT1bbx4+UvFtnmc8P/7pkD/teJrSAa0byAT0LkS21XoJwJ1GswCOQm3tOUNycMUVjvPzD0w2abWniQWLbkO+/q2bbXlIGLQp2khG2S3TZjDdVTqO2vx9HMeAY1ypyQHmGFkVqckD9/i8wnjZuOHyrtGZtBA0l8CPSKRrNPiFn196jk2vT8S3TwUillp7HS9sFYLxDBvxXKEbDX0I0AihPGStAjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:59:08AM +0000, Matthew Wilcox wrote:
> On Tue, Feb 24, 2026 at 05:40:02PM -0800, Kees Cook wrote:
> > +++ b/include/linux/slab.h
> > @@ -1105,7 +1105,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t siz
> >  	size_t bytes;
> >  
> >  	if (unlikely(check_mul_overflow(n, size, &bytes)))
> > -		return NULL;
> > +		bytes = SIZE_MAX;
> >  	return kmalloc_noprof(bytes, flags);
> 
> Wouldn't this be better written as:
> 
> 	return kmalloc_noprof(size_mul(n, size), flags);
> 
> (etc)

Sure, I can convert them all that way if that's preferred?

-- 
Kees Cook

