Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3920DC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D8E6B00A2; Tue, 22 Sep 2026 09:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407066B00A4; Tue, 22 Sep 2026 09:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF8E6B00A5; Tue, 22 Sep 2026 09:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0792F6B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:56:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98A061C2C55
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:56:19 +0000 (UTC)
X-FDA: 85241547678.19.16E40C4
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7151240006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:56:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=M1OpeUGO;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790085377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGu1NCAbAsmG5udT7RRBzA29qW1Tatxi7P64YgMVTYo=;
	b=0VCLRTaCLeqndvmsvyv785kYEB4jfZTBcD+546apD3FC+H0oXoOoPZ7WgEyO2eqlwguRom
	FE/varDCXgwRHCynGUQFqPv7RFABWBX/XJm4obv0j2aYtBdZWOpUZAFLrkZQbzl3ZtfNmg
	vE3esM0wwuIz6xT3il6s3VMiT1pDN5A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=M1OpeUGO;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790085377;
	b=2tMmCZCbJVrMV0caDAWM++1VuB/UZObFk95NXmk5h5WUQjQ+SmorzgOhhuRdLhCxtkX+q4
	kco7NyXntP5owLwJUGoT72dAnCuulxX64aZ0xNtWt73IqiLl3J0ObvdOP63UElr6a3WFN1
	Zzr8nXJCmodLd+ZG5bTXDgY5q4ZKkjU=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93a40a9a01aso86767485a.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790085376; x=1790690176; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hGu1NCAbAsmG5udT7RRBzA29qW1Tatxi7P64YgMVTYo=;
        b=M1OpeUGO+FTtZnRaDUErxoNfdUdvd4yXtdSMeiY8Womlqs2fcDztnZIdUQ+9uCdqAt
         1IIBm98jUkN0maPlxpqw93Ystf0ajJ70QSeDtxkcPSwSOiIk15E8jp59riUeh/Y5QwDI
         j8Gbb6GaDEqzEwMD/T7Fwp1C3fQTpbCPVBRMUC1oa9gCBz/WPYyFL5Gk6diTZisMLlPq
         ZJpv0ioEkYTpw8Y2oZKYrreskfeJCcdTSyK6uuB24nxTqEJSDyEgilVnf3BZeY3rWCFF
         CE4K+xhcgHkVoyAyD4ttMunkrrAcRUG9yybJzsiYN2jcw1oWbi+xd4DUQfj4UU0Z7rFR
         qmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085376; x=1790690176;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hGu1NCAbAsmG5udT7RRBzA29qW1Tatxi7P64YgMVTYo=;
        b=B+ItWfRL4GQFlbf1lub1KAeCSNq9fuVHN7j4RKVntHe9OK4rWc5RkVPFCvTWZeL3br
         fxbLZ0MniTzQI7YRPhYoynogvpl3BUgiN7F+bKxLOmNpUU4Yae2zEvOkzv4Tvfuv6Tuq
         mIZH7dBQfGcfOEMuwb78AOzJ6iQwDNNUduS+xiyWJIfZEqi4BbDlLSD9Kfr4GAQKPlF2
         4wFfw4Ew1Mc7U8RCBLn+9LCvEZWC9U21Sr0GzfVmhIT/sbDaWQS84hCoeIaf7hAT1asa
         kGS/F1BCV2M1KOGNsit4FTmySc720Ka6liJ4IxiuiPgw9DzrLoFX6DafRTdbrr1GuFMS
         LllA==
X-Forwarded-Encrypted: i=1; AKwUvBx4LLCEk80UfbcCJOMm8Ij/Y/jKNT3Yk9RZYnbZHVXJO1DjYYZPqirYPkHMNy+gsKEURFcRuCxqCQ==@kvack.org
X-Gm-Message-State: AFuF++mPMwgPQTKzeagp2+0DRq/e8OpNXcIw21Pp3BC1m0lOWc/VkgUM
	HWhs21syrzNQDL0dgM1e8eiElLGSGzvW5iXPVFVQ1lv0vCBnc59FxAMh09ke8oIhDLE=
