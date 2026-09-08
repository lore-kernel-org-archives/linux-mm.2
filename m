Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4172DC79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE5A6B0092; Tue,  8 Sep 2026 11:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4FC6B0093; Tue,  8 Sep 2026 11:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2A56B0096; Tue,  8 Sep 2026 11:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FEF96B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:08:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A43A5140724
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:08:49 +0000 (UTC)
X-FDA: 85190927178.01.7BEF07B
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6F2A4000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:08:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FITqEbez;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxbeSw/1O0AaW3ymGCl1woEb6mnK2PNLKhFRMNzFF6s=;
	b=32ZoMVg3erTdarZQlYGBxwZ84nkt+7xP2B7ZltFwrb0NBKdemhpDV6RHOF7Eao8BwOw3PV
	EiHWFF01Ivz1GMA7e62OaYShVgmcil72K6e27ZTyPKkpX00f3cSCjfZWyy3nTZrk7v7biJ
	M3b+BsCOE8L3RrNXsu4/G2oRlg4/vBY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FITqEbez;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880127;
	b=t9W3TtASXWhwltCbSuWO15Pie66UJ/fGWHzC1Zrp99ndNwrfNUughrS5SOYVOPTB/rVmBy
	shAXDBsgPu4olsQZh2qOeBiDjIJ4wsvfgtQmzQCWlbGNdjbtW5OCPxA03QjWZG/qCuI5uJ
	oN1E+MeShMZKhP/5KaiuJlzl9z4BDk0=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-90cd96389efso57876276d6.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788880127; x=1789484927; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HxbeSw/1O0AaW3ymGCl1woEb6mnK2PNLKhFRMNzFF6s=;
        b=FITqEbezROBtt6naRba2XfG4JPvZgqI0sXpBTiDsSMLYeLFS5BQcI8RcFIjcx01qhD
         9ZhmDTYsOF8ljvrCEpBRw2JF/OZ+09SAUKQXc5AXkuKAVIi5Lie6c4LZAWe2WcGDiVyY
         B03gT8RK8NxQWhbY0NtgPBDhGV07F4w3WmG6zxReAY/faBbzS4A6MKydK3lmUnW+OCr3
         lczelxfw5uIoBOJ/JmTT2MNCZCfuZGO7+5C3OgjgHrgrR/a/8VqNvv6AjmvgTQAJZ0cS
         WY87D0Kca91FvvzKSVRdkSBIe/ycJgmNwj0ktTWZV92AeD+lZDEnSgVbowvUnf0kIQsh
         x8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880127; x=1789484927;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HxbeSw/1O0AaW3ymGCl1woEb6mnK2PNLKhFRMNzFF6s=;
        b=RigRdodcEklvYnBToE6qAOBe6rg87gYGK3aggz00ArG3+QqqdY/OxORKKTGWKXj7cU
         G/ZsNEmXKuSbrLpEOU056lH011Rt9+6Us9a/M9BARQAv5zuOx0F3muKJiegBtvOek8+M
         Q/ydiR2uew77zBxOtdWgMkxpbwm8A95exGleFrNgEWZj+2jDLfECr9RqqTjd1U7yWPZu
         qg9vf10OMYRrAiIc3H+6WZyNKINiH/j20Ln3x7jlUKOaNnb7sSOISkqUXwqsrTTmRsv7
         gsLBPLA99Yg/AAqtd3AFi31tkqfknMmOu0VFdW+KTOlMW59icUn4hHvTXnrhVuRqlTdL
         jUSQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlMkj4+0JMdKTHclD8fslP6G8EKhqlUh/pfLHyMy+zVbFO49XmCdNdHXJyQuPWiYODBIvcsZATsQ==@kvack.org
X-Gm-Message-State: AFuF++kpD5FlKlgEOZEdh3kfuRtDYzLvjapIAHrg/pgUJWKgQZOd7xB5
	691Y35LncU9x5Rr8BwICtEGW/XUVc3XhU2Hg19qHk17K3LFDrS5XSM6m8gUmunWp550=
X-Gm-Gg: AYBFou2Mge18EFAum4859/p2UNXWjEdwc7/WhMv9TefV+tmSiCf69oSdJF/ptwGpPP+
	mfoF3ggD5lChB1ccrsqg5WPrcuxETEzbEflsa6cI2em+ZSiz80kzOvkXM9s4HWIQ0GipNomTueV
	lqZcmp5t5+urWgHLF4sb7896to+VOgajOye2AEDbvTueI5SEByrwBKHNnf3I4v9NDmAO9ZqkAVv
	D89y6qS5aLiFKWizT9d6XftD2Rw81xncsdJ52AoG/jWoEEh59y1HQz2QnrAuirDg3zEfMsPDqvG
	lGcet1DAyFGJ5tIdqx4f2HOdvKqTLTqZxqcgPWQn62GwFPcTkJxqMv2UjxH9yLlP+vq2oHrPimi
	hrr7HS9oxoJ57FDjNyiXnZNSCss/Vi3mWf0YmU4D3+tGvzJ7/5TJ1uqQFgxss8to35onvW0T0rj
	0e2wG9QwztRiZ9u2PbtHptF+x4LiqaZXoKKz1gJy7YhH5c9QiQBOOdxgnu9YxwYn98UvuB7oKzW
	kqfD15/JLWRQ5X+oaYp4yOlsovmrf+s4JAz+JMkBKKX
