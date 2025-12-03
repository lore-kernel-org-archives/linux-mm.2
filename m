Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1B2D12694
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01E96B0027; Wed,  3 Dec 2025 06:15:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9D36B0029; Wed,  3 Dec 2025 06:15:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF666B002A; Wed,  3 Dec 2025 06:15:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A66C6B0027
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:15:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE6D913B437
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:15:26 +0000 (UTC)
X-FDA: 84177903852.08.61F6ED0
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	by imf27.hostedemail.com (Postfix) with ESMTP id 08B854000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:15:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVNmlXjF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764760525; a=rsa-sha256;
	cv=none;
	b=gTngrVUm3omNwPAfjYjpFkhxmcYSbLK/KqFxNub1LbrB7c158+zrw3gbo+AMsI6vlMNNuz
	flqEgRgijUe/UGCjqyv7oQviWhBTwsxfCFSVZkW57WXwK+kuX0QVOApTwwbuPg95Z7Ac1Y
	zFQExnlaAEdj8/FnlbKEAnDofHwQDDI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVNmlXjF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764760525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4liKJMDGkOIyeh/41fba3sjQmLKDAy3L+mDjIKGTwug=;
	b=NLcCamz4vnJKZ9QviYoGK5qgRT/YYfaYO+2WmMlbD/lPx3raXqSmKt9FmnCynMICqdtKdk
	0Rhdkrx5ryLOZwZ3dFyRnOc2Z0y4PO4QG6pTeJh60H0TwZHJW6f0gj57Dt4FHKsGoAzyDS
	A5xdL4HqqwGlIOX5r0OMs1m7bMp/Jcc=
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-bde0f62468cso6513387a12.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 03:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764760524; x=1765365324; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4liKJMDGkOIyeh/41fba3sjQmLKDAy3L+mDjIKGTwug=;
        b=mVNmlXjFuSesrblk1Sh4hV7RmC/ccPGJvLjHth9hoN1jhMkqmhvOYfvudXtqlCp54e
         it0uY/1jQSdZGfjeZRZNNe9+xm+lrAgeOYiqT2kRX/7B+4JKAOa8GJV/G2yiLg5WCfUr
         gU+l2HWh0GMTnO8yZCr6G0iLbZIpJi++lw6ecc7Q0jyy1X2zF8eUhw8AYyhONaY4RWyK
         IDiuAS6UWw5naRFV853GXzaFGeeD6DniQQYY1xMnzWkSE+Wc71yGbfzONw1vnL2cdnda
         b8zKaokMdFj0QZjC9Z1dLWSf9l0aKtBM8Jq83MfAan8a5fRfdAT5v+BU8g7zJb5w+Hkf
         IZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764760524; x=1765365324;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4liKJMDGkOIyeh/41fba3sjQmLKDAy3L+mDjIKGTwug=;
        b=rJryGLIjwbndVCEjCr1s+Vzo8Q4pXNDaKghPOshQ+EcvNKQfaA8U0QhkmXchLXCYLS
         075jyv7aUsOfK3vp1WFRZmiMQNhD2TUXcuyT2ivaZl8GQPEXzeVl31M0ok1R33eQNuD/
         n77vnqJyoGMhl7YjECr4u9voanK0Tj93a1gvTYhe/kVqI53rlyy/WdOFvFOXZvyyA8fF
         2Ucm1r0FVnaQEgbiQywd/g2xygICr8U6JlA8Tv5CYUgkXzkhxRHyemtIRrq79o71VktL
         qhTfUe6A1z5Q8gVpmnJQ3Zsk92iZIGK0DaSKCQyg1NOWrbrTGzCkGvn3N/CU49ig1f6q
         sVgg==
X-Forwarded-Encrypted: i=1; AJvYcCUrTaA95hGxeW+oXrgkpyYCkbP39pbJox+/k/ybTidI/pmhq0uSA+w21tX4kkPl8ElNzMZMbtEeBQ==@kvack.org
X-Gm-Message-State: AOJu0YyNzJZN4WDol0EMm5Yoal2TZdstzxULOHJgtfuGGHzQRDaqDhlB
	b3enSQi/OkgSNXTK/UkuU1QIAHBB+qsMZlnOqSAc9EKQQ1ZfW5sZ32No
