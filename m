Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB23C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3DA6B0095; Wed, 19 Aug 2026 02:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4754B6B009E; Wed, 19 Aug 2026 02:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C3D6B009F; Wed, 19 Aug 2026 02:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 179366B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D048580445
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:53:26 +0000 (UTC)
X-FDA: 85117102812.04.9BB8193
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id DFFAE180004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:53:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a6DgFXl6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBQIpuMPNnnZS9TxQr2cmt0QezkZP8hh1DGqeV86S60=;
	b=B3nHNwLd58jGAvBHtUH+NRlGjveCGizjr34DoNYOSeux5BDYuOhEn/f7T59y/+fAyeVBm5
	J3OtJYbGWIrPh6qmDDZ2cJbFEgYYO5b/oU9qQoT5FaW1QZGMASXqMdugPEaQHNTv7tIOBP
	e01mgqIXm/TFQSQO6aaYDCT9dV9zo7w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a6DgFXl6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122405;
	b=RuonlmRV/beJSb9gAgE86TsmLYJymYuxDy1VxzT5C7tmnbGTrdi4brNTmVkL94DwIZJg9+
	6REkwQL+mI7WhHv/pkOLNvJ0OX0F6F0eHgstMXvg2GuvdYQOlegAL6ouFCRwq6eU+uVHpw
	pN8yQqRy2m2f+IIL8WDHVjowgvrTbHM=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-476a130c138so684254f8f.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787122403; x=1787727203; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oBQIpuMPNnnZS9TxQr2cmt0QezkZP8hh1DGqeV86S60=;
        b=a6DgFXl6kV/wyXHMtkHgKiMhO697z+ZoaSLUEZweiUSZPd7PzA4eMnqwm1/+yKlASJ
         2Dd8f+074kPLxSERpXyC4/Kys43qtA6ZiXrJ7XN1YosLJ570QM4NYZqpnHB5ssdjhlEj
         C2uqezBZajnUOQlEotKrURk41zE8UlYmZIr3KvfaR9iIyTmjBXGe9Qgtmgh7ZnmsoqyQ
         xkEcFVbazrkg3U2XcKPLfvk5IgSvf5ZHDMEI9E/X990pKIizoebZY8Ig5UPMouezXgZy
         nTA1++1ifTueHOo8x++eBbMQ0pTTnaEhC//EIC6bc299Tl9gkuD9Lo6T2YNkjgfdzrAM
         aJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122403; x=1787727203;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oBQIpuMPNnnZS9TxQr2cmt0QezkZP8hh1DGqeV86S60=;
        b=rB/2qLTxluTcnW6L8eOBDazyUfzAIw5sMZiC1QvSP4eiyV9dnaIp8LF02pih6F1UmN
         3o4KCiw5+YZj0U3LM9Km6H0lRT/n4rEVKOjwP3GvhRE2QOzZgwYxonwxnv/t06cJ2G7o
         btbvEhM3wzPQQ4AeL8xQ2J8dC3RQAGIsZgbnQ1/pmwIBB+YrmSt+ylaLkXFw/MGcQ6nr
         EwJ79YDFyRXFGq+GQwG3btgqIzrPfYybR3It8XCGh9TfcKrAMRU3JJE3YjQ2S0LHn8cG
         ffVhvcaYRck3ZCyvIDRJ0reD62BN1NNN22b1Igy8zJk8IblSq0AS6XayRyInZwOYLJGV
         PMGQ==
X-Gm-Message-State: AOJu0YxLTlJtXJNxSTZ5NttQZl4pWrfu/R3RLbX1rG3ruRTf2oU0PK8J
	NBj+Rx1Rpw/fePAx3kAE788NwJOT8gDzj0fz2IzZzFe57rs2VmjfJdyag9VVagxmstE=
