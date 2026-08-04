Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 168F9C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C806B00E5; Tue,  4 Aug 2026 14:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DB16B00E6; Tue,  4 Aug 2026 14:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C2F6B00E7; Tue,  4 Aug 2026 14:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E42B6B00E5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:03:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 231F5802A7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:03:29 +0000 (UTC)
X-FDA: 85064359338.28.BBE51AF
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 563AA80012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:03:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QmjhkC9Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785866607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6Br5ulzAgFEdHoFBcM0EnFFM+QKsDegbfeoyZAEsEU=;
	b=mfayan8dU6a4qXqFtfbDOq/d1WzX4RWCpx1knSGhHUmwembbIeDAQyIrCXXcVU5608DuwV
	JlAeFOZNUZ1Mvr7PrXORPvLGvcybwTbUebXSPm5g5ydbvNrtLE98eTRv8XdF/4FfOePFm7
	xDOq+59I0TCTPIPQ6QUu9bFEfpZv9LQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QmjhkC9Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785866607;
	b=GSx6PZr1PpSNIRRZ9PG+u1d86smW/UQB6jRCDBj25j0fuMeS7eokbhM72Y310FxNUTAA0p
	BRp6sPZ2kcVzRpxBr0kxlZIuGN1f6yU9GSE1uou+gSFTGYLYI9a4q/wDn65HM0+6W12rLE
	8KEyBwglu7/M4vXR2OEF7SzmoIVwza8=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47fe377a217so56531f8f.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785866606; x=1786471406; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m6Br5ulzAgFEdHoFBcM0EnFFM+QKsDegbfeoyZAEsEU=;
        b=QmjhkC9YL6eM8fPK3ocdt5aUt+17BHldZ4RHcThHDvGJR7kShuWYR3aYmkQn6bncpq
         Z/9qhltqMOuE9RE+x8lydAgl6So4nc4pu/H0uKaIUbw7QypvlFGiISuR9Q8LytI83N9E
         63Hlwcl6nqmBzwTtsK3JWwubl8MZTbnQ3BTIe5/12AIZ3IcEomfBxZOFX+l4xUk4G4U/
         Xs6M01a8f+Pn+IcRi0dtUqaSTaQYGjb/FrxUccXY3FYnflK0ImVqQ8IxdKvFv7FP4shs
         fBz3TAvwoWH7nA+L8qudKXcKRpVN9GabG+Q5zXVdh2qTZDESa0LhoVzitFIBPaRDtI/l
         bm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785866606; x=1786471406;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m6Br5ulzAgFEdHoFBcM0EnFFM+QKsDegbfeoyZAEsEU=;
        b=YlHcgKj9PGrwPQ8q/NRq/wiZ2MCP6W8nBMewCyN/9o4nlTkqRO/sYDQf8ZnpHHJ1+6
         GU+qRopL77ITvxoCF58MEB00x6opVargtGcSN4UnqmG6OH4h8dogNi7IDiDU70ief3c3
         DgpmsrkdSa2lk5KSNdO2OLWU2RTyoJ4Y41dUVXRePHllX/6gCUqkG1hiACLflmdPnSky
         5/kfKiMUIaavsLSTEHBqDZ/JQ6NWzA6mGyNvWSb+O8YpAoU6/btgOvySLRWgXuef9ewL
         GsthNFI4gBAdE+6jgEPlBK5ne2qo59vCWmcxn/KscnrZ+zbwwhDjtSJT2gX2+xqh/NUi
         DE4g==
X-Forwarded-Encrypted: i=1; AHgh+Ron5Id00KJmkfOJiJK4xzRqpVlTnhaXBtsgkeO9nECTXqjX+p9hoQ6NVWnXzebok4e/n/mCztXmiA==@kvack.org
X-Gm-Message-State: AOJu0YzcGLlJZpG451wr0emCdERZfwkr9fVgKcaCOVnkkYmKSI1UZ7z4
	XDnV3QferZK2Vbuw2KXEL6aK/4imFD2WZApnbQZBpIJEgaYOhHNBcGor
X-Gm-Gg: AR+sD102/wvplbtvD6bd/zEMjTScBtan70WuTxqfrAO7/ik7JrAZeqEkot6NvJi9GbX
	TmxCK3QGTcHM+nJPTUlPGV8daHzXSRO6cheoHhKn8UzSc1PBXK5/mrAJzsDq6J6RqT/8eOUQX49
	mPSCHLiohlQLR9oaGB9SWAbJFlU1aWjYVjxgdjhqC4M8p9+oQxAcWN/G8A5VE6ZI3w2j7NEi+Qe
	4cG3vxwiNz1k8MrB60POe7kxcfhpTlfa7W49M5+IMKXslltTmdihj72Gg6h9Yd4MezqL3qSNdc9
	FUqKbbcEo0IIQaaP9S0J1aX/SUpbL6lxle6lvWCMbyuQut8q0k67o2EfuHGcGEAn1k9MbmKyTdD
	pBe8sbHIXVGw4bdxuyWKzENfCzeLEGMxmppcHsRnukYTkfsIgChFgKUKAfzVnUnYC8vpfLpO0Pe
	3lPeIi2hD/a5A8f8UlRwSjqgNqAzUD9pz0EwKzJ+ZdBPxKOXwGxthC/RsjKhbOpj4kQ8Jhb0Fw3
	eCmwqRlPVO3w2JTYap4RaCtN08iym3zKJOpYLcy2DKIYc+oJR89rrHAkWP+EsbythEkOeWNDHJs
	UFkkrE6BZg0WvOrk++lUu5uLkRSADTRkPigCm/S6oNVrOn/Yn38/HteDxoE8UPgUpeeST9Oc