X-Gm-Gg: ASbGnct2gWmUUYtbaFLwJq2S7EWu4/M8BPbykmkA9IGhkcSDwvLd3oWazVyqxNSXjQ4
	XUsvQiL03RSER1W282zF3mp28oMIoo+S0/CBu3JXf5mMJNbeN7eV44vQ2k7J/yzvnyVFeg8fyYZ
	R9ylzVymNYuXY/wnZ4+n/qj2xkEHUOYa9JDnj8pwIcK6jcoY3MxW/3Fm7jpafXhYGExUmTHABj+
	4E9uQsvXXNENMLmirksH0JMXJdQmiosCvULUjPuLeSYN8CRkfaawhaUv8HIwdmXY8//RhFzc4Rv
	U+o+qKMqx6rsmSGKhBVaIk9bKQLtB4BwMhmCRh+zw9UrsAOFplMbvLoxaGK2EUNLBhXxdFnpiO7
	XCqs6g1RJhKkpjBpDXdrQLoDLMn+XSReY9wJEkQIS5rXcEC3G5QCgdJr+BnXWdu+ydros7t1DPB
	gDsExddw==
X-Google-Smtp-Source: AGHT+IEa1o17eoKThPPEuyeA7M5bW6iPm6eREoKK7m3x0sxdXPE1FGvFnc1U90Oo1q8SxcKXVOB4uw==
X-Received: by 2002:a05:693c:2288:b0:2a4:3592:cf60 with SMTP id 5a478bee46e88-2ab92d46d00mr1613349eec.4.1764760523491;
        Wed, 03 Dec 2025 03:15:23 -0800 (PST)
