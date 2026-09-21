Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA7BC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEB46B00B1; Mon, 21 Sep 2026 14:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C57E6B00C1; Mon, 21 Sep 2026 14:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202FC6B00C2; Mon, 21 Sep 2026 14:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F27A46B00B1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:51:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC39840288
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:51:29 +0000 (UTC)
X-FDA: 85238662698.22.409ECF2
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D80440003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:51:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=REmmGE23;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790016688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE3Tr4gm4tvb6Rbj5+pcpfeQlxZsP6Od7O86P+CMJdo=;
	b=oUC7zRwuGlBJuiG5wuJcgVmO65b6iR9KCEohlv2TwFOApmTCBTCGwdQJFl7DDQI+2LyZL5
	MwM7uBkqTI8GLDzyVwA4IlHbYPJWoHia87ZF/qLzbh/hnPyOBnVsYDr92SsYZh8krhnWd/
	EZvKHYS4JK70sGYR8s22HP2hr0TeBrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790016688;
	b=MVfCtp5VOxyIIuTdp+Eh0V6V/QJOVwDhgCsDJ1H354ZAZdcuBVXtHZMhUys6pArkcNeGOC
	jjBe3tCRQ49ytUSeTkpY0y209B4LJbxDfa7OloQZAYxvi6rT94Fva9aTsOqz6Th1fZXY4j
	dC7V4bf9gAmwzdyYJzpHOadmTfT8awA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=REmmGE23;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6c0fce17so17444215e9.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790016687; x=1790621487; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tE3Tr4gm4tvb6Rbj5+pcpfeQlxZsP6Od7O86P+CMJdo=;
        b=REmmGE23cxD3X67lrqvtPTdu4vy6OBPqFU2bTd7077I7csIAeW7IOvPBgqKTH2TyI9
         jp93uZALa2i9DCaF+4GZR/UkfOidvLg5JC/CDg10wAh/iOZy4RqeeGqisSz0RuNicqQS
         MUWajeko9cavh8cvbfZgNi5RJHsSlIQVXFxZWTmIwe+yfujF6W83QKG39oiSWFmaFcnY
         PiT9fdn6cKHpj/pzIbkPG3ekl29E8YoimQn/6FYklW3lM/DYK6JEShHQvB70s69/ZkjX
         6x1U+bY7GcsNOrwbP6/D5c7zrtGv16F/9c1Qt6ZIgelmMZH4DtRgPUSBx9PLdi5QGQ0B
         NlVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790016687; x=1790621487;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tE3Tr4gm4tvb6Rbj5+pcpfeQlxZsP6Od7O86P+CMJdo=;
        b=g1Z99cURwUBjdFF+tDXwe6lxW7ED1LmdDw1AUditJygKdUQuzQnlYuCwgBwrVNUCz1
         k519XqocyFstl1vh4DYdY48EDOrPhOnxjAfb9i+dHMJU1LDKb/ffbrN0C4Xr9iyh9Y0d
         wGz2N1seAx99brwoOIa4HhCxV+utvkqORi6fldBno3d5/8So9kzBPm0MmtF+w7DfrDhy
         Z/209Pdt8MytNV+ZtyD0DI06DYZQS/nuzVj2mVX7fnRMhPJ7iANsfVd0Ez8JrRcj5XCI
         FzgIqRFcfCkfBwZYur9cHfX9jqNXDK/wG+uwq/7ToVVj6DD2UPOWd9f9wXlGhHtMcdi0
         qCVw==
X-Forwarded-Encrypted: i=1; AKwUvBx1tkPJq8ojltNwc9sdFGOSJ/p1W6Ls6+jhTuc9X4FVcoNuJUq5hXmJk5qNza+q1zbQKRWUpKefOQ==@kvack.org
X-Gm-Message-State: AFuF++kx4ACu+D1RHouJWhLcDDdVIKjGx+qPMbkUhMoxjvxxux3L54uf
	WDmixwyy1BTFBxSfRD/jPlY4W3DLli+RQdH059WTspnvgt2Wnwh1ePfz
X-Gm-Gg: AYBFou0kxyuHl1zTWVppp1qfA0DH+nT9nGd/WpGXnaxURXGCY7iJ7oxrKcfMBcUVJhR
	RdX7hjafyu7kc5MuoHL6PpYJqk+umLlblHPfP7YEWCYu3FcFJxTCwcfusCmbgAficHxGT0tSLRe
	LMDQwayxX7m8G5EuqJ+gNcY6bqfqroao+LholQgARU+2DYBhE6cZ83RD5dwm666jRe4+DWuOhhY
	8f/MwHVNWgl9bD1tZ37SSQKZxdBoMSUlinjCFO+a18fInQYqhb5c+MQvmIlcZ9oVTM10W1b8C5h
	M3ownvuXTYz9WVcjQYfZCWUiNkiiiwBWeg1lRIcB/hQtZg/1QcbamxInnR+h6YnfbyLjv6RiizL
	ok1XRw2fmzSjJCo1kZqBsWEN8fRcRV2wmEYpj71eX9Zwu5ap20LFgMerUY0dnjhD6a4nvgvlbWB
	bSyn0mwav3xZ3cL2nZUI4SldCTomGjPphQfipbsQR/QKXcxqsAFIKqLbQdPPtAIbKgagjxycmPj
	DpFOmyHkQ+veiQDzHZ+aCTrQ1VufFs7Rtvm6EjGDjG13VAugTx6zhmPL6iVsX1zf6sRFuH2gE/N
	HJEmbK2koejK0Fvemnqz7/GK4iGJ64hX2xFUeQI8aYw1t8GN2mAZRAGowUzdE7bsuT7A1fbszy6
	6SNlRzPyFGLY7e8AVMjsLgZg=
