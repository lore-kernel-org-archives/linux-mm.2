Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A377DC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2816B00AA; Thu,  9 Jul 2026 13:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273846B00AB; Thu,  9 Jul 2026 13:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163546B00AC; Thu,  9 Jul 2026 13:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B80046B00AA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E4CC1C0F60
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:40 +0000 (UTC)
X-FDA: 84969950520.02.33D1B20
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id EBE2E40003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HswCZwwS;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618778;
	b=RufdiWt512N8Rfzwf9nha9YBxFFR9litx0vB3upcA9/lMgPjFwT70ztb8ZBeOOBPd4pZ2+
	pMD2ucLQz/KJZM/qHa604/fCUxPfQCB51/TjsFmMRPWPaV6HsfK+rox9N6L8SA0Cn0QReZ
	Td97P8CavUM0kOzgwlh5HzPEyso438M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HswCZwwS;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9AnDRBr8KqFPgYAaaOIV/GMT4K0ldCBDDn+vjmduSg=;
	b=Qmr9H63BarqDcBgLY8CEl4NLahw9HoT89txROqEw2zYlQI4yKlSpmHFNjc556vlOqDE/XY
	H5S0QfeVnSR2+H9G8E3Qzd/1xAG1L7wM9D+hGx2B8rfGElHh+9UaN5drsn0UElu+VEuKsv
	Rk+6EPWZmCSYNOm5NfOb5BmDe6+77no=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c2cce930cso512621cf.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 10:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783618777; x=1784223577; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u9AnDRBr8KqFPgYAaaOIV/GMT4K0ldCBDDn+vjmduSg=;
        b=HswCZwwSx60MSrXFX4S7Fh/oCRh2DHdzB+3Zeh8+DR9JTilJ7DSEaNyyrmxoi8Bxkm
         vf+Z5B7AySqUOabcFnkSaDeSl5RutXqfZEI798QaccuWK/6b41EVS9Asst5oUwFjNLxT
         xqv18oNzZytF/0cNqyPVhr4FcUDVL+lR1khtOHn8GOvfhd3+aCSM5gkClYGeed8FMCwH
         wrEgU62bg8mbkW1kAxle4txQ8NT0Fw/+ZOVQk58DfHTK4JwYnLvrK1WFxdW1/bigHjeG
         rO7EG086RSEhD0SG6D2ZxFOleyKVniahoubvClzCV+0g/pB7KoLi+GOa3GMoC334oA51
         jJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783618777; x=1784223577;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u9AnDRBr8KqFPgYAaaOIV/GMT4K0ldCBDDn+vjmduSg=;
        b=XfWA4jv6btV43etToGburwd3xpYhZVIkVOckT8h7aBg8SwkwyE469LMYcpxZKYwqLB
         6UinFSo676qG4c9io3xQa0ohiWctYqS7RYs90ccuy5g5NMXgvl8smou06BOjVa2QnnPB
         Gn+OU3lwHRIpF10vM/nuY1aNFdjlns//5PLMdkMvWbCkPxVXGJ8fWFP86b+mj/Q5+hDf
         +aZW7EOrkvFBYoPN8N61+0JV9Wa0kDa6d4nvjg+W8jd17z49P3XN2014LK/pFoItMx91
         thx5a5KBDRJ+URNwQtgcxlSib4CUpXUncOx0y9LerkRGZXlZnlBlvdh0iqK9+qi9fSR5
         Dpsw==
X-Forwarded-Encrypted: i=1; AHgh+RqCz8hPfvwn+se5XGfMdgTJkEXxrsdOKNp3WpB/WBKuifPyIqpeo1UozE50m5RDEfQvsCbav7tFFQ==@kvack.org
X-Gm-Message-State: AOJu0YxZO9KwxMPen8a8RUXM9bz5VsfU56cYyBWuZhihnJPe1Kac2WOG
	yOSdNDFIjmTlvVrk6IBryt/81uvhCy9EhHpRyDIEq2kaj3OFboZLbXXFXMsSB3GT8D8=
