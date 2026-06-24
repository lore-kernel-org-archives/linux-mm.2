Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F154CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579056B009F; Wed, 24 Jun 2026 10:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52AB56B00A0; Wed, 24 Jun 2026 10:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419106B00A1; Wed, 24 Jun 2026 10:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18B236B009F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:50:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E8051201B5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:50:17 +0000 (UTC)
X-FDA: 84915091674.24.7CE0CE8
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 94D5CC000F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:50:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pozoohGd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782312615;
	b=MVeK/6oRzsZF+MmxJsToq8hj1njFl/R8h5hmzWMO4ADhnBq9f5YXgGSy2s+uRgDurweEiA
	ka4H43DAuW8sE47GgRuq9UVMIVfZoISlhJxHjUjxQXeMeSRaVv5Kv6TQlGDHEyBahzd4KA
	WVrAWGSSGOaKb2MAKL9TGtJSq7NHJOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782312615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gqBIwPaeWmL5XMuFIlmntneXFCjftj2s6pIOw2Q4So=;
	b=KUhJUIYisl1dVccamk8ghRr62vkxLRjbievyku6NAO+l+kBkZOAH0+G1DpkSZ5QOlBq/3l
	4Dr5nbvMsSAyO67YVcaEt8ApXCHL79PlYqg25s6TZaDxE9V3P/tIZ8YO5XgosR6/cswovq
	+51FdAQ3jtDO0FLtVqlqV7quAyFvOKc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pozoohGd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8431bbe3ebcso240922b3a.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782312614; x=1782917414; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2gqBIwPaeWmL5XMuFIlmntneXFCjftj2s6pIOw2Q4So=;
        b=pozoohGdXfsYbuA9DCVMRUByn1tb9kD38ICiP4UNLUQGDXuEuEaKcoRsF7wWZOjZjZ
         YCzMEv1q+rsA39D/Z8vDH8Us5rnCCWeQE6eXbjFdWnScIEYIkT+y7ooFANhUllUN9Ozq
         8szdw/EJcsrXdW2bkd8umXOljrdNPMUFK0qWE0khgBTiNwZ5YF533g+uzQbl8BXcBs+U
         9zRgtt1RezuiTv+N2FWcLREcu6qPEa0LppoWR0RsNDKPRfR6WpDMUC8YZL5WLEum0mqp
         DQGbYcdgc8UouS2egrBKZKuLURXWpXlXspZ8JT33lo5JhtY9JAICyrtLNEmpK0oDVRRh
         jMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312614; x=1782917414;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2gqBIwPaeWmL5XMuFIlmntneXFCjftj2s6pIOw2Q4So=;
        b=P+G76QK37tB3JhUvWFBIqUsARwqAsxgb/Xh58kgbP5VZdE97U0YUJevWOcaWQzrn6O
         K+SJpHdM3nz2moibIAKJ5McMzZJPhqd8t5w4TFAlB9iw07HGC5If5jwX72prXhmY6ce8
         DXlq0K52I10ebZI0pmORJSd6X114h6WiClmfvwb+p34ST/AUvHQDtDR3bBNk/g+HEGsU
         hB31J6oxI/A19QUPzkTq+LJBuEj9C2S98KZxmoL6XRTqmS7URQ2NcFLgDrE+KJj9Lxjh
         adCdyZlB4qgD7VmWTtHxddsGXSIgkG3++xWxmM0s9DW2cCGyn6fF+jqvC/+5tmJPXVK5
         Eogg==
X-Forwarded-Encrypted: i=1; AFNElJ8LJ860MvCiSwd8Cwpn4ST8dEbiyiAntZ2YW387TFc8l3kyC4X2f1iiTeCyIk6aAGvi952DbWCRWg==@kvack.org
X-Gm-Message-State: AOJu0YwBEJafieMs//e1mHBEHsrEcELUY2K7ZTQGlwPYD3lnmdw0dVUc
	72fnp+IcShzfyujY3M2YUMUZpKeBOH4jx6PaWRjHd1Nvqe1621TmfzmRBX+u2DyswxQ5PGWT
X-Gm-Gg: AfdE7ckkJVEO+oBGhakGsDD1wtEUg9GJYuorfn5t81YzP3z6XaGUcnzvejW4UUOhTVG
	3gQrMZxJpriHJBt0BT4AOwIQE3ESFiHWlhDch7Kvbg6fvhvMqPtrg712GuOIbImYJ4JoslN/CRQ
	0PzD8fqqRVkXe41UW0wSFBGV7kI7kn1xeiW5SVEiJGW6RmsdPRNJ+Gmv0XO1/lsy3YZbQAGjWsx
	40h/dauTxqYjAxUC6YM3xFQfM7oVXnjrFc5chtBQ2GYedQIyr+WphD8YQDBqi8DRSkO3xFBeYpS
	oW9P+j5RIHXulvRPywrXqZQsbj2pcQqWPh7CMXQGDlJeu+YrlnDSGUYR88+f0+EMHE6qjy3Lrxu
	eWChgpOOM5snsnYcu+LSzZgaU2kLYoVHyibMa7Z2tp5kHFHpBGodJD1o90xnUf+iaS4uD5JMzVs
	eprxA3y77u2uwk7TvNZ+/HxhmRh9aMhboVFQSB+5Xux36Xc62hhl6OYeiHxYaYr2ljKrnR7Cf3N
	AT8ZU5R
X-Received: by 2002:a05:6a21:329b:b0:3a3:1814:20a2 with SMTP id adf61e73a8af0-3bc0be10a82mr10975133637.5.1782312614215;
        Wed, 24 Jun 2026 07:50:14 -0700 (PDT)