X-Received: by 2002:a05:620a:258c:b0:939:afb3:f9e2 with SMTP id af79cd13be357-939afb402a7mr1220077585a.23.1788880126645;
        Tue, 08 Sep 2026 08:08:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fafbc53sm1161160785a.10.2026.09.08.08.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:08:46 -0700 (PDT)
Date: Tue, 8 Sep 2026 11:08:44 -0400
From: Gregory Price <gourry@gourry.net>
To: Qiqi Liu <liuqiqi@kylinos.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm: page_alloc: add missing hooks to bulk allocation
 path
Message-ID: <aqAk6W4LhR4EpvHk@gourry-fedora-PF4VCD3F>
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
 <20260908102356.344075-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908102356.344075-1-liuqiqi@kylinos.cn>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B6F2A4000E
X-Stat-Signature: myxmq4xa5erg3ezxjaxozbku74sxgehz
X-Rspam-User: 
X-HE-Tag: 1788880127-641449
X-HE-Meta: U2FsdGVkX1+UXLb7MVa3PxmpVSRiQ/3L6lPohxDrzrO14fuM6PsqfZUHfd0kFVXzdeW98/0aj8r+y0Sk8TTz5hKcBgm5pCkSoErgUqORlbhWilZJ5JpOKm1L/fJwesmXRkV53mK+65zvVAkewPmUm6pVLhOhuzxi9DaTCAxd8CrJ9hg42uN/iASeF+gFlmiU/hbq/U8wzyfTn3zcL2PJ+i7LzQDJBg0bD8w0Z99StnO3sSLpXzP0mhN1oFzTECjUEv535K4/NI+jK9YwyFeh8Lc29dQN+RlfWtCN9Sj3SAY5mQBSTz2cbnDipP1DedE6EjjSwEFXhivO208q1JG498sa1/6SVS9jkJy1OjWRRFFrc8WGVN8fNeLYDKbag0meNZxI9MqW4G4TMxlcY2RLbW4nzhD+YZF0+JFOGJupzK7fTbLj3JIVACoFErsKCC9PhXZgr8BQvjzuv0L2tQFBkKg1LQXpSmT5QZmu/OygZgBhbUzeMRbgYLjOGqWMgc7ibCYIAsKuZcUSkJAzHGnppHZ3lXM4+EhSj1lnJgR2Fp748O65/aHF+38RCT2D2L2jzDMlcZ/KuYBEhwu9LJVDZZgQ9RomVDVp2OSFLofDScSyYf0wLW1F3rMcZ5dQ5Jhhck3wLt3rhf6Ddd/RYMt5/pRd5Oj3DZaukZSA+ul6nHiMlF1Ca5eu2qsNiUgBAgCPJbQB2Bnfq4QxhyfAlYnXN060K3mxN9R+CLM+5VU3NG+wnkruSdCe8y8eOY3n2c1qWF+JFk+em9KP1SkX591PFs0jyNc2wXh5z6fon06r5v21G4YcFVj4z4+mlXM6j0H48Exy/OoYMPmPHnlu2ATlek7tOn9QBiR/c2XrkS0rUPhOIUPVCgkAjvkbR6nXAV+OJB4QedCFF42EuseY6qnMFQlTSNbTmsR0a0MtfvmHTSkY60uqHrZn+iNEF33aDrSiwCcIIMblxdvYqZQP9a2
 Uc0f1l+a
 tgejDLyGRMmWmHMPwNfLLXOP7jc++hGQZBYcv1+HL6RxkT8k+fImaeWZ1VricrRQmln8u6y45pQwPAvsMpIFXuGn3cesxv3RrCP2RwPEb9arAhnIdf6cXulf1cNrKzJSVjKu0VPSLciBH+naBoDfYclDM6HarL1LkNBKP2LmMxPyyAOhXSdekb2ZVRJAcm/FBkMAHI3M0K8ifE7yCmiNtBAQ8Uj5jLIenOiogFM5DtF0kwmcqPbqllwRD2M4QfMu6Bzw/xpftEzQ5uHYu78Cvf5XblTrh9H6DRrJWxUraBOKJVUrYKpSdRtbJDRUdrKN4Drdr2D0DC7VfL6d6SuDI+DiNsk/wW2cIw1m+6xGExRJvqpGZ/v1cec8ZIfUl/k5cR6AKqROGmuB3TX8Pq8i5O5VObgPhur11yc0/nYkFFDXQ/ccUfYQtN15pAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 06:23:56PM +0800, Qiqi Liu wrote:
> The bulk allocation path in alloc_pages_bulk_noprof() currently misses
> trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocated
> pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.
> 
> Add both calls in the bulk loop to match the standard allocation path,
> placing them before set_page_refcounted() for consistency. The gfp mask
> passed to kmsan_alloc_page() is stripped of __GFP_RECLAIM because the
> bulk loop runs under the PCP spinlock, and KMSAN's stack depot allocation
> must not sleep.
> 
> Both are no-ops when their respective features are disabled, so there
> is no overhead in production kernels.
> 
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>

Thanks!

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


