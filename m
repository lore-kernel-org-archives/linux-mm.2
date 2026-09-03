Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4E8C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB0D6B0095; Thu,  3 Sep 2026 03:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C186B0096; Thu,  3 Sep 2026 03:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8820D6B0099; Thu,  3 Sep 2026 03:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F63D6B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:27:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02F3F1A0468
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:27:09 +0000 (UTC)
X-FDA: 85171619820.10.90E873E
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id EFA3C40006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:27:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OGxGMrak;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420428;
	b=s3ZBW/Jrk+nN1nz56EH/YkDMbi2ojVYCfLeRyeI8biZTzgQZKY+MNP7Thortk6dEYBGYGn
	Zwd9P1kCKrFYx5mu8UaIYpJD6X6E1VuPeM9WhliMH+Ui/XMkprxMhC+90khveaS936rICn
	bRQ3JcShxamOOJ5FYmyRG/0yBjSVwjE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvwfsT5XsU+XlCBye/Gynm+OK1RDDicBO8P4RwFQ9O4=;
	b=eO22m6K1JppeA4y3jc81HExtrKJmiDjtWd3IgrkTtBuhF9Uojp5oFuEp07Sb3D9nRj1qEY
	PfJci8Lr67H0M2nihzboF+36DdrazQY0CRZnH83SugeYUfLOBWsFkH9m+eEaquYxi7N9tR
	nQRps7PdFEAc6+ZY2s1NGsr8r9/gfXA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OGxGMrak;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso14480805e9.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 00:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788420426; x=1789025226; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OvwfsT5XsU+XlCBye/Gynm+OK1RDDicBO8P4RwFQ9O4=;
        b=OGxGMrakuxVpJEALt74lSCGTDzVd0K2h+34zO+9ZMLshM1d/zBxVov/E4vVvWcap+o
         3dwG8+a1bE6ETrW86YzfjThS7fsIs1Ki37hmbgTEL97+WGvFW86rk999rmqTsILCpkbm
         LP+5+URy9p+HLSAnloJh/j2LPXNYN5NC8thNjURQMyDyUaOhUZD7t4ZNOxoDVTB1d0FC
         w4Z/PkPqH89hslY572Lqpj3/CMvZcLBemOPAzvUTV/JKvPx1LO1txws6ZKVE87ZMfIfh
         UgkeKFCkBiCIHj654kW1N6vHfz63O1eXXbQ8pwR5lYjxNLOMqBVuE6F0VWePC0WAJ+MZ
         nQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788420426; x=1789025226;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OvwfsT5XsU+XlCBye/Gynm+OK1RDDicBO8P4RwFQ9O4=;
        b=nxoUZTD9e5e9i51qmoEgaXC8V1+IjV4aRwMczY/PMUChwuWUdis9TwPDblUpdPvH8z
         UqKIuTn3EOJVl7+h2VAPr90vv+LGPrMsrdZ3nJFG+KZOctyuhTBziyfkA8Tyca0DBI8X
         OEeXI+pHsJt0kZnjZVsW2GsGyOHOY54DtmRagwVwS1bbuYAI8S3hOImKuiLEbvbH00lr
         IWd3CnhHhlvMv7zimJ0gDrfJ1Elp7wO9LOptzDQ8xcruFa6LSAbQOcrvknVHA3R/IKEn
         P5iys7JNSg9nDB2N7N958e09jncYbwpcTHVv8+2GDmlf6SMFh2CeoU8l8N9uHZzA7I/U
         56Eg==
X-Forwarded-Encrypted: i=1; AKwUvBxiDKRYJmbTA/c8ZnvLT/7CE57NyrRdoR5jzYimG2ZIW9NZEU5ICNdUHTufJUam+fwmqRVcssvD9A==@kvack.org
X-Gm-Message-State: AFuF++mJZH6SQy//jR3xcZ8vcNlcaTyL3dTphFNvz3bppeO6dmEzfEjx
	LX/2Ia8sRQTl9OS9SVH2Es1oHRyQSbO7m4FUxGiCVIA4RZuh/YjT+g7lqCJ2tShpMSM=
X-Gm-Gg: AYBFou1fafsibTCefxODpwuf4zMe6lbmwIGDYrgsa3brZEJMkT9Tu0lIVSt943kNy25
	nR3BNILGXcsnNCSN0LDlofGgnVjKbIEB8UjLyUfE1AzOhoHZmuRpqeNYEIEipT4yVkwzJ6Zqncr
	bZdR9yZRkOLLPwyLckiGDgCP00wUBLPdSa7PaVy7PEk1++ibdiHUDA/4B/JUbffiLrKe2EzOOLi
	aj6G2pPER+BK0jza6R4ZG5B3hMFU+uum8wcsx6vGjSPNOxlP+8Kf8OqPbr8dePaUJ8dzqbVwoLL
	iD7VHlz1FJnPWNDLmLQArROfDXG18iMaU2MNbdWarCVhAWKtHvMPTGMuK/pWCd+3bSW3gAMPvO9
	DROHmXUhM+GgGhaLHzlLaV1UzbkUI1OjmoASJNnRpndugC0VSZa2fbj7Ecz1yFYpsV/bsR5S/9l
	6s564//Km0c1rEu4p7CTjhCz79TN5pf0JlT8FQQR60bpPiAepYCSawzoFbi1WvXIRBGfwGiG9YR
	q4YN7mWgYo7iQ==
X-Received: by 2002:a05:600c:46cc:b0:49c:cb6a:1687 with SMTP id 5b1f17b1804b1-49ce5812d7cmr176613335e9.4.1788420426281;
        Thu, 03 Sep 2026 00:27:06 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee7fec25sm53367115e9.13.2026.09.03.00.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 00:27:05 -0700 (PDT)