Received: from fedora ([2a01:7e03::f03c:91ff:fe02:b162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a96560986csm95192316eec.2.2025.12.03.03.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 03:15:23 -0800 (PST)
Date: Wed, 3 Dec 2025 19:15:12 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: slub: add barn_get_full_sheaf() and refine empty-main sheaf
 replacement
Message-ID: <dq67tbm6bbvm7opvuq5vwtjjrcnrponmhfv7xwnvpv6vp3u2lv@bkruq4dtx3rd>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
 <lvagftdnxgpyafafl2ish6x6phno6xstd6r3zxffs652lyxzyc@2pbngufu7wro>
 <aS_OrvHmgyhQzQIj@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aS_OrvHmgyhQzQIj@hyeyoo>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08B854000A
X-Stat-Signature: 733hunjstxayyii9rrdt5r33jxxzwqit
X-Rspam-User: 
X-HE-Tag: 1764760524-128944
X-HE-Meta: U2FsdGVkX1/p1fpZliVccbAN8p6ZQZZSltSzr+QgOSCZbngnZuIaTLTbYpjxEO06w9LBra0sUJ4J2fY7yB2NuOzeCQFO9R7zWVilUzwCxxsFYAo5NSMiUD8QF3PFauIxlU0RqL3kTS/8xz+LYs1WuJVHICEAoHlyL6OLnwJlddlUUS2myC2b4CPjiIRJSjgSRLyuTyoawLAKylfYnmQ5/SD5HqW5hXRKPHoi5TvYTy0p3rcItWhaxCYcwpwxVo/+lEIeE6SdDEidNztUQdjooEsbMKKIlnLarC6kS9JTahB9sOI77cyE3ajfdB43v/YdwAu4LuubzU1RDUxJKveKFDs8ZpldOJhNHPA8980mDk1Zwtuai69bdbA5Mt5cIy6MW6Y7O7sXiPo2B+7UWn31hZAN1DRhutpFX5IlQmzBx3jt8/zzvR9HWbZti0r+RUBmUwG0Zv6lt+9gay4UgIAzIveIXP64LrQoq7edmgxINFUmhs7cSbuIChz5Lf7Ttl1jsdUCgt54nkAIZiBvSzuhFr1deT779wDuREIf1j09+d2a6Li214JsRKNDlagu//H9mVDo5khcjeo7cO28h24xIdbKVfLDI3J04P9fx4DAGou7AV4ew1Dmu0gK3QrNwb2jcyqEu8EQHcR2/YXBsXIbTufsgyqP1XJoh13SxV/jZk4wfs9FfolZqTWh02K9wza+F7oNAOYAb6OKkOqBGp3H/Lr+uDMwnmviypkKVIT/XGh6pEBJf2BozObz7EboZEbyLIP3/lOfW85OfYEEn/NFHFdGGhOC27hEGA6sbtnMQhBLEfGnp1Qh7X9TBggxIYaXzjbXx3aBPe8bqAAkl+O4gbRKOemK8J4chGXHAIGpRu2INDZV/sZ0J3/k5H13FMCt52j7V++arb8ngfCr6e57hq+6qwuqlBT2yeKLw+68fGYndWCG322IymJWiWBK7L36U1BQpyJKBGmdJPeuHLz
 1RU8oPbS
 2LDNpPn3Nn12yDytN5HO0VAxwEagq5N8nihHE16W6tvvdl50CVhqLKVRUCvGq891cmDMZ3LTD75FLHUV8lsr/eyC0zzc+Jv/6glH35X3M3uA7dZSQ/oqZdGSNmq1YjlP9Op33uFJSvpa5CLNhc3cPWrIcd4oGcmcRLjTKRRm0OghmRsnzp19pLlJiaCk5XHpY2cGMmHcadScPb3rHCE2In3YuTH90NGZw7DUcYG3L0fIg4cCwWKMXxukVMKCtyrP+AkjQ0ysryntyclLeI0R+efZWGpwueuWNWGtO70QOBdfEWMpFu8jFJxkxhgNpClV1syvxm6rh+rDcZnT8EnwtCJiS9fEs+v1SQ1nM1/z40LuTp/1L5x7UAbJGEJx3H8HSWPRx/utt/mFxKouT0sa1MiSvMNqap6R6DE8EzIl6mYBkabJjMBsRdwk6y/pGQnvQAhVYK6g0EbXeDlynUu+HGw6a13tLd6kFit8Fm3Hrz2M828Yf/Tn/XiM1reDeJ8+kzVth8hJsHArnzgnWQostVaYSJSNZxlmOKKJlqWVwATa+J86PkyPcJgLDzzBuDjZV6bXXbcbI9V2HLWsqjUX4C2EXZEa3DZ5LBld0GwFwR7F8st6pubGnn1F9Cwxgcx6pO5blilFmSvog/LJlFrxq64YdmKXr1Q3xi5s6YJ44pzemvkPSGBj/8Od1Ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 02:46:22PM +0900, Harry Yoo wrote:
> On Tue, Dec 02, 2025 at 05:00:08PM +0800, Hao Li wrote:
> > Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
> > the per-node barn without requiring an empty sheaf in exchange.
> > 
> > Use this helper in __pcs_replace_empty_main() to change how an empty main
> > per-CPU sheaf is handled:
> > 
> >   - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
> >     full sheaf from the barn via barn_get_full_sheaf(). On success, park
> >     the empty main sheaf in pcs->spare and install the full sheaf as the
> >     new pcs->main.
> > 
> >   - If pcs->spare already exists and has objects, keep the existing
> >     behavior of simply swapping pcs->main and pcs->spare.
> > 
> >   - Only when both pcs->main and pcs->spare are empty do we fall back to
> >     barn_replace_empty_sheaf() and trade the empty main sheaf into the
> >     barn in exchange for a full one.
> 
> Hi Hao,
> 
> Yeah this is a very subtle difference between __pcs_replace_full_main()
> and __pcs_replace_empty_main(), that the former installs the full main
> sheaf in pcs->spare, while the latter replaces the empty main sheaf with
> a full sheaf from the barn without populating pcs->spare.

Exactly.

> 
> Is it intentional, Vlastimil?
> 
> > This makes the empty-main path more symmetric with __pcs_replace_full_main(),
> > which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
> > empty sheaf from the barn. It also matches the documented design more closely:
> > 
> >   "When both percpu sheaves are found empty during an allocation, an empty
> >    sheaf may be replaced with a full one from the per-node barn."
> 
> I'm not convinced that this change is worthwhile by adding more code;
> you probably need to make a stronger argument for why it should be done.

Hi Harry,

Let me explain my intuition in more detail.

Previously, when pcs->main was empty and pcs->spare was NULL, we used
barn_replace_empty_sheaf() to trade the empty main sheaf into the barn
in exchange for a full one. As a result, pcs->main became full, but
pcs->spare remained NULL. Later, when frees filled pcs->main again,
__pcs_replace_full_main() had to call into the barn to obtain an empty
sheaf, because there was still no local spare to use.

With this patch, when pcs->main is empty and pcs->spare is NULL,
__pcs_replace_empty_main() instead uses barn_get_full_sheaf() to pull a
full sheaf from the barn while keeping the now‑empty main sheaf locally
as pcs->spare. The next time pcs->main becomes full,
__pcs_replace_full_main() can simply swap main and spare, with no barn
operations and no need to allocate a new empty sheaf.

In other words, although we still need one barn operation when main
first becomes empty in __pcs_replace_empty_main(), we avoid a future
barn operation on the subsequent “main full” path in
__pcs_replace_full_main.

Thanks.

> 
> > Signed-off-by: Hao Li <haoli.tcs@gmail.com>
> > ---
> 
> -- 
> Cheers,
> Harry / Hyeonggon

