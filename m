Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9764CCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B00C6B0410; Mon,  1 Jun 2026 11:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0396D6B0412; Mon,  1 Jun 2026 11:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43FD6B0413; Mon,  1 Jun 2026 11:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC4586B0410
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:11:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D5781C0C61
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:11:57 +0000 (UTC)
X-FDA: 84831683874.11.F74E6E7
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id A52DE40012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:11:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cp2+7nab;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzS+u3VEJaiahfu1nIf+q6huqq6AwnkcqZDyeqXemp8=;
	b=4HIc8JPISc9Ma1NPgqQG783q5vXg11oFecGKvaMUoXDjTM31yOyi5K+4wWhA4lrtOL3iI/
	0k2hrQYMx+UKzCUDXs4AMxcERqSrkUNuoW29QiH/A3xPB6xMIPWv9neSjnCFgU9V5KLehG
	vaC68b1KQ2b38OqSQcOWRitGkTx6Rh4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cp2+7nab;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326715;
	b=SGqll+g0GTIkYeKqHowsRgMtitOPfKasVS3Ujh3mMkKA1p8vesT4Ervl457JTJbq0GgZot
	oy2B4tY+mlWeLTgBdTc4HDTqo+jwZs6PuXfcgub+ltayejs69VCS8DdqqY107p5RfZ+P0T
	p4xkq+2UirDeDzUl3vk55/0sWAoqoBg=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4904c1ce4c1so114707185e9.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780326714; x=1780931514; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IzS+u3VEJaiahfu1nIf+q6huqq6AwnkcqZDyeqXemp8=;
        b=Cp2+7nabWWhGi8RgZNvHbGz88GEgi92LtIckh54H9+GNE4b+AOd7GMseIQ7aJb63uu
         ifDGV3Oie1JGKEaN0uKWY5K0dvX1jCjM05VfBXgdjHE0By34OEQDf7hrK/2ED6/LEys3
         CvVCtBhd3zh0XyMtZLDBhMGNXtCMepG4g87d1br/LyO2N++QfPH/ccKygd3NHCzBpenY
         B5aaRL0IMVOc1K5xgTad1jo3m8iMwERrXLBsG7RPLxlSblYbB3R/t7mY+VDmzBn2a3D6
         kSlyCtO6L9C5NROGaU6G5qkTGmoqY1I6DBKWsXFa7B0QDw7vqv62CUUYkqWRRXLE5PoD
         7tiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780326714; x=1780931514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IzS+u3VEJaiahfu1nIf+q6huqq6AwnkcqZDyeqXemp8=;
        b=km5AACZLORjnjJK9Wk8wn7YKfzT1eDZdYObeMoEimpjgxXnrQn4KcrfFgb8jNn6U1W
         CY6bUVSMxG4kg8JSl23ZKukNS3F2OaUoJ7dIdX9wAZzjxJIjdfza9oa37J8jtcpwB+Yz
         0eujjP0wlm6+94JvERbPdima+LrEZCFskKaH0Oo1rdfrQhh3J0aFwUw0LWrW7mh+p+8M
         si3Iy67ugEarCIb6WrKUANoXsUoeX/IGHZpg4jfvqioclKECg8mLBUoxyWzzr49VFq5c
         UhoeZLyPreDZvtyDypUHE30Px0GI3LuSdvspyTNb9ZbRtBB8hIBIcAp5gBJnIxac+u9v
         dWHg==
X-Forwarded-Encrypted: i=1; AFNElJ91F2Lx0NYTc0DXUeE5mAnRSOaMmsRvODUDVNOeI06vHf6cPEl/Zjberbr4g2SLe3utjEHopH63DQ==@kvack.org
X-Gm-Message-State: AOJu0YzJr9dTaEdFYEoYdAZ/JsjzbG/OGNx2t4keFPTKuh3BrAzRcOtf
	GihhkQIGrBbEEnlgC3cqhKyuRmTXLGtaYvugJUehE4cJnbnzz0v/PkWx
