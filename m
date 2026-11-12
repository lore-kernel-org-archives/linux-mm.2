Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896B5606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=UdAQjjLu
Received: by kanga.kvack.org (Postfix)
	id A973C6B05B2; Thu, 12 Nov 2026 11:43:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F156B05BD; Thu, 12 Nov 2026 11:43:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC346B05C0; Thu, 12 Nov 2026 11:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3796B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:43:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDB1A40635
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:43:51 +0000 (UTC)
X-FDA: 85427038662.15.7805EDA
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id C581EA0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:43:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UdAQjjLu;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OT3KyYwDV0pkmmBWZVaURf9TIcCa5HYu6d3239mcr10=;
	b=Ib/xFcHYMrTzY7v7IXROALvW1biySzjKOb5fLunWqEK6+QLNi6gDnzmqOeL3BIqKvrPjVv
	ZN0OoQPJrV+OD1cFsfGCVYeaOun+E/SR9kS4J7SS//6KvAp62jugKMu57xQqTJYMRJyevm
	4CUOEE81SUVJx51kC4lvtKkXxgi66Ew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UdAQjjLu;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501830;
	b=fQylWtysqJSO3+iW/XMyLrJ17R2znZTwE0INm1F++3tQQ66muSZsMbKM1dQGDwgZHLQ9mj
	HnmTEMLVMzgriPoN4wrU1LM1x7RzE0RN31FfN6L1RRWveoLSvH8VZPIKKiwIFcOy4NKDST
	hKeuUmlS2anRDZZTJBXaTMSIg+TscnM=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b31448caccso807227b3.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794501829; x=1795106629; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OT3KyYwDV0pkmmBWZVaURf9TIcCa5HYu6d3239mcr10=;
        b=UdAQjjLu33Gq5Qy8cfWi0RqHQylnSv+iOIPbh8TUoA1RKkp+m6Pj8LzB4JN8b7vIsz
         u973YRoTUkEyMo8c+O2ro6e0SiM36VH0O4Jg2Kkz200tgEtcMAeVoHgCMKc4y4QVDGWu
         9ul8tSU6ehokbt4x8kFfRYaUVpC6rDSp9PNxei5C0LIY2W4Wr56nWjCBGIYT/qGUWo0Z
         3Z64uViL/BDXZvBNCJrDMiurmc9UTHZ4Ltp27Vtiu0rpoay/DXn+4PBtqROQiSZEYefK
         l3p8WXqxeCot5WZdOdoPXvphGwiPpF5UJoECundJPrYraWLMz7hsYyZq5LZFushpfd+E
         XpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501829; x=1795106629;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OT3KyYwDV0pkmmBWZVaURf9TIcCa5HYu6d3239mcr10=;
        b=R3pX5oZvyBXKRPZCXS8U86rN2pe3hGWPfWVqoyMO1Xx0PL/idHc5KQgz+XK2byTURE
         vbFr9b/mUirrjMF8B1PQ0+Akosr7j77DE5hpRaEoxOH9szFZ5y/VfyrnuLCetDSF23c0
         9gAAmZFfSxiLlle/Wb4SfBnlAVj0PHFN9E9ZruFtsO0ua0NzfDaWbawEhTrWovdNIfaS
         kgRK7o8VGY0KCpcl0Exu21hdTbHBLnz7SqNpJfLNQw/1XY8ztSLzmgiE/KZN0uqyEo6T
         REuxOqGhGzu32ZukVgIFiDiJ+DjBrgEmyZJPrFD9UVCNBbDFJpYkBosCn0qNrFKUtM8o
         8JLw==
X-Forwarded-Encrypted: i=1; AL+hErHBAkRaYs6FLfuWxgvZZPv73kDmK4ghuIvMyXrZmJcBx0LWH+u7BqVVBDfGg2f0I42utZllb8gSgA==@kvack.org
X-Gm-Message-State: APuU4Z9w8dvW/IKbqWedtJj4TCcwBq0P0vTwSQqU6ThLomoSW3GDZx89
	Z9GZBAdl0j9LrUPJmhuCLmeGtE4kp6NegvIHuyaqyUfOBDDZo1LCxLyh74Y3VYFUrXI=
X-Gm-Gg: AYBFou1g6x0Mm7O2xFL7t0gfqtW6fh3GoS09cFOVvwDVC88ZOIBbcj4N6JshdN9atYE
	7P4NRK/MLBoqGR2r8LKvfRavjqZ1EFjdw7AuA4dBt7DYgCR3Xgn0dH8E1Bi90l73WsnjFo7Qv+7
	NUAEaV27wrseo6kAOuU0URj+Nt9gq9/V+Gf29hW3qstkpfBgSdsBLAiOkOESRoc6hGMtY6PU8Mv
	u0xnZVeUrKp1W9lnrMicqoZlCgutXaCeKuBGoFRLnr+6rFrCvmdsX3Gobei89S+KFmkE4WIw8Ki
	1UJANtAaws6H468xTEHycQPxe6uPSG7hv/BlgKFhkcq6ZhukfvYCmh8XdabXtlBTfTp4Qx1jgMw
	8FrXQXgR4FYOifW8K3QCsA6PofLNEvvUEqSBrOnZ/dvvNLhwlkooQVv7jQMj/l1OkXnbtzL6WRC
	KmKVW6APKzsjPuwaaeD5+RQ1XQPVUQZrsZlNHCbyuABJ6hQPRA5JlYuQBTlItYMA6b9Mj9BR34z
	brTfk6a6JHnHWa8rrfnr6xnkV8Hj+LovbCSskYu3ZMKa2WN4OgrAK7GQgdRSl4Glzv4QWni9P88
	3ahEgOawPhSjZuC4HxmGg4oJRE50VJ16CZM1d3wdV4+PJeODkQ==