X-Gm-Gg: AYBFou0DQjeLhUWZbLDpM2weyOIPQoNTtuAwFcbe39R3evnEcl25A4j7E8eMwDgHWns
	5QFvtLjNYQg+JcpUG/NHA44FgY4eGOSMMz0O6Twq4gFV3X5SFN41Rz5N22BLNnItFMdrhcXYA3X
	UAvb7o8c9qSZvKdgUiIzR6WVUGCfBlRPhuFhqCWkn0NkCpdg/BtPfwdlvKQwcu6/JsNXgpYURVX
	ZuTM+TbaZcx91jFweTAbJhC/k1jaLCsbGYADEN5HAc6OZm7xz+QaB+GDor+IfsBeaeWD9RBoF+I
	bloAmzhCOA7q0VTiFNx7B6u2IlJL0xRghYBV3cjN7UPV1zZijUFhoquwfvqAPEHZI9V+BaTZj6I
	0IoSSlDREWokqpQ1PeCrWuZxid+tHToujhtZLerFkNMv9onKd6OzL8wrgheesHZmkWqSZoUzm+3
	e2IbR2XrD5Z6LIs1yCUbssH1ZcPblbvoFe+dAxi3VeaSFzyxspPXQ17pwJUvY7FpA/du3y
X-Received: by 2002:a05:620a:444a:b0:939:c7dc:8712 with SMTP id af79cd13be357-93c17e489a1mr426789785a.15.1790085376405;
        Tue, 22 Sep 2026 06:56:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1d17afcfsm151272285a.20.2026.09.22.06.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 06:56:15 -0700 (PDT)
Date: Tue, 22 Sep 2026 09:56:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <arKI_AwXQxicc_iH@cmpxchg.org>
References: <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
 <arFBWvzXPYrKuIYi@cmpxchg.org>
 <arFFKGrpPwtTkoCi@casper.infradead.org>
 <arFUPOi6gadAvD3E@cmpxchg.org>
 <c4a6d3db-8b57-400d-a377-a7acbf45d3ba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4a6d3db-8b57-400d-a377-a7acbf45d3ba@kernel.org>
X-Stat-Signature: 1rfgkmber7zuatgogo6fy9kfaho74x1x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7151240006
X-HE-Tag: 1790085377-51
X-HE-Meta: U2FsdGVkX1/gC8bAhupHoiwJIZUTLc2vRaIq4g5CRSBXPD8iNoXcOkympgY3VCCP2k7mMc8EVIw0+cvD3qEI6tuY+pZlOP4K2Qhj0TYrl3uLgU35vf39ElUISHatVWbzCi0tKi7kIvlGTxBXQmCPygb1EwGldZx+UKDTdZwsoo6TpF7UiYZUzQ4yhoyA75Swdnb1Y+3xzMZLr6ubq8j6/oh8/9ghN0ZGAA2rfNS/XLzESKAopzkW/Ur3hlhMO0pSDi1y3CB7KGZfDHib2i4LPbJfCyksf7IpXOSZwI+Wph8QaPeuGjr2MiXk9yqZghEiTG/VuDF+ar1htcHhngPADy0gjLKq+bWHD4LO8dWXcMfU5gfsphpxKTxqIJVk2ZckLXCvlXyLqeQuOd40pE5XRPL0nfJhqCcdVJM8J8GIpY5eGH/d+SpPQUli/MGr3GkMCUv0CBlhDhvxryZnwHsz13ICheGgOmb+6IPC4Uq8b5IzY5slWK69/5jW7+qXz98OaAHMPsy62VacOrrmwPEEvcY1GOEScKMO1294Wi1hU1JIyz0DcbgTf9tVR7p+xyILXI4saA4aiIscqqPeyS12Vp5uaJDRdOwOx2icWGQTxevuHTGVn0LKQPHeReWZ7/O8FKRcG9RgjDUR7BEYYE1QjXtcywMxKWuE9TwNQp+adaoIUTCE1cDvKNY5uBga8nUz73WCJYx9m0lEfxSQbd/Alfgq+m0UoVGROv9ryOH6i8NuS0FJfzbHOEN4qXPD+5zCgAsWYvCfAcn5W+hBnzUrfbBKkAnl3HULImJwrYgy8KtEEf1DMucP24lkAhqKP4e1UGeYlCkltxiq5j10OPUsUnjsWM+I/Kk+HdWAbZ5IR/o/R61Ek+Z73NmFEa8THQxLT0+3V4tKZeb9U9ADBtUdGdVeePihkMXsMDCZeE3IQpgIvtgE4tRmOguh2Th1cG0gfBwZZJEtXHKSV1UvvUO
 qgmzEXfY
 4RjY/p15iZvPGylcV68/rESQnWdeNilXnlTbkSK0W+0QRU43klux9qWvEDdrgxbWhK1yKyRl/zBQfI8UaOe1e3rBv0koIPVkF1iRntRAhYrZ34VQDTyb/1OD8leOrDg3oTg0CzYKSQNQWml63CxsuRIRFeEXNFTzqQkcO6GK2CRYNE19feZO3mD33c8GL2lNBGtB9UTJMpZ4cfHEg72V+5txCeNljJ35eE7rGYwIXs2MBasRD/lRlGDoWvasiRueGqJiJ2vpEZr50vD6vBQwGc6WBXwLBKl3UJ+eXCeCdGsm3KlV2tWhJjMd6OkwijL+h4NUzR1Aa5D2uia4EfkK+MILFSaB18Y01NI6U9fNiarxF4SQuvQeL4PspICMNQQQSoY4lP+o7+f4nJxrxnhMi7nYmhnVGzqy5lShwXXVpLKaHAwejTOBu3Goxs60GcJTixfyrvSRjo3SJuhyF8+jw34f6S2FHE5N7XFGAtQo7SL7E4ZQyi08dfvCsLGQAV1I5/JeDD78iH74yiytAf9hTO3gkrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 01:52:41PM +0200, Vlastimil Babka (SUSE) wrote:
