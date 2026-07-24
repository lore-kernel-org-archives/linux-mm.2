Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C07B8C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 05:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECFE6B007B; Fri, 24 Jul 2026 01:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5446B0088; Fri, 24 Jul 2026 01:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB1F6B008A; Fri, 24 Jul 2026 01:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDC16B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:58:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD5EE14025A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:58:36 +0000 (UTC)
X-FDA: 85022615832.18.B8F6BA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D15931C000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:58:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=gjsUKBMm;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784872715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQm1ddMox3vEUAJvm6IXwOnF8UxrgOIpTNbU2CB4GxI=;
	b=Uoy3p38wkEkTCaKBQMPyyKuaaeWrPxryCSwBD/rAXMaKt72O/i1cVyHhnkl0TKvzn5+uEy
	ar1DV8i786ys7NHvSmuG7GNpayE2/Bn+O3UbfNvxVfK5hAFP+lq5HhoK87NvmfNX/Zeg3d
	ovCzmD4CmxWWckPAEMXwu8pW8DCp5MM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=gjsUKBMm;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784872715;
	b=dVUpv0FeR2FOwfHj9hT7QDux2kUzwSml345MAKr6yFaPvOG70t2q6kqFWJeOg8Y2YXykTe
	03F9gKUP2GOf+4i78T1cIBLFczKVGHD+b9umFYDYttNNLGksPyx2CMhRUhbDmCy06gGw1w
	ZaEAQ49i2lS0aJYbXb+PQtiY41oy5Ao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19D1060A5E;
	Fri, 24 Jul 2026 05:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499B51F000E9;
	Fri, 24 Jul 2026 05:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784872713;
	bh=pQm1ddMox3vEUAJvm6IXwOnF8UxrgOIpTNbU2CB4GxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gjsUKBMmXyhpiY95M8Kz5bEMNbqsjbYtAZ2aGfKzJP1iQ5IwpQ0Z5qRYHCub1GNiq
	 VOQDb/2uAVhQWj/EXaFb0DPjeSDQhOdQHjte2b1TtTTC3bfnJyvzQpgYMhT0byHuir
	 oVI6cdnBF4VK7tE5Y0E161TXXdQl+SCqUBfxdIMI=
Date: Fri, 24 Jul 2026 07:58:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-ID: <2026072426-exodus-deck-e14a@gregkh>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
 <20260722162207.31a2c491ffaf36d1e8948c14@linux-foundation.org>
 <67e1219e-9d47-4a30-a8dd-fdcf03229f58@kernel.org>
 <amIgT-l7PExKVJlW@cmpxchg.org>
 <00bb7fd0-998b-49f0-9941-cc4d796a8751@kernel.org>
 <20260723170249.98d83bd68698fff2629391c4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723170249.98d83bd68698fff2629391c4@linux-foundation.org>