X-Gm-Gg: AR+sD13qNEVLuundpW9UVNBK4wXSfwn1w5bHFklP3YYHvQauPujtJPnFg7KJhvTbeJe
	aOtvyMFY9o26ahXq8P9dpA820tdAmpL28P+C7cLWp2YN12CtVy9dhHNL/9orS/0WBdTmoHjHCu1
	rad1mFj+cJFABsIVGhi0jjmoTllMV3jbl2Jo7slMwfPOm3908cuAcN+2PQQCiUtXl8aeK5mCZwo
	o0FD8iyihfo/I1S1RZ5u5eLkf6mEH/o5vhRl/wXnR1+FSwsAZSIgh7TumqHX0yhguc8MS08roOj
	52TTef3PeGyRyjalKJsgUZkkjgQ0/gao8tYriRkJjEvy3sQuI3zZMc45KBFoDZabpCTo1XCaLF+
	0xoOc2pULyLo+/EzhtCfKXrdTjSbuFwJprgyBYjTY2h2G1cob83B2gTbqQBDce3jZWZLkd+T4NN
	l8HeIZ0YAdfKMlFYhluT0V7IwNSsHpcOwoXDurN8UBlnQx+CuOuwC7qJivQxY11mZJrtMy9unjc
	w==
X-Received: by 2002:a05:6000:41da:b0:47f:9557:8d77 with SMTP id ffacd0b85a97d-482b1e94d3emr3570625f8f.10.1787122402794;
        Tue, 18 Aug 2026 23:53:22 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14b802dsm3173435f8f.17.2026.08.18.23.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 23:53:22 -0700 (PDT)
Date: Wed, 19 Aug 2026 08:53:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm: add cond_resched() to free_pud_range()
Message-ID: <aoVS4VZ-dxfvW1s6@tiehlicka>
References: <20260818134934.92354-1-leon.hwang@linux.dev>
 <aoRnUxUlgf_kRlm8@tiehlicka>
 <2282ba9a-0c6a-4ce3-99ee-517231f515b6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2282ba9a-0c6a-4ce3-99ee-517231f515b6@linux.dev>
X-Rspam-User: 
X-Stat-Signature: na6frxrw33y6xu3czm67t4b54e5j4pdo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DFFAE180004
X-HE-Tag: 1787122404-247997
X-HE-Meta: U2FsdGVkX1/i7O8fbkxT+Qq8aLnfk5DOpYDyj7fIiaa7sBqhafwFwvKb7OwNlUSim2CyWGhWgMFwpHSzz5I90yXZRjArcc1CWXGO9japZC7ZfIiRHKpmr++PD74NIGzjMZTKTlBU6PNm615vUH2sjNAiye4GGogGp7Iy6Q3q6QMBzbBA9WF/rk7xq8kJcNijg3Zl2JJ00lqNsrqaHGJmnbeDFsMfHgCLOJOhyzKRI9yPwPirYlpwfTiNvWxzyXpmn3k/bHfoYGa+eUKscKpld2tnD1C94iUqoHRVmlv4y7lzLx9eOPxhLaXoDorn3zCueLhM0pvCiydUhabTy2QJuY43AMISCdgQ8/b6eg1m+qMMyySSneAwLCCqemjrg0XnE9F36mRthgVg17H1DKc8R+1Xbm6/BbVnTpff00N9XS+MHI2DPncjCGpn/7Cm3lFvAQc0Pxzaj0VhKCaazp3iIrikvz1azv09/B8zdT4v9ad+JAkL1Lr0T0+v562GR/9Li9HiUc1FbW1885X0rGZdB5jpEaw3EZXgBhtqI5Rn+0Po9p2SBsSB9SNw3SKfCZLcP9VmLuYPEVPt0NIkxWFCYswgXRlXe6ueHZtJzpqVXbPPMrWwxQWs9jjHV5cJTgcz8KhtLE3RdaWKAZN0CJdE5R4HjzUX7ow2zzvseTtKvd13ygxrtpjwfPnpWdfCdl+YtzsFUVwhYese01fObutDpOT31m9mMsu3BrGw8nB6nEme+vXGYcynAhTaugxVZUOZAP6BEORAjbRnlh1L/8mU3lYxoTrbnbC2yBnh3NmuYBMgerOWBZSQGW3DFWOW4L+sjDzW+mNb3OAWQ2IH3ZsqdMmkS4E5fy4nbdyIEr1iVru/ZJmSgwn/FPvjscP6VK+AYvRJN7Zu/nJJf5nL288E5gLFWGJFPDCgJnT31j1AzHHDMlSxI/vyBFAYocXhbU1gU6tvdiCt1NpyW+v3X7Q
 UscSnm8I
 +XgAFSWDVcUAccza9Nj5G1RGIT+fSCbNDcl8f9ZO3U3MANxqZbSNdLITVf2aFv/913HB7nnHsDja6mUhcTOSUT8kPyQWd7IJyGQ/lwyey3xmuAlxu1XdypjHI2wWuuv6WkE+cHJBTfisamVAEBl3STyTbLoo9HWVYc4JVraa/6Lo1r8gIxc3FOEQhBbkDdwA7gJfWFnZT0m2Up1gJrSK2ZVqHbd9vjMPYdz15tcND3r2Y7JqmV4ZE3cAnSnpqaIbwpM3Y6X41aA8tPaUmfUBJG5KrNESjnn/uL1qax3rMrfJw3RMbVBiAwfIQX+onSkaCXRl9PhoALgy/o7rnPUYHxdYZc+eypaH5rV1RCa+mYIWo6ZkOCngNg5jVciooesFBsrncLslUrX5D+wpdg2CbcAGcH4bZOo4xUIvgUrIijsKq7ApzXpsrti+m/jV/whUDrc8Kwv1IjnuLwSqAfntftY4/qCcxhGiJyQAiblwedD3XWXGskdldI28xwZ5PTsniqEWNg05CFLpk3Cy+slj8ZMt3DaZrJalNlbpG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 19-08-26 09:51:00, Leon Hwang wrote:
> On 18/8/26 22:08, Michal Hocko wrote:
> > On Tue 18-08-26 21:49:34, Leon Hwang wrote:
> >> Packet receive timeouts were seen in production. Tracing showed that an
> >> exiting process with a sparse 2.5 TiB mapping could remain in kernel
> >> context for over 20 ms without reaching a scheduling point while
> >> freeing PTE page-table pages. Hard IRQs could still be handled, but the
> >> per-CPU ksoftirqd thread and other runnable tasks could not run during
> >> that interval, delaying NET_RX softirq work queued to ksoftirqd.
> >>
> >> Like zap_pud_range(), add cond_resched() to free_pud_range() so
> >> ksoftirqd and other runnable tasks can run between PUD entries. Testing
> >> with PREEMPT_NONE showed that the maximum interval between scheduling
> >> points fell from over 20 ms to below 2 ms.
> > 
> > PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
> > removed. Is there any reason why you are not using full preemption when
> > requiring low latencies?
> 
> Seems that we have reached a consensus about adding cond_resched() [1].

I disagree. It makes zero sense to add more cond_resched calls unless
they are essentially necessary. In this case you are talking about
latency requirements while using non-preemptible kernel which is in
stark contradiction. So either you have other very good reasons or just
base on the current changelog
Nacked-by: Michal Hocko <mhocko@suse.com>

> 
> [1]
> https://lore.kernel.org/linux-mm/20260818162430.0a51522ac9bd671cce62650f@linux-foundation.org/
> 
> Thanks,
> Leon
> 
> > 
> >> Reported-by: Lance Yang <lance.yang@linux.dev>
> >> Tested-by: Lance Yang <lance.yang@linux.dev>
> >> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> >> ---
> >>  mm/memory.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index 4134ac607ee0..68c15449de07 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c
> >> @@ -231,7 +231,7 @@ static inline void free_pud_range(struct mmu_gather *tlb, p4d_t *p4d,
> >>  		if (pud_none_or_clear_bad(pud))
> >>  			continue;
> >>  		free_pmd_range(tlb, pud, addr, next, floor, ceiling);
> >> -	} while (pud++, addr = next, addr != end);
> >> +	} while (pud++, cond_resched(), addr = next, addr != end);
> >>  
> >>  	start &= P4D_MASK;
> >>  	if (start < floor)
> >> -- 
> >> 2.55.0
> > 

-- 
Michal Hocko
SUSE Labs

