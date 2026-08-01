Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E19AC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 07:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6446B0088; Sat,  1 Aug 2026 03:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680546B008A; Sat,  1 Aug 2026 03:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FB26B0092; Sat,  1 Aug 2026 03:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD506B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:36:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B436DA0270
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:36:28 +0000 (UTC)
X-FDA: 85051892856.03.4B1EFD0
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id AF53E140008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:36:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Xp80S1R+;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785569787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJBAotesoPitI8Ljxfl5aXuisDO1RYNb9V1dDpCG1LY=;
	b=AFiK6z5ixm4nt7i6gqchLXSPNTsXT3BI/tHSoiiiWRUqMtYwJWO1yS5MUdx/LpDnqiYErN
	ebDglTN3vNBLOGQxULEoTiVTSUaPCg3I+VCYcQWCnaadPYRXY/xmoG56oP/GU/ekPElETv
	jYUSGN4tXouOjt9qlMH9lV6xwT54HYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785569787;
	b=GcbC5OcXO/aaETRSs5R3LOqkBMNWf5ZA/HSAfncN2SH2itmBsyYsy7av5eKG8FVOHF28uF
	Qppkce7ljMqE1iwLHalTJWqIqspObj9C0N94WABYK4SvSjZvuSHz/h30JYQmtN6K0aPkQA
	ASKMJSs3/VESpfW0Wyn178IksYlFr/0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Xp80S1R+;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c5382806fso17263581cf.2
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 00:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785569786; x=1786174586; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kJBAotesoPitI8Ljxfl5aXuisDO1RYNb9V1dDpCG1LY=;
        b=Xp80S1R+fX4v1PnAvSzIRb70yUY0RdKn3v63hqdYnXRXjlWdI6ENgUX7TQo3I8rtXU
         cxf1C9bedwNlGT6CzwvM+MWuIsKIjIq/j3bFHZeMy/1unNtbykKIu7PkymP1lhryBEtt
         ljqyrxkdrny3Rd+yZwNXoAyEAvl35sbbstHQRLj46aqrtMZYSmYHEQ+/PoBJM+AFMSa1
         Ga1Vtv/tmx/SmzTzgUrZzet6jNT1cR+PQswxsTPXdXOmhqmbe6gO3AH2sHrqa+gw/Ph4
         /QJt8P9eMyIk2yagkgsOC9iY4XJHTk9rp6uJBO4LfSUilMWzSxd8J+2oaAz0jI4JdSIa
         mc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785569786; x=1786174586;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJBAotesoPitI8Ljxfl5aXuisDO1RYNb9V1dDpCG1LY=;
        b=tCKfIudiAQTBTbUmYQFOsNXQBYe5IMgLmeYaRVcfCnFbn5IUZAyDfOc1pSXeZ0U5lo
         7M3945rtoQ2Y2WAyIxAX+eN7t5Jw8qc29RIFzOQfq9SxpaOq3ghQOz0IuA/grCdMHfSb
         R5QfTBw039vc1h695G2r38QhCJSXm20u2ylQLPp5STDCKkr3bi+Prkz1eEMcYJLHsxKF
         9X0QU+7UAcvsFtBwQoLsFUY9ZGfWuCXED5IzzEd86MNWW1G/0C/E6fGFBYuFCusQYsAV
         KSxk6QYC8S44CVynUWcaGE2K5QegwWzW8/FeRbtg73sztuHMYvI1X7MJ0x05ixg/VjkV
         xxTg==
X-Gm-Message-State: AOJu0YxxvMCWCnKDfDrKTMpi3rh8+0Xwx1kXVigrvfEa/74GPJTj7c59
	Dx6e4voVlKDMzFXGzj4m4ChPi58oJaF0u/6ekn/capYYN498x7uSiWiiiFtcpOfr0XA+7P8Zae/
	xcgnv