X-Gm-Gg: AfdE7ckpxMU/Vnx022kSaHuYFfSpjeNyPSmQ7tB1wVAbZH2lcJ+GrzEdDPMno5ODLcC
	+n8bWRhCw2qSIATxbEjXmeewAD8guoeSkxQzty7g9wXG9NubBduCl0Et1Ak0I4uDaXdmWrHIWAm
	UT6yEmsrH3r3PsJndbWkgzy6BJrdup2sqCrLTSv3B41J4BOaz8grGj/WRkdg8S6CI9yrT2/M158
	MqwOsZzuvvGCkLWTXMCxIGlow0KfZeJ1+sPrqV8tcSPzu1dfymQXbiSz5u5LC58mPyXjFdskyjz
	xBrxH7qxzouG4M/xaKkhOvKwAGWrJXtJ0yzIFKtcIcWtG6IhSOZGr5OnNTeHUF2oXIt6wWm3Tsd
	657KgLvL6M5O0awo11cZCTidHkJ7fTK8Q/uxOoBAIXSwOoEFH2NWYW1RNatciBPZqD3jcbDIB2T
	RUbsEeWtyG+2ZQ1J+ah1VnSA==
X-Received: by 2002:ac8:5fcc:0:b0:517:98e3:d939 with SMTP id d75a77b69052e-51c8b48ec53mr93024431cf.49.1783618776845;
        Thu, 09 Jul 2026 10:39:36 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd56bf115sm22855186d6.12.2026.07.09.10.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:39:36 -0700 (PDT)
Date: Thu, 9 Jul 2026 13:39:32 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: compaction: support non-movable compaction for
 pageblock requests
Message-ID: <ak_c1HH72sJDmaSZ@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-3-hannes@cmpxchg.org>
 <e36dad58-d259-4533-be08-50d667d5144e@kernel.org>
 <akUyEgKMryy6TntY@cmpxchg.org>
 <c00f2d42-83f7-4417-aaf8-aed0bf1e28db@kernel.org>
 <akWCZLAMgJrmnZGN@cmpxchg.org>
 <61bc1ad0-f9e3-405a-ae32-b89bcdd2e1d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61bc1ad0-f9e3-405a-ae32-b89bcdd2e1d1@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBE2E40003
X-Stat-Signature: 6z7of3jjgpbf8ixt7d4x1sqzbg95uq8d
X-HE-Tag: 1783618777-115779
X-HE-Meta: U2FsdGVkX1/AUce/d/EZv2++RSlSHLmmLR1OGhGbcvh12d92qywM4pL01RVisTFMp01Dax4aXqGAbKlejHSBaDPtlw7mQ9lHC912ihfON8amM7C9Wi/H9eAiHg5VwNtDYRNWn4gC0+Qk+R2jjG0qetxATvdeYyvcjGyUK5IAA67bvMIjxmMQHWylZXdUZO/U0FqOiXqbpiOMx97jR7P/Z0ELBEh1ysolCSWQd2oHBvQh1Uy+F0ghERUrtRIsL5j7XrBrBop9TGz5VhX0XUpY7WHBTnRG9A0B8NzWusrYLM3S0uOitJsFBhpGElqFDSgpBzRA6iQhnC50FAfd/1i7CGGUvZHJ11kDt5OSOnuyymcECUjHjPPZob+V+ZSb6aQhiERdamnHvFwGtj1zwgrRRpwgHc1GeI/6R2PqTKKdDETRH/q2ksEh8tDBbLybhfdLqPHWu/uvcf2/Zf3ObNrh5PW76xgczFjmaX8UsbHiAplnrP2NW7nUxVoWau6qizYVMv8W8F46J47xRme/fPlwCBSZQHHxv//OUo7sukQhAaIW411wffXR8b+nOkdg8i7ZUtBi3Ut/u5nPpykaBF+zNx77HDaongqZyR+NAdoMknb1nrgr8mXZMGkLMNValizstJOb2wwxyVqKXgfQgAFHw5NF78Wkz5bAafIIBfjvJjQMN55fvO07AB+3iwTnaRSrKtd5MvkEXpJEaq6euWtEtBYGrsZsk238skZBpk3eQbReV0kj3hzb1uZjZQf0NsCT9kXQXLyurjIMuAghFUgiXZupBufwEc2espjgXDoPOJtaairTrGdFMCNN4/PGNk6uv000vMhj/fR40wJFIhgzeB+kWu3PSYszhO35UeGaVGktNTJPEJHfFpMeOk4vjcOtyG+rx9bjbbQStEjDDpb+eIeTvWwtscX3TFWN5MbztDCU4sVn9zq3KkN0um2sHny1TiYEKcBdBKaEAkaEEEb
 3RoqLfvB
 33+y6/+1bOmbP1lqqvhdYt2p8C4g5o3WrxFX5Em0P2D8Vqg8rWZq9nU2Q+hq1IhKTuxZnveDIX5e8PdME1wpextSRSKAVJJKf5vATjPwcxqv77NTk8POugliT8zqIFxgFs2gS9L/fKGbBpqwZonhJELUabTrTnSUaizd3e8yfUjF0yj9kWtkB/ULC4lT3VlSjByZaGct7TXnplcTbKisHXPj0c7wC0kztNeQbQrzea5+J2dPyd0Ti2lPnDWM0kIJmG5JywvsLy5AIIXfLaZxhGu+QFE8eGlcXOyuOJ6zN60NfzYe/2pTicC3eO3hAkwGzRrJOp9OPK4bxYgbvuSsVVDxkb4I64F77eH7f6FeU4UDxzPYDgjTKMykom0j2kRJiyAzkFTtdlVRfxHOlykc0hOzsTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 11:28:47AM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/1/26 23:11, Johannes Weiner wrote:
> > On Wed, Jul 01, 2026 at 08:14:05PM +0200, Vlastimil Babka (SUSE) wrote:
> >> 
> >> > This made the migratetype filtering about preventing block
> >> > pollution. The patch quotes reduced extfrag numbers.
> >> > 
> >> > So now we have a block pollution guard that we apply only if... the
> >> > scanner is latency sensitive? :) Is this actually desired behavior?
> >> 
> >> Yeah indeed I was wondering in this direction.
> >> 
> >> > Another way of looking at it would be this:
> >> > 
> >> > 	/*
> >> > 	 * Allocation fallbacks can spread migratable pages
> >> > 	 * into non-movable blocks.
> >> 
> >> But also vice versa, non-movable pages into movable blocks? (without
> >> defrag_mode?).
> > 
> > Uhm but those aren't compactable anymore then, right?
> 
> Yeah.
> 
> > There is a flipside, but it isn't quite symmetrical. Movable requests
> > are allowed to look for movables in unmovable blocks once they become
> > sync (high-effort, low-result). Non-movable requests are finally
> > allowed to empty movable blocks once they become sync; they *start*
> > with the high-effort, low-result mode to avoid block contamination but
> > are allowed to escalate when that doesn't produce results.
> 
> Hm, true!
> 
> I was also thinking, if defrag mode doesn't allow that escalation ever
> (IIRC?), should it be reflected here as well even with sync compaction?

Ok I made a clarification regarding defrag_mode in the other comment.

How about this?

diff --git a/mm/compaction.c b/mm/compaction.c
index 7df3a85d43af..a12a49eefe85 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1399,13 +1399,24 @@ static bool suitable_migration_source(struct compact_control *cc,
 	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
 		return false;
 
+	/*
+	 * Per default, scans are restricted to blocks compatible with
+	 * the request, to prevent cross-contamination. Once
+	 * compaction priority escalates to synchronous scans, though,
+	 * scan all blocks to try to make forward progress. For
+	 * movable request, this likely helps little: there shouldn't
+	 * be many migratable pages inside non-movable blocks besides
+	 * allocator fallbacks. For non-movable requests, this helps a
+	 * lot, as they can finally scan movable blocks.
+	 */
 	if (cc->mode != MIGRATE_ASYNC)
 		return true;
 
 	/*
 	 * Prevent small unmovable/reclaimable requests from polluting
-	 * movable blocks through fallbacks. Whole-block production is
-	 * exempt as the allocator claims and converts these.
+	 * movable blocks through fallbacks. Whole-block production
+	 * (directly requested, or defrag_mode) is exempt as the
+	 * allocator claims and converts these.
 	 */
 	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
 		return is_migrate_movable(block_mt);