Date: Thu, 3 Sep 2026 09:27:04 +0200
From: Michal Hocko <mhocko@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>,
	akpm@linux-foundation.org, mgorman@techsingularity.net,
	david@redhat.com, vbabka@suse.cz, hannes@cmpxchg.org,
	quic_pkondeti@quicinc.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
Message-ID: <apkhSHr3by5Bf8jW@tiehlicka>
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aphSYFTd12oia8K2@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EFA3C40006
X-Stat-Signature: isbtejw734xxop9f491uopp575qr5ho9
X-HE-Tag: 1788420427-936091
X-HE-Meta: U2FsdGVkX18fXW+lXe07jTLMGm5dBuhWCLUn1wmvUlZopf6yqYEMspooLbhoG6Na/hNHo+hv0QIePYgOEFIMmwER/FjeOMd2nlUWjSGWagTPVfSBqRxVpjWu5brNOhGR431FME310t98s8uMA5pg6yo/EyJG38vet6YDv5eg6AYK8QFQQAPo6yjNecnCtY5tQTykRlv/RJzXG45zq8kcqs9Bfqux90pjy8GKiFlQe95m/HHHheE4u6Ck5YRfWZgCCKb9d9VFIm6WDqolNn6zJsU0VEI1riA8K20UdDc4yIlDrS5uhHmC5sKfhY4vaJgjsUYtDipBO0sZxRiojpgWXZrT52V5HZq8kN8NW3bFNCPbWGS5KBlHSO8tcWnlc6x4xjuOpcwYTo9ehQkl2mCfrUAC48N1WpanH7XCgM6mZW21D864JJWMgJBozLo8q7KkPY9ckJzW8ulk7whQLDV9VQRFpngYXB7r6V5m2dOp9j68qMAN95//Gq6Xw8J3eQhcUxpwf+FrH1FUg9p7M65z7h+HoI+pIuJai23D7d3kiFPgKlijk+OFVJ45HPu1gutsM34zwi8yehtjv18D8+HdwzSZTqDw0aPHA97F7cdVeqfM8c2ahGezQGfkvfd/O5RW0AXQY8HMkxjwUF+dvNbi9JA3SJl3TUdIxZ+tqLUenv6fzNwSwGLum56huEKaxsTgfW0K9PELk6jlu1g76A1gPCbDyJ3bFRJEng/iqm8wiBeZ536KSwk2Jx37OzTCam7C4wouHRdTYeEl62cBj3kQUzDLFMuQySA9Tp24uynEi6UK1ATPZpN/0ZrnCp369ZzBS317G2CDYG9J+LHwjVLEd21WQ0WzJ9SV53NbNdg6AMwaU0/9fQWH//KTvDEOp7AaG5quhrEx4HiJvZA5PfGO7hx+LqFwdfuhZK/IcR14zFM4KVOWbKKhwNRyJvzADtzueu2fxa+THJPL+G0/t+i
 9YAwwTyy
 Or+BiqqUG37JvpyPrUXl13YOPlpJLcjMPOZUTz9NkV/vN9p+Neb/8OeXkTAiNrfFrAXEx1fbofzYVhFhzV2/OiHsLeRajZXPpMS2Gt+VVqA6KEnHkL7v4LEsYSdtt9hfDya1KBH/zVMChFl/2znLivkJtiQmQpJsKrp9wGra0cNzPQj52XS7777iS24HjI405kzTPkCNpIsttTjPwnTv1dhHDSRjGRNgefD1iZQGA5hKu9CHxYohQpvd1eebsFqc47L8+2zYgj79tvYDgIuenAFKKtHQdZUabXb6UidQ6OJbGFdZoZYrHmFISynzvwreEbGEUtMOCWaDKKDMFNOvC7UPIwElZ585kQRxBCaoCYe8o8eQlc9HtbrF6hjpZ3XfZ9C05JAaWLA3ETTrO0mZ/3XFo5wn++h6eSvrsavQaq1bk4VD1xTvEAjVqOzP5Re3OJyw6/i5HSsEVb50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 02-09-26 16:49:48, Yosry Ahmed wrote:
> On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wrote:
> > pcp lists are drained from __alloc_pages_direct_reclaim(), only if some
> > progress is made in the attempt.
> > 
> > struct page *__alloc_pages_direct_reclaim() {
> >     .....
> >    *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> >    if (unlikely(!(*did_some_progress)))
> >       goto out;
> > retry:
> >     page = get_page_from_freelist();
> >     if (!page && !drained) {
> >         drain_all_pages(NULL);
> >         drained = true;
> >         goto retry;
> >     }
> > out:
> > }
> > 
> > After the above, allocation attempt can fallback to
> > should_reclaim_retry() to decide reclaim retries. If it too return
> > false, allocation request will simply fallback to oom kill path without
> > even attempting the draining of the pcp pages that might help the
> > allocation attempt to succeed.
> > 
> > VM system running with ~50MB of memory shown the below stats during OOM
> > kill:
> > Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> > reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> > 
> > Though in such system state OOM kill is imminent, but the current kill
> > could have been delayed if the pcp is drained as pcp + free is even
> > above the high watermark.
> > 
> > Fix this missing drain of pcp list in should_reclaim_retry() along with
> > unreserving the high atomic page blocks, like it is done in
> > __alloc_pages_direct_reclaim().
> > 
> > Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> 
> [Sorry for thread necromancy]
> 
> Hi Charan,
> 
> Are you planning to respin this patch?
> 
> I know that Michal was questioning the need for it. While doing some
> stress testing I came across a couple of OOM kills that had significant
> amount of memory in pcplists. Something that would have been prevented
> by this patch.

Could you share some numbers to see the scale of the problem?
-- 
Michal Hocko
SUSE Labs

