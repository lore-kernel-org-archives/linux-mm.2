Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E6E2C61CE2
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE176B008C; Mon, 24 Aug 2026 07:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5F46B0096; Mon, 24 Aug 2026 07:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A52E6B0099; Mon, 24 Aug 2026 07:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3009A6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:09:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC030A373A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:09:38 +0000 (UTC)
X-FDA: 85135892436.30.3DB4723
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 004891C0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:09:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G8niwCql;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787569777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqwXbXyfUlH6nF/dcWjMtptrPqoYpuG4oKFrsn7psr0=;
	b=kFcIsm0It6aNPIQ91+4ysuryV9zYwpc4AUi1V6hUZMLFqel1aX02PoHoGZpgcBTDZK24DS
	/yDbizsuz5SeOtvIYTDlN/qwr+iETBTHEI/yDs6Sa5WybzAnWtwa3KAGfV+7EW39r1ngPw
	LvxoPeyXJEITTl9ojbpADAI7EAATKBM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G8niwCql;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787569777;
	b=Zr5mOvD3bb01etV3rhoJ79iLSpYAt9OgKlKlB6vCJiK2o/4qux5fmccYs+BJltMDoY5A0o
	AAcHxgQHLfE9nCmmYKq4JTXXJOi9jHWRyz7+3p1vUgUfsElvU41xn1jSUHkAfynKMhFm1l
	rtCKe6//6npxzn/VG9C6gxOXDHPlyuw=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso2856806b3a.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787569776; x=1788174576; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FqwXbXyfUlH6nF/dcWjMtptrPqoYpuG4oKFrsn7psr0=;
        b=G8niwCqlDr3OiJThO7eQrNiELCsS6BoDnNJo0twYYPresho+muAiXSrFVgSEuG6Icr
         V5CFb6lKVDRhwNDsNUVh8HE/wjY1e9Egl3YxEO6N3ywpUecW6tcssr+p02OXTX8xLUzL
         61s0l8QhEm4VWAZYUdUKgVndhzjocFEtH1apqpcDgXTcT8zmKq6n9qwK4f0ly4uHWv9A
         fEos/buN8lpCLofnTrLQqr5jTBza2IIkkcfyLAEIY7EQjz/aIM1dNg4wju4DdOj2n4MD
         uR5eSYPUiMnlP1a4vOLyLLkjXJgj1Ylx/f93hdFgR4SX2GjnM4RcOTlPWQE81wVRzIAh
         v8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787569776; x=1788174576;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FqwXbXyfUlH6nF/dcWjMtptrPqoYpuG4oKFrsn7psr0=;
        b=TDJ204o0AYvrHPeml91aagc529PPKF9/TgAhTlZ6q98n0DKAIw2jlUPqDFoQLlGwmK
         uMot8OAhfo5ljb/FdPxD/o7SdAMZ+G98dXnuHUkx7Mg/30ov+hpfOMzOKsj+UsWHOBjO
         QtnYi3URsy68nkxOUbazJ6ozqHoi+M0wxm0dn/vPlN2ELPOpV/4Ofrx3TDobqNqgsfPT
         ciMk/qt568bclaO3LPTuglbwZIRpRnSszhsLgyw7nrX34APnuZu//1QjRpZy4S2hZ6Sw
         jW8Zqurk00Q+0awIP/VQsUcbH7ZkfyTdM+liMzJLP55TDe8v4vy/LjyKqpD417uBZSWj
         Pa8g==
X-Forwarded-Encrypted: i=1; AHgh+RqB6Og37PtAU5oCvoS8rrxnfHT9LuxzVChO0vwewaiBL1mm63P7Cf9omB0BdlcdU1lgEejFGcHzWA==@kvack.org
X-Gm-Message-State: AFuF++kcTx9bg4Gyx4EWAn4flkZ75GlzmlTn9xBeF7FS77of8SRaJntv
	oqBJHWzZw4F6PGT7iJNJ+FuGHbiZwUy6U5cbCumi2LAlAF7Td/5a5A8h
X-Gm-Gg: AR+sD137fEQ1W7+5sEtvgKvpVBGzcp3A9vvtznhi3a91BMhYXYMDFpFvx4mx6Ta4KbG
	rVwpPARUjXnTtN5Qku3bJrWcHXP/+H7GEMmVwjMugiQTYjuWTdpMsbdf+AM0BelmWS9LTCAN7gE
	lAvL4Xm8XQDrmiZPbEzuucYE6m87itcQLd+DNDNe0JZqH0uTzXDDXTAN3G81EFRuILD1Ul9YnUk
	M/R1bhmwaZo+cg8nVwPho6tGhn5sRP21U2GRh8HSOQ4rHY9J1WM4Y1kvzOu8E8xCulM8CgdNHso
	fh7MtWH2mTlBd72oR0a03Pwt8cp0nZiaycuTknjhY789Q6ilP+Jx+o9jFcz3evNYa3Vw6feDy20
	/uy06sDDwN8DsVussC8CJDfYdUMFoljeHr4TL9Patv4dQcK7tATCInbxE3gEIu7HyjB3l2EOpFf
	GvRJ+E5ugOObo7WIyp+XmQB0P0XFason0EhWzqIiURlKYyWtA7YLLfEIb4TOu5DJikAmeRQNLih
	da6PrjF2EK3ghMFTttC4Evu
X-Received: by 2002:a05:6a00:2d04:b0:84b:9a69:156d with SMTP id d2e1a72fcca58-851f9a2c87amr22297176b3a.0.1787569775691;
        Mon, 24 Aug 2026 04:09:35 -0700 (PDT)
