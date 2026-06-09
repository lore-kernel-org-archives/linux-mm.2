Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50E3CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47DE36B0005; Tue,  9 Jun 2026 08:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455E06B0092; Tue,  9 Jun 2026 08:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392166B0099; Tue,  9 Jun 2026 08:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4116B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:02:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F26781C01E4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:02:03 +0000 (UTC)
X-FDA: 84860235726.27.35A0D0E
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C2101C000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:02:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Gt3J+Ts+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781006522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtIvpKTvFtvgcG9xuXHskUbv+ygenMEnXGmAq+TVMPs=;
	b=3sInxdNyLuWuRHKAvhyUZd5ya1e991SG801o7y5ufGTJyFDHCvILZvQ/AyjBo1IipmoJM+
	GQLNYJGM8mH/LnuCQGR/vwQtTHZ4vo3TaBw683x4Ip8KGCE6j10B7Gmeqv3JH19d3L0yUq
	/L3+gk69yOvNq005QjG8H+VGAoUQOws=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Gt3J+Ts+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781006522;
	b=r93rqrdveRI/RrIKDkSCNCBgT6H56frTREmBTIkTF1+TX5CjeXnlXyl4eaOeseAI6gz0Y2
	q7niD9SsElJKbxfzXtvAhMOHymmR/3cxFwLGKXfqkpCsCnGqsVYfzYf2scFk6W/qF/h9rG
	ep5Sn0j1vAbe5v74kn9KsUJyTHbCPEM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1781006516; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=VtIvpKTvFtvgcG9xuXHskUbv+ygenMEnXGmAq+TVMPs=;
 b=Gt3J+Ts+V6FIDn3wjdp0RMkSYeGrbVVwdytN1sfQ7Vd2PKmwiQ9NEmX3X0rsUOCNkQCR6u
 Z0VwmiLnLLphpkdEfLGHAkiBhXeEJmSy6Nm64tE5sG9LB/W7oHHaHdPvcOr4SLYHBgBSLV
 lEg3k5NTBNW0YAUcCTGUAoWZW3nAiRrZ9GtbKfpy8Dc4bunHiezQ++sVy9J+XyMU/iyPhM
 4wWSbyLrXLlT8oi1HcheIAYUHobBsnXb4ZtKzQvZXrslAHLmhfGlR2iiPe6JFhFkyAnAA4
 VMh5xWSqKpnqe4TYXtefZ3p1ZgMje8QHWLmvTR+mzXtq/lb3OIXPviNS9BRMsQ==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260607190804.GAaiXBlGO2eRcfs1oB@fat_crate.local>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260609120132.84323-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
Subject: Re: [PATCH v4 6/8] string: introduce memcpy_streaming() helpers
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Date: Tue,  9 Jun 2026 20:01:32 +0800
X-Lms-Return-Path: <lba+26a2800b2+78d5f2+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20260607190804.GAaiXBlGO2eRcfs1oB@fat_crate.local>
To: <bp@alien8.de>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
X-Rspamd-Queue-Id: 7C2101C000E
X-Rspam-User: 
X-Stat-Signature: 84isfyxofqm7p9k9wx89tuodt93hufup
X-Rspamd-Server: rspam09
X-HE-Tag: 1781006521-279763
X-HE-Meta: U2FsdGVkX1+Cx+nwEdCb+lxfDyb+XzBfGlHYWXTq9RZ3JIioq7rOM2nWr/eZf2XTiN8aLo300jKvKb0/rFepr8wzUnQm8M8xHqLsawKB920hW6OpSvnDt6ddl+n+s++kEXQObTEc4H/UEVBWM4csZqEL8SCBP6etqsuko2cGJ8OzLZYHloxVdGFL+q82FyR2mMX7I/S1y1lIToEAsQBvkm8IVeErTIOKEIDT64aI63f86b49kSY6LFdTVMlAAVQ8OoayRRE8sQJQsKNKXPxS0eT0T3DGk4R0q556KMYV7ZOhlfsUsT/phSC49dtZpLHGHT6ujPYK1sisWsuvqkDENGYPj0lbOO4AigThZCjs6k+ktkF55jWv/lrHRwP6Gah/fhLOZmxA0IR3l7INxK1dbX8BCGnqzCO2Uc07SRzR3KRGBxHcGz0CBUKoJ1LdnquSedrlwllDpGYfHcgmJaR/O3QGPZLxUim27gXDvhsHg8vI/EHVbsRbZp1CSytV6ui2gY1K8QWQcw1bryBzad7sye+fS4ukjCIW+dlbbgIx3C6L+TUwm+Lo4/VLCSjGviCDX87+8NUWE3LauFP5D707LCf/oam3FHTUbxeejOzZOkLeErciTpwBHbEzylNEcDLRTGgZ1ZmKSwuubG7XG6YkzTOU1eTyNtFfltc9vNH2WkxfnnxSp2KSPptcfk+ZddiozL9R/8RGX1FsZjhjgmbP7I39+kSXbY/ENp2LR8q9xb1h12ue++/Lg6IG3LNjfGVharKYmAKdqHHtT9/oYPIiViS5tKIJnByNRIN0J97hF+TdxzqDJpojWo8X/Q/6SdC2GL8pWT4rGp8BtQXJ9Dp2aaZDDA//LBpQgTXHVRaOXmBqpy+Q+xpho+s/tlgX1NsoHpPbGgrMT2zmmvsBI9D2gkiYIvsfDQFUIGI7tcNypG//90HMeeW0401+6kcbypkmshJA3thHEX5q4XcWZd1
 8w2TSK61
 N5Ym03kXgnkyaMrjL7JeX24YyNQUvrVtAaPKA1cncv/AE3RJ9CERmqzaewvK/h+DhAZTi5JgIaq63vqpVZ9EHmUwA/RdggiISRTd9YYyjjEcZe/93PFpZpfV7njBlrstyK+BjxMdzZkrqznVTcgkhUhumZ5h+k8ZldT6+1zzmkcI1tHUZnOVRi9IY9BwKUrLcOGvwqjmNLjWUVG6f8qGaO3xxp9lB/nSFTqiTSWwd59db8AsaN+EADRpra9FiVAsXlsQ9jCfVeHRlAG+lPpc4Vl126ACAy6FHwm1f7LJRxHHit4VcyyPflz7Bew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 7 Jun 2026 12:08:04 -0700, bp@alien8.de wrote:

> On Wed, Jun 03, 2026 at 04:01:50PM +0800, Li Zhe wrote:
> > Introduce a generic memcpy_streaming() interface for write-once copy
> > sites that can fall back to memcpy() when no architecture-specific
> > optimization is available, or when an architecture-specific backend
> > cannot safely handle a given transfer.
> >
> > Add memcpy_streaming_drain() alongside it so callers can separate the
> > copy primitive from any required ordering point. On x86, use
> > memcpy_flushcache() and sfence only for aligned transfers that can stay
> > entirely on the non-temporal store path; otherwise fall back to memcpy()
> 
> So you throwing "streaming", "non-temporal" and "flush-cache" wildly around
> here and this is adding unnecessary confusion where it shouldn't. I'd suggest
> you stick to "non-temporal" which you can abbreviate short'n'sweet to "nt" and
> that's it. Keep it simple.

Thanks for the review. Will switch to nt-based naming in next revision.

> > so the generic API does not expose flushcache semantics on cached
> > head/tail fragments.
> >
> > Callers are responsible for invoking memcpy_streaming_drain() before
> > later normal stores that must be ordered after the streaming copy.
> >
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  arch/x86/include/asm/string_64.h | 32 ++++++++++++++++++++++++++++++++
> >  include/linux/string.h           | 20 ++++++++++++++++++++
> >  2 files changed, 52 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
> > index 4635616863f5..aee63108577f 100644
> > --- a/arch/x86/include/asm/string_64.h
> > +++ b/arch/x86/include/asm/string_64.h
> 
> There's arch/x86/include/asm/string.h. Why are those here, in the _64 variant?

The current placement was meant to reflect that the x86 implementation
here is really just a thin wrapper around the existing
memcpy_flushcache() backend, and that backend is x86_64-only today.

On x86, CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE is selected only for X86_64,
so a 32-bit build would still need to fall back to the generic
memcpy()-based implementation anyway. Keeping it in string_64.h made
that backend dependency explicit.

That said, I see your layering point. If arch/x86/include/asm/string.h
is the preferred place for the arch-visible wrapper, I can move the
wrapper there in the next revision while keeping the x86_64-specific
implementation details in string_64.h.

> > @@ -4,6 +4,7 @@
> >
> >  #ifdef __KERNEL__
> >  #include <linux/jump_label.h>
> > +#include <linux/align.h>
> >
> >  /* Written 2002 by Andi Kleen */
> >
> > @@ -100,6 +101,37 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
> >  	}
> >  	__memcpy_flushcache(dst, src, cnt);
> >  }
> > +
> > +/*
> > + * Only map memcpy_streaming() to memcpy_flushcache() when the destination
> > + * is already 8-byte aligned and the size can be handled without cached
> > + * head/tail fragments in __memcpy_flushcache().
> > + */
> > +static __always_inline bool memcpy_flushcache_nt_safe(const void *dst,
> > +						      size_t cnt)
> 
> This is checking alignment. Then call it that.
> 
> > +{
> > +	unsigned long d = (unsigned long)dst;
> 
> Useless.
> 
> > +
> > +	return cnt && IS_ALIGNED(d, 8) && IS_ALIGNED(cnt, 4);
> > +}
> 
> AFAICT, this helper is used only once. Zap it completely.

Agreed. That helper is over-factored in its current form.

I'll fold the alignment test into the callsite and drop the temporary
variable in the next revision.

> > +
> > +#define __HAVE_ARCH_MEMCPY_STREAMING 1
> > +static __always_inline void memcpy_streaming(void *dst, const void *src,
> 
> memcpy_nt()
> 
> > +					     size_t cnt)
> > +{
> > +	if (!cnt)
> > +		return;
> > +
> > +	if (memcpy_flushcache_nt_safe(dst, cnt))
> 
> That branch can cost. Why is that alignment checking so necessary? Why can't
> you simply DTRT by handling the misaligned parts like __memcpy_flushcache().
> 
> What does this bring you? None of that is explained in the commit message so
> why do I want this patch at all?
> 
> The commit message is basically telling me what the patch does but I can kinda
> read that from the diff itself. What it is not telling me is *why* it exists.

The extra alignment gating was meant to keep this helper narrower than
__memcpy_flushcache(), so patch 8 would not inherit the mixed cached
head/tail handling from that implementation.

Thinking about it more, I agree that this is hard to justify for a
generic helper. For this series, what really matters is that the
struct page copies in patch 8 can use the existing x86
memcpy_flushcache() fastpaths where that is beneficial; I do not need
patch 6 to impose extra selection policy on unrelated callers.

I'll simplify and rework this part in the next revision, rewrite the
changelog to explain the actual motivation more clearly, and respin
patches 6-8 accordingly.

Thanks,
Zhe