> 
> 
> On 9/21/26 5:58 PM, Johannes Weiner wrote:
> > On Mon, Sep 21, 2026 at 03:54:32PM +0100, Matthew Wilcox wrote:
> >> On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
> >>> +++ b/mm/page_alloc.c
> >>> @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
> >>>  			 * reserves as failing now is worse than failing a
> >>>  			 * high-order atomic allocation in the future.
> >>>  			 */
> >>> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> >>> +			if (!page &&
> >>> +			    ((alloc_flags & ALLOC_OOM) ||
> >>> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
> >>>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
> >>
> >> Would this be slightly neater?
> >>
> >> static inline bool may_access_reserves(unsigned int alloc_flags)
> >> {
> >> 	if (alloc_flags & ALLOC_OOM)
> >> 		return true;
> >> 	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
> >> 	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
> >> 		return true;
> >> 	return false;
> >> }
> 
> I think it should be named e.g. may_access_highatomic_reserves() as
> may_access_reserves() is rather generic and would seem to imply an
> ALLOC_RESERVES match (see 2/2).

Note that it doesn't actually check ALLOC_HIGHATOMIC itself. It's just
the hail-mary AFTER trying the primary migratetype. So the name still
doesn't look right, and rmqueue_buddy() reads kind of awkardly:

if (alloc_flags & ALLOC_HIGHATOMIC)
	page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
if (!page) {
	page = __rmqueue(..., migratetype, ...);

	/* Allow OOM and order-0 atomic */
	if (!page && may_access_highatomic_reserve())
		page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
}

It would have to be may_access_highatomic_reserve_as_last_resort() or
something?

Hm, this is a mess. Looking closer, I think there is more breakage,
name aside.

You suggest in 2/2 to use the same helper in unusable_free. But I
think that's broken. My 2/2 does not look like the full fix either:

The fundamental problem is including the highatomics reserves in the
watermark check for any allocations that first prefer a different
migratetype - "regular memory". Any time we do this, we allow those
allocations to draw down regular memory to 0 based on the presence of
the highatomic reserves. And when reclaim, swap etc. come along there
is nothing left for them. ALLOC_NO_WATERMARKS e.g. permits ignoring
the wmarks but doesn't grant access to highatomic *freelists*.

So I think there are two choices:

(1) Let *everything* with some sort of reserve access fall back to
highatomic, or

(2) Only allow ALLOC_HIGHATOMIC to include highatomic reserves in
their watermarks check. With limited opportunistic fallback to the
highatomics *freelists*, like the order-0 atomics above.

My intuition is that (1) might weaken the highatomic reserves to the
point of uselessness, and we should probably go with (2):

watermarks:
if (alloc_flags & ALLOC_HIGHATOMIC)
	unusable_free += zone->nr_free_highatomic

freelists:
if (alloc_flags & ALLOC_HIGHATOMIC)
	page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
if (!page) {
	page = __rmqueue(..., migratetype, ...);
	/* Opportunistic fallback for order-0 atomics */
	if (!page && opportunistic_highatomic_fallback())
		page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
}

> > I tend to be hesitant with single-use abstractions, but no objection
> > if people think this is better.
> 
> True but single-use ALLOC_MASK_ATOMIC is also not that great, and the
> usage makes the code hard to decipher. And see my reply to 2/2.

There is one small upside, which is that it pairs with the
ALLOC_HIGHATOMIC check that precedes it. The comment says "order-0
atomics" get a hail mary, but there is no order check. That order-0
comes out of the sequence of events here: we first check highatomic,
which is order > 0 && atomic. If that, and the native type, fail, we
do the hail mary for atomic, which must be by definition order-0.

If you abstract that privilege into a generic "can access highatomic
reserves" without an order check, it tempts refactors that cause bugs
like the above.