X-Received: by 2002:a05:600c:310d:b0:49d:15b9:2a2a with SMTP id 5b1f17b1804b1-49fc5721b9dmr177099205e9.10.1790016686303;
        Mon, 21 Sep 2026 11:51:26 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a8e9-c501-45ee-6f60-3fc5-4072.310.pool.telefonica.de. [2a02:3100:a8e9:c501:45ee:6f60:3fc5:4072])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd8b9fc5asm11550875e9.5.2026.09.21.11.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 11:51:25 -0700 (PDT)
Date: Mon, 21 Sep 2026 20:51:24 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: score an unmeasured PSI goal as not
 achieved for the temporal tuner
Message-ID: <arF7t_kmisrx0_WF@gmail.com>
References: <aq4g5W58PgWLqJ8p@gmail.com>
 <20260919155342.85699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919155342.85699-1-sj@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D80440003
X-Stat-Signature: 674hzgwmco48cfaq3h1s3199rhfmbp6m
X-Rspam-User: 
X-HE-Tag: 1790016688-941977
X-HE-Meta: U2FsdGVkX1/LNo4WXJa+N0oR/dFAApV6m1E7HKgxYDR7AMyveIqpJwnpPPziUV+j5EP1fFSNVpCYMsnJMfCRYwCQhrB7JSTuwSO0ABeFGW00gmdVNnHVYMYdZ1ii9IGMwSq/wDoyad0DDKE6Af03/nAthDasLAgPxqETb8RcQLc6QOX6/AgEkDuRTOguj4Se0Y2SYTH9/Fyaljy4TRxpliGtui/48IA9F0ONcmW+dQ7BrMbzLVzf9slOsGAUJiFIqCx2GMhU9zmE+hNaQeI3mqlC8KyNEeDsSzUHJLkeR0rnOdfocuUFZoACVmzx40aygCBNIyRuGltmDIRbXVJyYzE5rraJ+gwKOJlO7d6mDNoiLLg3WLZY7D+5qBEcQ4s1vuahrr/9bb5/cZ9YLA0WlrIpn8me/TpkjrMFg3TTU0v3o9LZaBX5TTUNCc01vF5Yfdx0vScm/mTABQmp4CJJQvU4Zr2t7fZafsONM2mYQAcwDpyCXJ0J0zUVa+pnVrOka9q8tKJIrsgDFRTPOucNqH87SiDqHvpcJTQZkZHRVJ/iiy0i+fNGa6lGRHTU2Wn85NJC4pXfJeCAB1qaEJTS8tPMVehvK4bkcenR3iqqXYw+IfLZuNwa8YQSDDO5T3h2SbhSYJsbGB9SRgeW8qLx9naOicIdFtiyjdQUFTGI+hPAQdff7wNTihBTp1zRwCo+BKAVbUz5O9xg6eE8I2N0D4Sme3d1y+zjMWfxv4DrB0p96Sj+RyU2IbdWYb8iEZa/Gy4btGEAX5UTIPajaI84uc3z5iaTBHHH4qLJlGSUA0Re+a9/qgY71gI/1D1c66UdFaK/NxBgXNXLNzIGtDOx09HTxsn32FYPa3VO4BMwDyFIEmf7Wgn0G01wDVbHqD21p1P5jLLcr3C2/SHoedrGo9YOXPVr2DqVFcFAxgTCZNKNk2pqlX94RfiXXVDD30XRC6v0zaeY9EgFv6j1smN
 2LUDFaWF
 iFXRr3PoOaXEYfWTAb4aYZWkyIAoqHEV3keJNxtFlEQywBPCV907+D3u1KQ2ZU1k+qr6+vm7vKv8qs6IcgXYC9jMq4b+GfFIO6gbTDVWFMhjYSsEn8k3zEzXNPpJ3Sp9H9MwXZnqtA57mbiTIXbOKp95NtKIQ0Zn5+8LTn30fQDQjdAxwb+UKpCtwBCdXt5wf5jb9ZbpLVu3puF14HTA7f78KfUlYG2Zhv2Evn8erY5MGbyXUuV7gRfzBS2rAffuI4sH5K/r/MpzoUWtNU+sXJbujK5B9/EFdz8zrcz0qsRcxhOKdMIwmwWl3cN4Ntnbh/lKNwm4GPetZ9v/scaHLkkYQsKHbIRwtOwB5jSBmGiZt5eF+7slBtvVgVesaxLREc8DWOujXp9k3GlqJtLYYENy3sUf6stJvVa3OQkgTTF6Bv/8Jniy93LACNI+p6R3IsqdQVYqVBF9MaHFmBeWXYAZ51eeijzECG3b1nickQw4qKYcurPJ4CV5+8+ZvgJGsGLypQSZrzqapiJi+daI7iuoHZ8FQ+SseUDEd4A5PDpEUI0xNDJ+69UmZYeIgI3qPgoH+99L4lf2ymi+c97PqSRmXYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 08:53:41AM +0100, SJ Park wrote:
> And the apply interval (or, next_apply_sis) is extended for each commit, in
> damon_set_attrs().  Hence, the problem can still happen.
> 

Thank you for explaining the apply interval. So the PSI measurement
period can exceed the quota reset interval.

> > full commit zeroes esz, esz_bp and the charge state of the running
> > schemes. Please correct me if I read this wrong. I can send a
> > separate patch for that.
> 
> I don't really understand the problem.  Could you please further elaborate?
> 

I posted this as a separate patch series with KUnit tests:

https://lore.kernel.org/r/20260921003047.12041-1-kmehltretter@gmail.com/

Thanks,
Karl