Received: from debian.lan ([158.247.195.225])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a4002bf0sm2374238b3a.25.2026.06.24.07.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:50:13 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: david@kernel.org
Cc: xueyuan.chen21@gmail.com,
	dave.hansen@intel.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Wed, 24 Jun 2026 22:49:41 +0800
Message-ID: <20260624144941.703172-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f679fc68-5ff6-4715-9a07-9eb3074b2d1e@kernel.org>
References: <f679fc68-5ff6-4715-9a07-9eb3074b2d1e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94D5CC000F
X-Rspam-User: 
X-Stat-Signature: pj36kosk5k7y1cue5arwcspqewgsonwj
X-HE-Tag: 1782312615-264852
X-HE-Meta: U2FsdGVkX1/OM4F/6XFAG/ItlOdwlKygD6xQVmvryj2PEymep6tY/Pmifp8WZGWLqBeFz8JlNSiiWGGOmTaiysyZOd3gEPQJf3haCFPRW2QUDkbvhQHTgycHKwNBlVW9FYl53PvWWA5eeJRI/U/6oziTTMdH7iCXSxIHdaoFvPMXSZDIr4HsI7jxza2oktZOAtprKnc42qn0S/VjpYK52yHUjwcwCqXhD1jGdikvvYT56jgMoO0oOXx+4ohSAevCPnhRa5obAz01uKlmrLsGesKlRr6r/SXatG9oq5opGFkbLpQqTABtAS7MQ9oAf5D8aPUvgQE6kW2FwZtjvs1V4YAVuVJ3GcqymDcUfNIF22pG6B/6Va4OcIz6NqPv/THpz1rAkgUznBPWP8zMyOJDM+gum1lFqlswDHwxr8IvZitlmxEkfVyjqHtNydq7osiw/FRdrzUmwzOTWfCOuuBH6DKOpnCe8PzITJ6dcXuFkD4Swg9kXlfJnon3C+nZuQiRcyEtwD/srX5X9oiN/oMpTuNa5WJ6b1aXIbQCxFqp1+PSUs8dqOqTI+tnP3yvAmrPkp1oqEExXG4KAP8MU1n7/W5/C6Zlw8vT/z38w8DmNTIUYYnE5BzEIt9Mm9V6P5Fu1dGHnOCKsJlYni+ei0bP6CgF9DCH3rcHlDIQzJTtp7sCa7j56LIsm+bzX7oFOsQmBvAY2cKpvrNDzYh4nAak2wTa5YaEJGKiPeFj7vY1Iy8H/5+i99aoqpxRfZjZSLva6yW12vx79cGEV9lXi9RpeLLK1Mfp38Pch7FGst5xVuPEy4xbMheAp+Jm6R09GpRDAG6Xhep2DqmV+EBMemuOnqJSGQLaX+yXET1UCJrILfHM+rtI+Uw6GRvb6qX4I/J4Nadd434pJSPi4LhZjP5Eqm8veQ97busmgf10Nc1F5dMBFg+N/SiAUfKN7dAN83ma0NU3ziwslUvVWQCgks4
 iPl0HmvU
 d2jzWy5oAw7kOB+OTL3M2hID37ZYmaprkfyBLsUwKfOsYbuKTmMStWm17OB/zdFYvNGOey9Jb2fhqzhjMY03kmELFQ59KSlvnzRGY9vixUAcEIag6FD3iPN+ffg23B/ugkrx0bCP1MAdB9uuZyA04I4sjCoe/yNrDKgL+aJcjMbjc9C9lUL3nKIXChr6PeC1TpqguqmhD/KtWtXeaDXiljYhIQOKa3FY6v5PAj4hEhwkdE4kVOmd9KnHeUE9LIyKi/KNaVyztrh68VLxNqBboSqlLLwMgbvK+jgKUZPHCAQ6sVmAUyp1WmK6l4f+OlDElqNU3kxVbP5zR2LBC/oZwLop1ioGQiVleCz9ky1xMv8ufdomniC3jY5menVG+td4IKOGeY4g2tfFlwvUH3Ue1HcJ1zh2SlrSMhWI3wbZ5IvcPkcPuAKLDJX2wzzPlNiHk1YolATgzce5L/dQQBh6Ck/SAqi6IRQy5EZzeTZsXUbFvvvvJiGox3dVKrMMvIiI977p2j0VnAsPvuwrV2hqtuhfSag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 19, 2026 at 01:09:09PM +0200, David Hildenbrand (Arm) wrote:

Hi, David

[...]

>Having a new direct-map specific function with clear semantics might indeed
>avoid even messing with that.
>
>So, yeah, given that we have
>
>	set_direct_map_invalid_noflush
>	set_direct_map_default_noflush
>	set_direct_map_valid_noflush
>
>Let's add a
>
>	set_direct_map_ro()
>
>Or (my preference)
>
>	change_direct_map_ro()
>
>But given the existing naming scheme ... maybe just set_direct_map_ro() and
>we'll clean this up another day.
>
>
>Now, should there also be a "_noflush" in there, or who is supposed to flush the
>TLB (or don't we flush at all, because it's used early during boot so far)?
>
>In any case, for this function we should add excessive documentation and define
>clear semantics.
>

After talking with Lance, we're leaning toward a direct-map helper:

  set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)

Contract should be pretty explicit: direct/linear map only, no alias
handling, no TLB flush. If a caller needs stale entries gone, it has
to flush itself.

Huge zero folio only uses this early during boot so far, so noflush
should be OK. Will document that.

Thanks,
Xueyuan

