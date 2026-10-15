Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23330CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 03:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAA36B0096; Wed, 14 Oct 2026 23:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D22F6B0098; Wed, 14 Oct 2026 23:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8AE6B0099; Wed, 14 Oct 2026 23:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E08DD6B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:24:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63E891C4141
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:24:16 +0000 (UTC)
X-FDA: 85323417312.23.19F6B07
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8D2C740005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:24:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GQTGVfjh;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792034654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RAKj7MN73RI8tJkT02x1VHOxQPPjvpRldJHyl+Kj5I=;
	b=Tzxfrsxrued97pPeFH7o1ToFpSGOfznD8vw1LB8VLo4eDVHBf/+IUd1454WpJuC11GWF9u
	j6EiAGLw/N3LsUoJADMpRCMAjXQXzy3S4gZRZYymj/8cZk2pNVjg1Idppz5hlx6cpPB5Ex
	l+ET7FE8k+LqsYScZptWXWFKw/ln6No=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GQTGVfjh;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792034654;
	b=o6SPvFzxM2fQuwQPqJfxD35QK7uY2togwqiSCeCmHBJatBhuKkwgc9iTIlOjUEB3MrPZDi
	RdSdBhIXpKOFtkRffbLfI+hCgzOpFYKruY5pSXcRN492wLs9dPqVuW9RmeMqlIBzhhDdSi
	Mbg9EBMNrjiivBDTINFYW6+xrvQ1U9o=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-88c72646f03so605172b3a.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792034653; x=1792639453; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8RAKj7MN73RI8tJkT02x1VHOxQPPjvpRldJHyl+Kj5I=;
        b=GQTGVfjhaGnhcbE/tlLk8fbMPX8Dh8KzxdsT99lKMvLWkS0JB2Llm+AvS4wirH8JJE
         7UPhUvn+AZHiXPxB48H7jMNSNI5mMPeGigAL2siQH24q5oaI6kvDd7gNNVSp/oMitWYW
         /AWgTErRvqKkl26IW/fHqAmTVsmQLHtIWuyiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792034653; x=1792639453;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8RAKj7MN73RI8tJkT02x1VHOxQPPjvpRldJHyl+Kj5I=;
        b=BIN0hKNCdFG7Gdj5TScnpEZL32YRWYA2D0fVukvY56aDvUlL7M8eZ65EJF1alDLu76
         l8VHMjZ14ht8AY7/8xh299XqwzhmdUZ6wmfV4nHF2fVuwso8SLuyiTN18oEQBk8a4UY3
         9R7WoGD/8can4QwM7/nbhzUm6oXLU7Fa84Q1TyiIf0/Ss0Kcx3rB4uivaCUuTsFQ+nE5
         917mLiTIYSoYySrbSyZxqv5eyrfKWUIMGa/YTXv80gY+OTRJvuKLO/R4fulGzjw/lrbm
         dVLYA+WPxrfS1uTI8QpbDRMKnXAwp4lG6Ei7IaTOK0W/gcejsYp5mlsLUl2CgLV46TCw
         ahMA==
X-Forwarded-Encrypted: i=1; AKwUvByt/HBQLml8k/MRBPCe5JeKFj3XTCWW2PdnzWuTxv5U/MXA4aE3+vcPVm3J+8CKKH8v260YoQxG7w==@kvack.org
X-Gm-Message-State: AFq9FYJm9wu6cJh2Y28TAsLjofXCR1+Ba71ebvp8eGIA6z6xKtf0tyHr
	vLl8NLv08qSrP85LeXaR0wDcRQREv8oqt3zWqJheJJTFycHT5K6GPTbbpGjSWTvhUA==
X-Gm-Gg: AYBFou36uK+/SBrgBSVLHj0CQWNr3tKjBibqUAugavlcH00iZPDLN0SD99VXv3O58B6
	rSJBpSAjQJybn1z3GDgF586xTohl4bM/wX6MeYLdMtFQhqDkwfijXkiVluIbtXDpP22798ScOLv
	bRsakYp1THRybIMsuGE8nU/hxhLU64GrOvDcsAnZHUEC8I6ln2HYltQ0k5J+pWJUZwDy3D5fWnk
	zKbnvCxxYapjgvz8PFIOQX3nlgE0ZnIj+BErVNd4VcXRurI9BGPE0bD6Pj6osR6MIGftgfESc3R
	i66bRCI5YyKcrT1o27pZ7ruXA7edsP2vVTLfAoTwDnHj5E5WLvl5pNxRQsdOBgJvCelK9D+zIIa
	SxIMWVI1drM4Sg5cZRy9u2bnR1rtaEIcULlrHyvK3nnT/O+D2dYCSzQcLWE5AnGN2AxPfqIgzrN
	hvxMTL7XfO4iVz5Dx3/aZnMcHMXTAak1NC6zGWRB2ls2LFuQx6zVaocLJ82AuVxuXjQI2V//6nA
	MLgTHg+hiJ7SrxAn5jmyDvEDnvdXM1cj/Vmx+/E
