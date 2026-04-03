Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4930ED6AB1F
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 00:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746356B0005; Thu,  2 Apr 2026 20:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F75E6B0089; Thu,  2 Apr 2026 20:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E62F6B008A; Thu,  2 Apr 2026 20:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA3C6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 20:45:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2CF2140240
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:45:05 +0000 (UTC)
X-FDA: 84615400170.04.8F1D3D6
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id DF819A0006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:45:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PeF3+q3+;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775177104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nc2bWeNZtLKm/ctbiyRLlxDwOQ1uLVCnFLmdvpOYX6E=;
	b=h7hSmZNK9p6CwQhF7NhDMCYEIWK94HOmbcPMcNUTDIDjAbdPGJOyZj3O1zloBJQJTxLb4F
	MXx1+U7UZek0vWJFQr8QVjngZJjCn+BYDDKRf3dfWQXqN02SvQAWVyPT8A635b3WLficwk
	U3zjU7V2N7CzqACvF2Jsxf6GFBBgCEU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PeF3+q3+;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775177104; a=rsa-sha256;
	cv=none;
	b=oXbTW0PTXKlF64+qQz9t+oJv5sF6tTWkIbh5+i5z/IQUh0+vtlAcTT0lb7mZfZRMPEfYJ7
	5aDNQqmxz9rRWdd8y55atMIcQH4b195gbhOaJA1b7vXc3iQWTZedeR0F+IzMmhjGDQoJJR
	gvErGURPE2YobYXcMWePwQCobWF9SXE=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso19417356d6.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 17:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775177103; x=1775781903; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nc2bWeNZtLKm/ctbiyRLlxDwOQ1uLVCnFLmdvpOYX6E=;
        b=PeF3+q3+0p5sU7d0cu1MxNjRzodGfAzxORPCxDM15cDLxLlgTEBis8XZpsRq8wpGMz
         KsDZelX0o4CqtrIr4qiEWBuNwVLUMErp97swFYpACKFw3p05MNvRyV4Fvpbi6/DFs10Q
         9yCwzRgXAo+EeBQchkVKYNvRry7BxvYdmw+WXIDelDcj8RUfROyK1P/ukQpKXxZKsh2V
         hsYK8dmxH4ZVuo4wDjHthrn7nQW7A6AAVZ5rDwqkBri2F6F0EmOZJlrbqIAL6jhfURli
         NcQWnLovlt9iCOPdDCN3vhcnQtIGBeXHBeAwThv/nfn8z5QKot+rYpT42AzZJdbK4Tdy
         YVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775177103; x=1775781903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nc2bWeNZtLKm/ctbiyRLlxDwOQ1uLVCnFLmdvpOYX6E=;
        b=W+xRRl21nIDlxHWDA7ivFaF6ALy4E2+iU35NBoW+hV1RzyKFwrOKONBn8m6FW7hdsj
         idcmS7rB/W3S82XBkOfWBY7HA0Lb537l7a3wfwpRA0GJDIAWbIbQ9ElskYY7QxWcS7O5
         gGtPqWifRedPdHZCcJGal7pU589+0YBolw4ZL7B6X7J+Y9x0RVzdIjn8m2KJzeDvsvui
         DJ38zc8oR3cNMM63hvaw3DJfYbCDaLJQkM+2zNOG/1fNp/PMD3FDlNMqc1LYRLQtgfb+
         6BGubESWiRjhvN6odNKw7V7YZdoLQWrYnukBqZJihcvyU0mPrkNXBD/CX9po2R5eIEJd
         Sfzg==
X-Gm-Message-State: AOJu0YwmiZtwMBPayxFxsiqsWoCftmdCSiXJSms38JnU/HqTB4mtsiUZ
	xo69yk3JrBZRHWWmn7+PWU1fV0OsYa5fO+CUo2z7nVHPiO764A6e9Rt8NIwDPguzD0M=
X-Gm-Gg: AeBDietu3sNRDmHEl6cA8sRWK5KCTYWOxpa0BHHhYvUebLe+tAyHkciQEwFrC+Gkp5w
	KFc6AcsTz4wHUFlosw+KSbUq+HG4tP05tBRXJE+pbj15vvylXzgjxstK2qyqCh5O2z0sDslWzpx
	DXvPbEhlOIqkeFRApgDbHZJ4AQl+vGJ+3fcTOPKZMnaXj1+1rXCAOFXDiwZK8xldEbpEDWhh9um
	FL+i3TwYKa9NIO7oXIsucRhIjvvEGdLALOj8eME3h7hBGFh6Av+eNOwqINhia9e3HsbMqH9r8VN
	Yai44+fP+ee3AzBfI9eCMutRStFHmonUoaP9J0aPgcjgSH0Uy8n+G9fjrjX1vgl2w7e0vQFJc2j
	fP6/Fr1eN+rX+PrzkaVitsYoQFkoo6+SXETMyHuZ2/86EQVe5PxBFLXJ0ySK3TgtP8Ekdb442VG
	Jo/MrDSuOWZdoxz/V6BuuSig==