X-Received: by 2002:a05:6000:299b:10b0:47f:e760:e5b9 with SMTP id ffacd0b85a97d-47fec532385mr1689672f8f.18.1785866605632;
        Tue, 04 Aug 2026 11:03:25 -0700 (PDT)
Received: from MacBook-Pro-von-Karl (dynamic-2a02-3100-a48b-1c01-1c76-d8bb-0f26-1c8f.310.pool.telefonica.de. [2a02:3100:a48b:1c01:1c76:d8bb:f26:1c8f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec24a24fsm1766803f8f.36.2026.08.04.11.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:03:25 -0700 (PDT)
Date: Tue, 4 Aug 2026 20:03:22 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, Bradley Morgan <include@grrlz.net>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fork: Honor task_struct's declared alignment
Message-ID: <anIo9OWW98uSJh41@gmail.com>
References: <20260804064006.93930-1-kmehltretter@gmail.com>
 <3a8cc92d-3e4c-4976-8b01-b303cab3061b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a8cc92d-3e4c-4976-8b01-b303cab3061b@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 563AA80012
X-Stat-Signature: acdddu6yph7egd97hr1eg8ijfx1o15oe
X-Rspam-User: 
X-HE-Tag: 1785866607-658467
X-HE-Meta: U2FsdGVkX194geoEhYyjwZhSbBIoBbmHEvRvpTItvrIR4DBgj5P6sstRkNJ+aahldb1fMRIVWpyBDmZmRiIPGmjxVP6Bfs5TfANy56fT2+/8Rq2o6uaYRH8TB+fRqAGL+XMmN0of1mcLgaPsKPQVd/osaJwI8NqYktFui63rekw9xuyLd3H49Wb8bt2Zekqmlq+9gKWl5oC2mSyBZgICIdvbNCjHE406JZcMKgAHmC47/zZtjfq+FiTSz9ab7h8T6l7Nca7ZL6as7EZz6YbPaDPpW+sxyykXXz2fCDy5Py1Ig8hr6Z3uDpV3LWa6i31U/Q0Vw4b0IvfflfcGoRnl3OpFjUFffXpZgXBA1d0QgIx51QZuddx7kL4c6aILzHWZTa5d4lB/6VDX2IPgpmYjgN2pnVMcEZIbZE9j/XDHAUKkhCo/sZGYRHtrpj/kZ5+8mwbh7nPae9KAkMRBKPrmAw7Vb/5MaCGGovPKfN0i+ruQLeVqHfwxsa4sSOpr0Ep4Xd4NnFN7fefCidl5OEK01qrt1SOHaOgtpzD58pvlGN/ZoRo8ugm0kNB5etFHh60kfV2sLNFmO/NnjQ+fn7SHhywApj7j6R1+WFq1+dyXnCIGi8R5RVCzmjROSMCDeavTU/kcrs9ZOpyNsJCbGII2Zdc9woIWYP9pMYtL4LBQ0h5puEORF0hPhpD4jGkYflE+eWvI0bAwoN3g8CRhwpcDe95lGewfXFQk7KRFkppoTDfTc8OQrLGTdTYIegSe9uf+ymmm288C20G8WuTQqgRFT3lHl8IVHsXrnWh+H6KnXkQ/AFKH+g4QzGD69tSAE4QGFBvvQ3reTCumYEd3sRS2Dztian5cY+jx4aKFux/Yhic/vwHvr+3uj8PQaIuJN7O+TGSyR1vFl1NkUsQP5zGSk31Bw0hEvZtq4+V44VgxUZZmgngh0aXIqrHmqnBtdBzHXa8jG5MxAgkC/dOdEZU
 yJUng+Va
 ipJewvrRtyj5C45IBgQ2HQ86qCY/p5kS0N/X4rdrKdZO1CtHxOJfcC1qAH0oAKLi8J6568TEr9XWEwoTmgY+wnA5GHU8RVViAructtKPUxXlK2f/6GtTypgpcD3P00fBzxlyPNL3MA8h5ZoRUfLRqRbYJFW6OQ0/VWw8Qx2ikNvPIEZ5P+xjP6YLkPPFKCpe5VxL/CD68Cl1fqznWztKQBrPRwBZsEPi8a9RdPmh2re1uNGgz+3UI+w4jcPJzxCIyjbs1X8xZNVZTMO3Sj/YgzU1rIn1kwPohk1xtgZg3CsEMI0g+HtUp+oZw7jC2RLJiJ2Z0YiE9//DTdamGHUPv9Jd2ILCfzG+8ajRPwGHMx5JntcLS7IyqR8x0fNOuzW18FoXw5DnL9VLS+th5guo8nkKB6giQ5cxeCqJQMPTbP/L3HgSQCXpMkX+VRv/aSx34SfXZEQb+hC+iZuMtsiSgVNtKGGxBxAx7GQ0RrOLROmlt4GNajISTWQolqy3MDd096yMYDe1xHbho4cqoB9O00ELvu/fWeT/6pm5DeBY8sxeZnLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 09:45:31AM +0100, Vlastimil Babka (SUSE) wrote:
> > Fixes: cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant size")
> > Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Thanks but I suggested only SLAB_HWCACHE_ALIGN, not the whole thing :) Can
> be removed when a maintainer applies this.
> 

Ok, I believe Suggested-by doesn't necessarily mean the whole thing, but I
agree, here it maybe was too much. Fine to drop it.

Thanks, 
Karl