X-Gm-Gg: AR+sD13URILY3aVJ1PrfJp8Fd/fkotParpRE5cwhNcylpN33KkaA2Z1gAAm6eRaQPnX
	veVg1hidTGuPL2jMF/N1KplNEnnCLfSX6XGj6TOxYSV3IxucFGKvGbu+otlgD91+DnlKQ65hR+e
	ccO8I6yXtuIIxCqAWTPGbRYxnLj6+d2X7ZTAIMnd7nIywboKawMN75fP6aXi0obTAOaPpduoWDJ
	AfA/eC32wKWSx8O3LbWoLWn7wVQNxmGezrbLERNEJgUCGHo3ga3vrsvWNCo4ncu5xKn9QnTwsfG
	OaUTRFPTCw9h1aDql/jwBTJB2nz9NRka98KowOqYlOQbF5LApikr6EKQhqe/E9HIwRmo+HVSvU4
	mhRXKTIzC4Z6hEoaOvKjmVa3egNTv964vjnsVTYmeS8epnCSz6YHi/w6W9/Ym57+o6iqX3wNLtR
	K1zN3cGiejW6lhj9bmQwDAm9tWgOq/OaW3SPn7pjZ9FuyAWYtKZozEiYC2urEWqd3QlIx5XPs=
X-Received: by 2002:a05:622a:5906:b0:51a:896c:9aae with SMTP id d75a77b69052e-52b566ae2a4mr62282481cf.13.1785569785716;
        Sat, 01 Aug 2026 00:36:25 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4e7ee1c2sm23439281cf.1.2026.08.01.00.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 00:36:24 -0700 (PDT)
Date: Sat, 1 Aug 2026 03:36:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianlin Shi <shijianlin11@foxmail.com>
Cc: linux-mm@kvack.org, vbabka@kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-ID: <am2h82KoY9uT01oz@cmpxchg.org>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_DB426A4AAD75DA751446F443770939B43205@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_DB426A4AAD75DA751446F443770939B43205@qq.com>
X-Rspamd-Queue-Id: AF53E140008
X-Stat-Signature: c79j5uo5h99eusm95uyjtqyqmanxo43g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785569786-198850
X-HE-Meta: U2FsdGVkX1/6Iv8WbgNofgxcrvzpRyXnw5XMEEf5g8/Dy6l0XNFgORZh0Bwr93Cy2vAzcsTL0+wopuG0XbZWm1MVilWtoXPvbWHS96feahQxyaOTUm+SP7kRVrO8Kq0ioSszxo8bWLaWb2qJZSPCv8hvCOpQJbGN48dVSanuhJQIciB65vkyJXk+0lMiDGFkS2DuRT86WeO+Lz36zL+ZPlGUd2hdvhJYwfsYNh9+FekT5ewS2R/XpNUO2DwLlAysIKBnNQAd+mwqW9zTT9VFCy/4qgy1SKzoTq47VUC+gdpe4RZy4d3fh/trj9C/I3/n5cUs8QWnDy+zyGekyuezxO3mV1PVM0uyqh3NjjAOzwo8qLhSDHI9rmzqwermL60UumUs9PpyjlkmYUByNf5OY9/JOSqjIUm0YCBNsqWsrcb9Ff0xXHznYw1eV0DGmkXvniAHBMsYqauBHncqSXt+wbPZ6XL5aUmc5LGx/DFrIezRxMOn2Fad6CsOAfC82Pa5QYZ/LHiyQEMCUUFlJYVoQ7378dlrxS4p2d+C4vCA0XAsjyifh7mOCb24V4BZU6a8IcORCdPYhQjpne3gznPilJk5pLiApcmrJt5wF88m9ZvJDktBL2d1PRGeKIk2T9JirpVzgh7/ALvojf0tq1iTeE7veMgthMdTDNqVM3zUI4713wFt891xtxBAPz2syXipDTb4h5O7TT265HJ7ZKjLZ4JNUSH/9zl07aAJkWKGADnnC2eIo6GvANDHAhPdEEovw6GtSM5KZeRH9F5BrnogMnl1PNH29bLqhAgzjE8/T2H6akYvIYoKacZ+2bCT/H/FRnY9eNKgnxRimsLdQpksMrUEsJ98KfEUxG9et7H7FSIm12ikvG8QufhWM8ugj6R7GqTiL+Rgq+KYt8lDrSh3L7vKYzRLuH6bWg34a0RGKly+EG2YVE1ZoJFVwjlSCLLBEnWyAXPz4E05h1+VWyX
 TJcSWoxE
 bTbH6NN3y48r+JNHgLXYVR2szFUT3tfhVQ57MDJsM7sbvDo7s4htW3m1ddh2E0XFMB6716w0lejZ9HCLo9CI5JgbvjBIXkQizPGp+OapM15A6fdd+fMKqhuLrLx3cWeSnPuC3yIlmoINv6tnljbNoO/xRWxssOj/GWFBW8d3fH6OUSw2Ih1aNZfJnU38ZuSnHNWUAa5QNo1XnYIfYM8LsiFfpJBZMHbqg5pPw2wouafaSOnRvlLPmq9/qQleja+veqMxsRKsNh1GyJy4UpVqLnHWjnM9q+g/IkEoAbx5qNjjlnOwvpITJDgz8TK6SFOOSBreaGtIGd1fh5R8LceWMy0cMyjJYRvH9bpzCBIM2pfiAIGjI8gOwh7WZGRpP7cPOyBZ8cF2fsETpq8XuX48Pyk9wmlCEHLVZdHdov9q2H7yCyqWVF6lVryPT4OV9iCIDFa2l8YJPOJQY8c3ff4HsmDHklbKUyCHbTXx+SSoElskritPW4gBpjiLD3XFjUi/lb8GwoO/eLFhK+MZcbF1PiV9qFikCZndku8oQTgPeaXYRFNclJVN5bMJETBe6RrLKRy90xvb9WCeUNdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 11:42:26AM +0800, Jianlin Shi wrote:
> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
> even for read operations.
>
> Reading /proc/sys/vm/lowmem_reserve_ratio should not recompute per-zone
> lowmem_reserve[] and totalreserve_pages.  Only do so when the sysctl is
> written, matching min_free_kbytes and watermark_scale_factor handlers.
> 
> Also propagate errors from proc_dointvec_minmax() instead of ignoring
> them.

This appears to be the primary user-visible effect. You send in "birds
are real", function returns success, values are unchanged. After this
patch you get a proper error code on this lie.

> Drop the manual "< 1 -> 0" sanitization loop in the handler and set
> .extra1 = SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax()
> enforces the minimum on write (suggested by Vlastimil Babka).

That's a nice cleanup.

> Compatibility note:
> Previously a read also sanitized sysctl_lowmem_reserve_ratio[] and
> called setup_per_zone_lowmem_reserve(), which rewrites each zone's
> lowmem_reserve[] and recalculates pgdat->totalreserve_pages /
> totalreserve_pages (visible via /proc/zoneinfo "protection" and used
> by page allocation fallback and dirty-limit accounting).  After this
> change only a write does that.  Documentation describes the meaning of
> the ratio and the derived protection pages, but does not document any
> read side-effect.
> 
> Worst case for odd userspace that treated a read as a refresh of those
> derived values: lowmem_reserve[] and totalreserve_pages remain at their
> last written/setup values until the next write of this sysctl, or until
> another existing updater runs (e.g. adjust_managed_page_count() on
> managed-page changes, or init/watermark setup paths).  Until then,
> allocation fallback into lower zones and per-node dirtyable memory
> (node_dirtyable_memory() subtracts pgdat->totalreserve_pages) may not
> reflect a refresh that such userspace expected from the read alone.
> Normal readers that only consume the ratio array are unaffected.

I don't understand this. Nothing actually changes? It just runs
through the calculations pointlessly, but using the same fixed
parameters (zone_managed_pages(), lowmem_reserve[], watermarks*).

* modulo the boost effect Vlastimil points out aside. Which seems
  worth fixing but it's a separate patch

So IMO the changelog should be:

1. Actually return error on bogus values - i.e. check if integers
   were parsed and bound to positive range instead of silent rounding
2. Don't pointlessly recalculate on read when inputs didn't change

> Changes in v2:
> - Add .extra1 = SYSCTL_ZERO to the ctl_table entry
> - Remove the manual sanitization loop (negative writes now return
>   -EINVAL instead of being silently coerced to 0)
> 
> Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
> 
> Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>

Code looks good to me. With the changelog fixed,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