X-Received: by 2002:a05:6214:5f0d:b0:8a4:7977:e5fa with SMTP id 6a1803df08f44-8a702b96165mr25937426d6.25.1775177102854;
        Thu, 02 Apr 2026 17:45:02 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a596a0a655sm35304536d6.29.2026.04.02.17.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 17:45:02 -0700 (PDT)
Date: Thu, 2 Apr 2026 20:45:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, riel@surriel.com,
	kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmpressure: skip socket pressure for costly order
 reclaim
Message-ID: <ac8NjV3kmSY95soh@cmpxchg.org>
References: <20260402232511.17246-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402232511.17246-1-jp.kobryn@linux.dev>
X-Rspam-User: 
X-Stat-Signature: z3rr7rh36w31mdy5f677rdkzitfshnc5
X-Rspamd-Queue-Id: DF819A0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1775177103-209412
X-HE-Meta: U2FsdGVkX19Sub1lxwGfAjypONADMIDkYhxOdb0grSABXEsRVnHgs16tivF8rAcEEvCkZuFHxno2YHHTPwWT1FE7K+B27V0mrwmUUH2l+KmNYqKBDSWuaNRBtlRHTj4BMqp5M10LmjGqPYiKPoIs/oNHE4X3eEYlNi0rDwqP/2F+d8skdL/4EmWXh0QQPtvHytZw/Y8pQT0vDp/LgYjpdwD38FJNyIpNG31ZOyO41CzifRnNS4s9zAqUPZ9OP8xAeAwYDEsxaeZELeEaQ2Q49B/Z8WQjf2XzlYIqW0IqHeEuWCKgzPxG3pjxhAFft9Wbzb4LuX1r/ICShzsZ6t/o/v7qBarCG40ZQO75oARtdvmtySd7o/tbmTrTOen9+edqYZHqXV0p/pE0xaKxivzJAWwDYr9jcknNI6ixmlFNzqiY0VXADJuHa2M14z0/8tx0mfGKiiB+J+tWP0Bdi3OpNWobB9tEvV+kPxQ+qPgKZOy5WECff+LVLBPptK/XqY1nvNPI0if6IMH+BwnJGRRq0DjC4C5R9sdFzFpl3UK/mCom/tjnx3srckhnopXSbeFE1iR1KU5zOP5kjj25dHGUICxqReELLowG4CGGNjO69/hLPwp5SDV+S0zSBhSDDvO2S+ymidyl88Wc89GQ4bQN11pE/FRWLpsz6G+rbRuFWMjq5mGZwG6TgQqtVMsWzaTQQ9LfB660ejyiSy4HmXPZu3jkDKL5HntfNXH6HxLS+rYIxW6e2+G46/ooqguQjU+xXCtDZfrDi8j0rCyP3wyaxWypQfA72kmF/pVTVrQSnD+m96X9bRd5GLgs76Ph/zY0iG01hPxg3Au0gj2aT1wE40MYu7trG0V/8o+OZNRkZ/DoCIlBRzu5887qAX2v44uRXmSZZ/0Fro/csTXLNhPRcgwiphr5lcOOv266IJyGd6XP1W4ASiGMV8p8vZv6rV5F+k+S/uuUID0/UM5d4bG
 TtpYDGxC
 YeLxQALzUfXZtwM+WGSSe78MFPtnpXrunjPD/jwflMlQn8DLeVC9nf7Ks7SZRWHvOxN/0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nOn Thu, Apr 02, 2026 at 04:25:11PM -0700, JP Kobryn (Meta) wrote:
> When kswapd reclaims at high order due to fragmentation, vmpressure() can
> report poor reclaim efficiency even though the system has plenty of free
> memory. This is because kswapd scans many pages but finds little to reclaim
> - the pages are actively in use and don't need to be freed. The resulting
> scan:reclaim ratio triggers socket pressure, throttling TCP throughput
> unnecessarily.
> 
> Net allocations do not exceed order 3 (PAGE_ALLOC_COSTLY_ORDER), so high
> order reclaim difficulty should not trigger socket pressure. The kernel
> already treats this order as the boundary where reclaim is no longer
> expected to succeed and compaction may take over.
> 
> Make vmpressure() order-aware through an additional parameter sourced from
> scan_control at existing call sites. Socket pressure is now only asserted
> when order <= PAGE_ALLOC_COSTLY_ORDER.
> 
> Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
> uses order 0, which passes the filter unconditionally. Similarly,
> vmpressure_prio() now passes order 0 internally when calling vmpressure(),
> ensuring critical pressure from low reclaim priority is not suppressed by
> the order filter.
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