X-Rspamd-Queue-Id: D15931C000B
X-Rspam-User: 
X-Stat-Signature: 1pqadsfyqf6ki9gf6rsyb366k7mggsqf
X-Rspamd-Server: rspam04
X-HE-Tag: 1784872714-628168
X-HE-Meta: U2FsdGVkX1+48oktPfxCTbVg6C2MSatIBlgOVXBM0OFyCFxPWGr9xr2UhHLhLnhIBr7g3p48NTuWb6JSKzMbjRyySOIXsT6Vwz1EO2Jywcz34H9oL8OYb9lS/Yqf4NytJC09hBKNLQm5om8lz+Dcfxixzx7/vS1tBgxIL4EP7myEBMjG8gJhQ2zZySdPeVNpyTp5VcJmFHlVXweHvOAT+aZoiinyVgi+M8wQ447yJuIA3y9IhLki6Hm+WAs4/yD4ofnLEQwe4C6LSWbHISXdXVtrVW6Q4DIKjeuRMUZ2M+nOo6bbGGXqz7kxuD0+564TjN/yD5YTbu5Qt9FJyGJ5zKrRlfFoYQeLQWoeNmYtyRPUziPC0c7aZJZieL8NCdS54pTDDzXyTsQkN6zmJAevXBEXvuMD0/FhRaZt1+glySPMg1aOWahnKwapfOMB8YvjgM8R7H9FHYE7MH4euiLIH6kP130qOoeDo9m0kkpzfF+yJTLmBUc165h4oLFwyHT2OG1oCTckNYS7M+7pQaAlOrOSf/u6aH9vVWJbUyEIgmogV2xqS8amJ2duYgBrw5iBt28z4yaONScu5jHBcIaIgRbkuSVHWup7UNmE+tZsVE31cs39ARu2SqK5+RKSxCf4kpptd5XlLMiCNHTj95/yCNJnAK9rmQSqDEqtGTG4pdbPitQMwiISP9evCU5gI/InbCGnaGN1bQcLQR3Vbl7S85RX1CSS2IBn/+BxyOYHlEErIFli2Bx56AwFA2zXu/7Ap+Er7MKhZE4vJhMoKQ1aoTmNRVxlPYRK5r17q9IBBwHq5wCackVJR2GaTaao/ewYC5509tuRg9BrWgK9YZ4LJ8McpN1uRFE/8jVBAnLJFBRxWzzAGy+0XZnI9ZB1daafCCBdVuSKMDAY4KRvjEb4FBTcpMZx5a9gM23AYVOViKnbriF1HtOa67z5X6fW830nlCq4ZyZ/MPoYwld5tvX
 e8Wnr4sn
 l4/f/kQoT5bK5B56SL2USNyMbvbv2AkXq7w+ux7vyGWwg4TC3fODATakg2qzlS5baoiXlOlZQTMNIB7nBlSgC9H2XiCJQ8ObxGsVbd8FrPMPV4YMCJMbrAMY3Onc1aZ07pHK5mLxZ1NqUbyO+QzNt+Xp+P+hBebcEbkOy382oa/6VJOmRqG5KPopvQnnnIT+Zeposb5ti+LJ/ZfTr1oV9O310EGnWPk5wflA+JJzENQsswyhPRAMIZ4P8YGWBoBj8LgfaphAKfXAvWE1BtLKbmwqx/L+c2OEA2mcmPplMGV8ZalO+ilbOIKaCPdxmvTnJ/Zcvlj0e0PivKoUj+HCbO60qj4S+SjqPOcZmrRomcT7QG37yOgvw3CbEeWMhyhvcZyrPhu7kCkT2ErM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 05:02:49PM -0700, Andrew Morton wrote:
> On Thu, 23 Jul 2026 16:17:51 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
> > > 2/4 actually came after 4/4 during development. Without it, compaction
> > > cannot make sufficient forward progress on the promoted non-movable
> > > requests. So it is a hard functional requirement.
> > 
> > So that's the tricky part then. If it's a hard functional requirement for
> > 4/4 and yet leaving it out results in no conflicts when applying 3/4 and 4/4
> > (as it indeed seems so, based on my local test), then it's quite possible
> > stable folks will figure out themselves they need 3/4 as a stable-dep-off:
> > 4/4 but won't backport 2/4, unless you act quickly enough on their mails.
> > 
> > > Whether it deserves an independent Fixes: depends on how many
> > > GFP_KERNEL pageblock_order requests we have :-) I'm guessing not many.
> > 
> > I don't know how else to indicate it though. It's kind of a co-fix with 4/4?
> > 
> > >> > (An alternative would be to put cc:stable on all four patches.  That's
> > >> > a bit abusive but we do it rarely).
> > >> 
> > >> I don't think it's necessary, the stable team are quite capable of figuring
> > >> out the deps and backporting them with a Stable-dep-off: tag. IIRC the
> > >> "fake" tagging is discouraged? Maybe they can clarify.
> > > 
> > > Yes, I *think* it should work with tagging just 4/4.
> > > 
> > > It won't apply cleanly or build without 3/4. So I'd assume if that
> > > dependency is lost, the automated backport will bounce and I can send
> > > a backport series by hand.
> > 
> > The way I see if often happen is that Greg sends a mail that it bounced and
> > soon after Sasha replies with fixed up version/series. Which could very
> > easily be 3/4 + 4/4 without 2/4.
> 
> My brain hurts.  I'll include
> 
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> Cc: <stable@vger.kernel.org>
> 
> in all four patches.

Thank you!  Don't make us "figure it out" as that way lies struggles and
time delays and the huge chance I get it wrong.  Tagging them all
ensures none of this happens and it all "just works".

thanks,

greg k-h