X-Received: by 2002:a05:6a00:7615:b0:897:dda6:ad35 with SMTP id d2e1a72fcca58-897dda6b684mr11707767b3a.41.1792034653406;
        Wed, 14 Oct 2026 20:24:13 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8455:7899:5a2e:26f8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89d7f51ff63sm1700395b3a.5.2026.10.14.20.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 20:24:12 -0700 (PDT)
Date: Thu, 15 Oct 2026 12:24:08 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: baohua@kernel.org, senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, minchan@kernel.org, richardycc@google.com, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atBHDEBCVL6Ae0hT@google.com>
References: <CAGsJ_4wuPCPR0DnbrLp7ebdO=Oih6K_yP4XxwETKQ+3U+THVjg@mail.gmail.com>
 <20261015031940.1410875-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015031940.1410875-1-zhangbo56@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D2C740005
X-Stat-Signature: xh6ssqn9hzu5apxkpihchch38qyasey3
X-HE-Tag: 1792034654-876059
X-HE-Meta: U2FsdGVkX18xcfbjU06VfpEeap4M8PMXrb2b1a0YLh7VwNAt9eHzaPx7pmlC75Y9Fa8HZoWXBaZgKuXgN0vw9RkBdgGFsZXVLHz3ZvoZBTE1EMnR2cLY4KVdlGYGr/0hK9y/FPAFtyW8jEARtbMHmtlbe126ZYLxdIR/ntcoZk7Cdu1CwOYxnO+cyKom5TjnymPPEXSgKd9Jq4j1iR5TBa5aZW7NmyHfaES1nOyOs8jA1Uib/H/YPV/q4fT/gKUIgX9dnVffOkJ3LGOZCA982/6sh3+zW1I6x+2Pl5TSXQ5u5ObcaR8KSe9tn9BrDdrdtyvIUNc5lPa+SriQ5Jxkok52TrpKLZ2tpxRovnMINXa39gjAOS0rYLk1BEoYSkl5sx6/GdpPLjteZ4oRxuXq3XdOehG5hb3w5kaTSIrtr64IYXfmv0VpGa+elTNQfBdPvoeL+GJCR+6jZBKW0AKeT9vDapQqYq3EEW3YuxEKIUBFAitXAPtuHfyady0m4AmIyxIVpo3muM0nh97ByP2SqKiyQ1RaVG77UUsoVc+rnWIPFlLLSOLniaaxbMdlA/VyqoT1qCWGht6XeVzobdnJd8DakM1vBGQuZkvZwfU0Bo7kEcQV1MZbXdNt3d3v2pbcob/3li7qxpk6nV6CJxe3nEfucidw6Y39+Irba5fBxB9MBWBx1P+toS/AgQsKc7faALHbj0orEwqjTTVJ5MDxUnRmio6RYhBhoSA+R2+Ddq+vOkB1Z1RMpO4SZr/e0b4bH5q1GnUrsJ2apINpZHM9NdzYRRxRK2OpPqvEvpcFnhJHm6x7mj+8NoBjKKXgns6L1SJuKre0ZvehM1BrWHJC1hrLHxexHDUGixtLt2eBi+iURy2RKqZjQQJHctaiFeSl+zAQouWYw+nutqU8qzqpDRTe2htUuISmgXtTItCh5OI/kRSVqfAjIbLdMUfF1qrZxncwgWKcJh/ttBQBQs4
 5w2wMDsa
 4Rp+U1HEADyTPFXdbJWD3BJpKh8gzIg0Wbc2WTZKtbbHQlFVNoJULsgQFkXFaxbZhScWLvbNU8clKNwFsCtEIFJ0Bf/74joomsLyfL4F+/L4fpLF5HplFPjwCewzw6KDy/5pshBkUP8zs9+H0TA36QjZlZpuTZAoqG1Z7VStsb2XgfWF/fg0ncQEzyOsKfnK1k3BKzwesDEdMi6+bFl9d32yI4ZPBCz0bKc/1PS6PPvbO2ek+eYs37LwhOseKiPBpsQNg73qTPrK7mF9XpLwiRAmt6CWy5dT4C9t/LRkf812xYHH2njb9rr18+g5yzqz8f7gBf0sGEtkfeR/Jk9Qym9yTCqAPnl2Dmy99QYsJGtVQ6ZpPyAVc2XhL5lgsa2y1Tz19MA+STynIAPLe55SVXch+og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/15 11:19), Bo Zhang wrote:
> I'll also apply Sergey's vm_map_ram() patch (with the memalloc_noio
> fixup) and re-run on-device. Note this only helps the cross-page part
> of our exclusive reads on a stateless backend like lzo-rle; it won't
> change zstd/deflate, which stay exclusive regardless because of
> create_dctx. Will report the numbers separately.

Thanks.  I just sent another patch.  vm_map_ram() is a little of a
hard sell, I guess, because of TLBs.  kmalloc() patch doesn't seem
to be much worse (if worse at all).