X-Gm-Gg: Acq92OGK1Wxa11+Lzze1nwldUlHPN51IXAngCMqULmDeONngdPiFG+wvincif5l936G
	FVwfIHK/XjPSKOtFGcyo+Ceb/4oqGNucDAL4/oycyfIMF5VAui5y5c/GxELAFgid8LtPzepOg13
	mZN8n7y2Ytk22WNIj+Rpwd7liUIDvirtQfBTWDoL0czKemC3+rhcDh/CUIt9YxCvxaV3HZsyDC5
	uo6Y6BNTEwopPkwoo6bm66xVCCJZ68v4Z9UgSA+/aRR16Tj3Wec4YvbpF0DV23TdI1Yhn6D627V
	lCASD28xEEb8lefjimH+5rNqmQcqRube5512ficMkRH4ZiSOmGaGcnnIAqB47k8qg7KBFoG0AMd
	FnQldbef1IugU4LqsMbTtqzbLB+Q7EJZ9q2dbQN1VZo/9lxjBjvVZ1sungE83JNcDVDkcz68fI+
	h49+5ACY1RMfhjtm9xVZRBoI89xzjJeC+AlB7XaAeayzxZ9XGa2+mKb/zgmHaDfMeBpsj7wWJXx
	dCHTirRQA==
X-Received: by 2002:a05:600c:c11c:b0:490:4663:691b with SMTP id 5b1f17b1804b1-490a2923a3bmr173930475e9.7.1780326714079;
        Mon, 01 Jun 2026 08:11:54 -0700 (PDT)