X-Received: by 2002:a05:690c:e1d3:20b0:8b3:4f53:91c4 with SMTP id 00721157ae682-8b4aa326b49mr620977b3.29.1794501828827;
        Thu, 12 Nov 2026 08:43:48 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933fb45fsm73764697b3.25.2026.11.12.08.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:43:48 -0800 (PST)
Date: Thu, 12 Nov 2026 11:43:47 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org,
	david@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 1/4] mm: zswap: fix shrinker count for the root memcg
Message-ID: <avXsw9ZJHOkFG4Ll@cmpxchg.org>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
 <20261110015321.611093-2-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110015321.611093-2-joannelkoong@gmail.com>
X-Stat-Signature: cnhnssppy74jw7xugejuomeaxuy67ppt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C581EA0002
X-HE-Tag: 1794501829-918604
X-HE-Meta: U2FsdGVkX1+iGAt8Bj0RcEsMGslAWSckKX/z71QGsCC4aV9XBVCQIxMN12Ytiod48B2r/QzdfjQQNNv/QUiCjr/tromAMeHrxhEuWfv6TK1GI+HLqHoTGpzwa9nK3zmWNXAlN7Tn7aPPKAT8uiKgaWZIjnwp2EF9h5cowv0g+a3QykG3AXd9WxSC/kz2idSryAuNbk/ScVfGoPMQCcYc2UL29kevLDboRTYJq11fMfHvK5bvKjS8d8KtMp7TyBCsDvddPapBCRRA6vmcLYcTU8Z6gEYCYV+x9a78FEJ9nObYzZVBrjvQrrRnkKCiV5qwcWGbNPQbYpm7mMtvUjXG9z0YfzBGYqNybvFoSTObAR10V5eMe28EDE8z2Oy2OFNuigJprvYidgt6xuwzjMb2PbeUAFhjwndf7YZYXMDZfjnRZCvGD2vjxCExTgBUQkrNvJYEJoE2Hpzo2Lk1L20rGHsyzKiyV/VI5DA6xnInpTYiFyuyCcrXk5CpoSXn2/chBvsqCPr1bknxWG+7q0fqY3V5mEmRv41KkyN4ZcqmDSGpM7j7GKH+To6SUxx6wrvypLVShGyTo7NiGDnabDHhx/daxyiOwzpcTfFJR5X1Qp2lneDeNkZEiq4p2jV16tIa86k15CPYfRtjvDL9xaxTLOr+PWNgiHG5XvV8UMFL71TOIM4HeEpjEz2iJUhS2YdzXZcqYNqdWwAcG5kTGvpQFZWtVQG6XWWxK3y7lA4f+7GAK4FpduF/kpYXa8RPtC4Or3C/GadE/JX8dRO4VmPPBS7pXS9ivXHchFs1osUuwEf2jwxxmvcYXDU4hbzghWHxbOtTWZn/VaGZmPFEpyTjbmlRVPtKeMrrxUTVlodtBV2O5qbKt1oN+YGkqBt49q2pMmFaEEmQcxkgdNr+kHD03buybd7xMBi4Sf0UEMWdTPwcVTbq66xBEiBvzzwmagxyPRbOsPh1ETwnaPBWsDW
 1YBDEvEh
 37WsNfJZen4wTU36QxfVF8D1vdhk/fEnksnbyxJFbKQOjZik/yDwNG9sIPJvGPdJDkORWIrtXNFucBS8eCICv+jv6MRYZr8hs3j1OtgGAVWe7349LevMtYT9eBBYAJYOt2LaM9D2ASD5Qy+8AQL1PfBkWfH4aiSFXQPg21FF0zZW1XrUo7p1EjRK+8CKXYds96yYBEAiJCv6XGH1Q22t6GTGq+eVvvn93/5yaLks+RO+i2u83ta7DlY4CLgakdWU10BA22HQPkBgjqjHa5SB7Xz45w+aqS9EJAFlKGaR3XaUh1yHnOOTk5nEWbKANocYlKS4hJzSVk4dYEQG7pMy0T7K1UGO96Ll+wzuqoR8BAmqfZLhHwDERaefqxMM9epdMXdlI6iK3GuSStRXfHvOlXMS9X4ue/uMoXyvNF0D/ediC0u45EfEhL58CghEWfW6w2zdzvHbYr5Nt1SJ9iGO/pEebwzzTQQ6CkT0S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 05:53:18PM -0800, Joanne Koong wrote:
> zswap_shrinker_count() scales the number of freeable entries on a
> memcg's zswap LRU by the memcg's compression ratio. That compression
> ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
> stats.
> 
> However, for the root memcg, the zswap entries owned by the root memcg
> itself are never accounted for in the stats (obj_cgroup_charge_zswap()
> skips the root objcg, and before the root memcg had an objcg, its
> entries weren't charged at all). The stats only reflect the entries
> owned by the root memcg's descendants. When the root memcg's descendants
> have no zswap entries (eg when the whole workload runs in the root
> cgroup), the shrinker reports nothing to reclaim for the root memcg, and
> its zswap entries are never written back by the shrinker. When its
> descendants do have entries, the root memcg's entries are scaled by the
> descendants' compression ratio instead of a ratio that includes them.
> 
> Fix this by using the zswap pool-wide counters for the root memcg
> instead. The zswap pool-wide counters cover every zswap entry, including
> those owned by the root memcg.
> 
> This also gets rid of having to flush the root memcg's stats, which
> flushes every cgroup in the system.
> 
> In a VM running a reclaim-heavy workload in the root cgroup with the
> zswap shrinker enabled, the shrinker wrote back no pages before this
> change (zswpwb stayed at 0) and 1016 pages with it.
> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Reviewed-by: SJ Park <sj@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