Received: from KASONG-MC4 ([114.246.239.71])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520ef26df4sm1790900b3a.21.2026.08.24.04.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 04:09:35 -0700 (PDT)
Date: Mon, 24 Aug 2026 19:09:24 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
Message-ID: <aowABnB6OPCb95eC@KASONG-MC4>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
 <a13c3895-cc53-4f91-aac8-2bfef765eca5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a13c3895-cc53-4f91-aac8-2bfef765eca5@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 004891C0008
X-Stat-Signature: cw6x455z3xymoqui637hafwdcadqgcaf
X-Rspam-User: 
X-HE-Tag: 1787569776-19394
X-HE-Meta: U2FsdGVkX19ZPGZaADVQl7psWVbwBoyEL+Pk28SG6u2H9yMYn6I5ixcLHfnb7rPAsUncCpCPz1MA3PrqRZRFRVJz8n8LaXe0hiTF17qt+btIvV+bbHIwiRkx7/ger+c5SG8lrzK4E9PK8htc//zIRc7j/jh3UB1Tict5trQSqQJ6dpORpM1Jo/md9iL310P9zMFf8GmmOGDYoAS9bSyzMCV2aCgOTNSh34QP1mBeufUIVoY2Whzxq0SPlgnx2fi6V6vn8tVv1GRm2Rdu6/rhTrpgsThTOW8uZC0gecyvxnBCmfDbVlT99H1O8yPcwxRsosAIPfLLOi3JBFdQjc8rVRonTqodNeN9fbykXWTl3to7CtasFuhKu9nWnKoCwfwJ3oPfQIrfpHABDYbFY+JNHItrxoMhklvEWQ21H9SG2a31A1tmaW63y+eF8SW59AkywQdeAoLqkzUxMvHsLRGASgaJPQr1UHQ+pZafmuu9Ke02Yd9il4H5gOu+LTHqmsYRz2p+LPsPUUSEaxzowbHIcX6GTl/WbOcEXiBQT/v6WwMgvURDF6V8yyvt/kZYOZBW488BFAJ3CQDYrORHqQP492i06qa2RFVeCMdYKcfqyaBAiXKgKW64XvnV3/ljtumEcHXAIxSGZcg6P57g0Yk9vsZipwBduj7hLoV+P5yKurtrrfUpN//OSHAnViP6KB7qHPA95vI+nCrDVNhV2xlaDr4WJt1k1sTpkT4BJZ0DcBbmshSXovBaKzIogMRoibRY9zFNPgBECDDY3q9Ef4KKXJnVsdK3lpEJSh+ZndxKhY1EwEn3pMUvDxkrhyFAfy4XhQifkVNY8rOYKNRXHWqQe9VrOlmo2sO8NM46zJSSsH0wMtHtJ2EquQiYWea04HN5ZkX14elcnb+Cjd/yju4mD3VWlAYvF4yiv/TJ7HMgz80+t1JHXEjX/3RwwW8cojKUtAciyea/u9+XYhJBZty
 BpaTFjD7
 p7xL3vewUzR/BoL22irID/osea3uqlRCBgnJIWcdB2JGd6UQAYVlxwpvlVfUL+/4UGUb5o0v3e/GZzeN74SUNZq22vRYjVGeVJwIxRCaBIgl95D20eOh5efLxJtJA+DEg4XbNGnTDN6Ngr/Be0/EPm4eF4hi9RgERvS2eEE1ODmyIndROn4oFxkVVa7A402NbIabprj3V1gF8vCHXjakaW25MHFNv+Vo+l69m2sBht41oEgDylX1OpbkPn1FB4YEaXR4LBr29d+80QtbjhPFg9hY/pGfEefQNBGNDMkT7McQZsLT38/hyjNjM1VIoCClzoJ2mGOLF7mIT6pg8LGIQH113qsNtzd5SgcC3XeNjdECk29eZwTEU4bCkknpNOpXaGiGjFHJ4ZY6NkL3MtpA8u4SYzfMdZd44dgdAeQeTFK91kELtw9VCKJ2YSbbyf5IzQyWoDl+Pnv5hFuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 09:43:38AM +0800, Ridong Chen wrote:
> 
> 
> On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting folio's refs and gen info, make the code easier to debug and
> > understand.
> > 
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   include/linux/mm_inline.h | 79 +++++++++++++++++++++++++++++++++++++++++------
> >   include/linux/mmzone.h    |  2 ++
> >   mm/folio.c                | 19 +++++++-----
> >   mm/vmscan.c               | 61 ++++++++++++++++++++----------------
> >   4 files changed, 117 insertions(+), 44 deletions(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 621c8653d8f7..93bf3fa221f8 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -142,10 +142,43 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
> >   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
> >   }
> > -static inline int folio_lru_refs(const struct folio *folio)
> > +/**
> > + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> > + * @flags: folio flags
> > + *
> > + * Returns: A number between 0 and LRU_GEN_MAX, inclusive. Returns -1 if the
> > + * flags indicate the folio is off the list (e.g., isolated).
> > + */
> > +static inline int lru_gen_from_flags(unsigned long flags)
> > +{
> > +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > +
> > +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> > +	gen -= 1;
> > +	VM_WARN_ON_ONCE(gen != -1 && gen > LRU_GEN_MAX);
> 
> Perhaps we could define a macro such as GEN_OFF = -1 to make the code more
> self-explanatory, I found this warning a bit confusing at first glance.
> 
> LRU_GEN_MAX already bears some resemblance to MAX_NR_GENS, so introducing
> yet another macro may add some clutter.
> 
> Just my two cents.
> 

Thanks for the review.

Let me just simplify the sanity check then, I think using MAX_NR_GENS are
good engough.