Received: from f (cst-prg-92-135.cust.vodafone.cz. [46.135.92.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6eb3adsm256613955e9.11.2026.06.01.08.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 08:11:53 -0700 (PDT)
Date: Mon, 1 Jun 2026 17:11:46 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for large
 zeroing
Message-ID: <dvvtrfpacxxuagpexdjni6gpuqbqu6xl2regliuz2zyv6koaok@d6wi2wk64cor>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-4-chizhiling@163.com>
 <ah2HfH3jJZDiNAQc@casper.infradead.org>
 <rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A52DE40012
X-Stat-Signature: di6xm9qc9qgzu795nt9f6pete6yiqqc4
X-Rspam-User: 
X-HE-Tag: 1780326715-50927
X-HE-Meta: U2FsdGVkX1+r9C0j14E5CUgyzkewmN8YaVQsj61qvdD8GpFp2+bhmWVaNdyvyQNlwTBFuWSVxoa7F4gS3VXQXYPpIV5R4qiYL4BdV3UMqPDYmaN/67x67MA9SD5R1L8i8WMnHID8ySMXuw/rjMzrUO8qiaZCflyscXhArtITBidEeW5iDGOiWZDgMg7BY3gyagEFATamTw561bTA+r38TSVgmBpb4GpQ7/rPjm/QpgWr+4uU+ea4CWOS2xG1xZcv5ccPGNrRDonNrRtYyDBFtm1HKcFc7PttzNAwTYQAjWcTqZgqWar1z6IDtGjhZnRliXIJzg96zeb30w2ZaJeKepRJMjesBDDHnovpYjEkplENxdG7mS0pkzUjHCQWkNm046oum6yYkRXVVSi5HSQ566BdANLqkhoGPnR32O0LRi4lvdsTnP9L4yFpNiwhAhzoKY48mU5nWpvUPWYqgI5txSOZApeF6y5gPICkuQBtP+MH0smphtzfB/Q2Jqz3ccLHxzur/LZQRKRgt9b2YAwXHHrVBwd3WuhCUYuLWNAOVxp2llDyDXb0XPEhtVETZTbVt5k9fBBO8ySP9cWhCp1pFArSrr8fFUfOlwAzsO3BEVTcaWUgjsBrZV2XCxPiPbT+wuBmE2aTgudqg+W6jxErMWRP0llLZsf54SUHsyR7zSVee5L4U58QASY/vb14ItBq6xr/yl/rKz0LWyij1RowaL8nSgZf7/+cmb7rc9V4Undf/B30bijDuAAh0swEnfggMmFAjquELlAr5ZJpW92paUS3MVrF8kgndOxNpYE+brMNlzzSqp+a+dYSSocRYnOw2xG5GKcGmF2SmcZIzU80o0LOggqaW73sDUBXsOv1EPcjZn1fGzJI1g7sq75YY3uWK1nwH6Yd4ze8juGagMbgulskC4rWFrzh7kwgXeJ2YBUNu5wCilGv4VhtYsPDiX++6JoeebxsGbqDcJainjT
 YBoJTJCT
 btSCfrY3au8Wy8l64i4atBnvpD+jIHx5qgbsoxVfju+0kTGJUQIP9cbsfiAehm/VrvqltVg2zgdogQNRxSf5GESXm2EM+HHwh2TyDH8MGWkt7a+34Ve54SVZ0gtLvPHIjOj6maqW0EHQQpeP4TVlDAEQybZxIMHdP4ONHzBF9mqjYujksRE/7emPnvvcJhEqXwNWJkGl+/lusjjfVqqh2TJBZFaiQU0QfSzlPkeL3MeH/JVqd43So4NEg0skQFnKkg5ba724huITYFVpMsiSih/AXRMaURSbvk+kGsnY7ShOFyZHsL0UFlYf6eEGOflngMHujz3dxpdk/rpPPIzGL2lE9SV7RHXHh2siMeExy22prKnnAZzMAFZhZV7cfj6NdL/yR4MswMk163m7THGF/eKSnYNO4h7OQEbvniMvzPOzfYzgl+rSh8fE9nCDA0feunCM8YioCHflbBmgmIPBlmR/ma9ieriBppB04
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:02:01PM +0200, Mateusz Guzik wrote:
> On Mon, Jun 01, 2026 at 02:22:04PM +0100, Matthew Wilcox wrote:
> > On Mon, Jun 01, 2026 at 01:57:02PM +0800, Chi Zhiling wrote:
> > > Currently, holes larger than PAGE_SIZE cannot be handled because
> > > ZERO_PAGE is limited to a single page. Add copy_zero_to_iter() as a
> > > wrapper to support copying larger zero ranges to the iterator.
> > 
> > I think Hugh put this optimisation in the wrong place, and you're
> > perpetuating that ;-)
> > 
> > So perhaps we can start by moving this optimisation to lib/iov_iter.c?
> > And then you can redo your optimisation on top of that.
> > 
> > diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> > index 243662af1af7..06c54d719fcd 100644
> > --- a/lib/iov_iter.c
> > +++ b/lib/iov_iter.c
> > @@ -451,7 +451,23 @@ static __always_inline
> >  size_t zero_to_user_iter(void __user *iter_to, size_t progress,
> >  			 size_t len, void *priv, void *priv2)
> >  {
> > -	return clear_user(iter_to, len);
> > +	/*
> > +	 * it is noticeably faster to copy the zero page instead of
> > +	 * calling clear_user().  Shame.
> > +	 */
> 
> 
> This is a rather suspicious claim. If clear_user is indeed so terrible
> that it is faster to copy, the routine needs to get unfucked instead of
> the problem being worked around.
> 
> I can't speak for arm64 or other non-amd64 archs, maybe these are
> horrendeously broken.
> 
> On amd64 some archeology shows the following:
> 1. 0db7058e8e23e6bb ("x86/clear_user: Make it faster")
> 
> 2022 vintage, replaces thoroughly terrible 8-byte per-iteration write
> with rep stos usage
> 
> 2. 8c9b6a88b7e2f33c ("x86: improve on the non-rep 'clear_user' function")
> 
> inlines rep stosb at the callsite if the CPU has FSRS, otherwise
> fallsback to a new routine which does 64-byte writes per loop iteration.
> 
> FSRS is reasonably popular by now and chances are decent the test jig
> used by Chi has it.
> 
> For a size like 4096 bytes, the 64-byte loop will be slower than rep
> movsb and even rep stosq. This needs to be patched and maybe I'll get
> around to doing the needful(tm) in few days (it's not hard to write, but
> some care with testing is needed).
> 
> I could not be bothered to check how the workaround showed up, but it
> definitely needs to be removed as opposed to being perpetuated.

Maybe I was not clear enough, so here it is stated differently:

The routine was incredibly bad on amd64 prior to 2022, I presume the
claim of bad performance predates the fixup. The current implementation
for FSRS_enabled CPUs is fine and I guarantee it wont be slower than
copying. For CPUs without FSRS the fallback is slower than it needs to
be for sizes like 4096 bytes, that I'm going to fix soon(tm).

No matter what, there is no justification for issuing a copy from zero
page just to avoid zeroing in place.

