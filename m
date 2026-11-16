Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09288606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbXFqPbU
Received: by kanga.kvack.org (Postfix)
	id 295A56B05CD; Mon, 16 Nov 2026 06:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245346B05D5; Mon, 16 Nov 2026 06:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134E96B05D8; Mon, 16 Nov 2026 06:32:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E35AE6B05CD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:32:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5607612087E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:32:35 +0000 (UTC)
X-FDA: 85440769470.09.8E5353C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 32E4E16000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:32:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbXFqPbU;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828753;
	b=Xkf/zfFBPVFqF57eD84zPM0xPJmYodupsWSdyINawBC7xgIw7BOhU0eh9r2uk89ViS3xN0
	jl7MSNucdZdh9CFPJDqe4lfldDcDlwG2tsKRULHfznsBspMqQFgA2tLK7NUQWYj6hE+Vvz
	5Hg2y6KjRa/74vssVgoxe2tpoKMldvM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbXFqPbU;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeT6kKORp+5IdL68nhIk7h7EYxlyRMPSL0xvT3ad40w=;
	b=eqMe4qhUbitKor1kC/qOnH26xTjmX8KtYWX4CLBcJMsViwzW6g8SAIZsuEkzv0DY49YtbN
	Ih0Eq8xil8sW9O88clrI7tSe6mglHBn707rCYoJ1mmjZH4idd45y2zQC4gAC7DpHQse331
	A6yr37BqYvjhZfZ06a/DgnWhzxtlNPs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76CE343972;
	Mon, 16 Nov 2026 11:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4971F000C6;
	Mon, 16 Nov 2026 11:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828752;
	bh=EeT6kKORp+5IdL68nhIk7h7EYxlyRMPSL0xvT3ad40w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nbXFqPbUFgikhQltv9KVm7AYfntXSmMhyP2ptNZ7XZcaUhJWXCq+tBZLpVem/2UJ1
	 Ps98KoKbT6QiMMS4vs/E6KbLop3BvT9sLOwYgLE6LKrjNh794YIBk0rrEhNibL604r
	 TchceIgB0MB0gDC/s4sEaBlSojaX9RnlEklYyVk5tq6jdU3rjMKjyd+XiHOqO8e31Y
	 xuT/VadTJYfLbgQdhO1HlQ1dBpFUPKEjlqeGA73No5yd01PlWCFScX/UMC6Yy0ScWP
	 Oye5nqVSMBt+aPYc6guaDfuqsCl/IPwnmLMJ7ZPWnX9gGH7Z/Va8t+AcocHpaBDV2T
	 W4W7nWGxuVdUA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id DB699198003A;
	Mon, 16 Nov 2026 06:32:27 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 16 Nov 2026 06:32:30 -0500
X-ME-Sender: <xms:y-n6asylUYQScB8se0cYa3FE6o5crBxcd-JzaBnNcyWX6gyVI66Tng>
    <xme:y-n6ah97JQWHxzDFHgnFdzb7Bt4Ge4G6_TYc-WBONKM7Dl6m7L9584ZQobVUhMPx_
    H0yo1iU9tgqU6qY_3G-HJ0xWUaSZN5aBnUR6PgSBAK0jAcYDKsO_P3M>
X-ME-Received: <xmr:y-n6ahz3JT2PjepyCEOl-Ucmuj3gyH6hJbT7WjJknPmawVxpRCcBfE4mwXw>
X-ME-Proxy-Cause: dmFkZTFXHyoiJGy6ZheZQtG51M2OBrJvqTYDsP4f8xxpys1dt6NQaTyvvweOFtaEPik+vQ
    yr6QXvtB0HIxI8n7fKDLJ5RqRzNhxnYwuzh50Veq5YzqTxIMGFfTg4wL65iADIy5+4Ta4+
    DgS4IEG70qfReP94PChc72OASrq0cCdmmY7HSQ5K1Yb2pepzb/nuNjO/jtrWTZNNv1JgYs
    5XF9G+BJdbdG54i7naOBq2tCTyaeCgfoiARkjD09pR24EsfVX4MMlTdJiSxdUEoPaZ+ekE
    cbsS+wBXRRz0NCLLwDKp1nBESbFkVfQbFgysIXEWVZy6FOndR6Utv+79EZN8a65+cvmXSK
    ul7Zenz6zPBX9yFoIiEhzOlNqTBfqMomqEwbX8+IUkTplOirjz2bdnXlSqjPbeqPtxCqE0
    wX8/t5VrNrb33g56kerRgG0GKQKrhBUNRbrWv8BhOnZIi21PKoPSlQ3YsP9ZhNIkpv9WsB
    9EQSjiQTIlNnMSkgQc9Q2C0CrlOmO0hDU+9S6g8TiJpZvsu/xGbJb+7iCE7r/YmsiLQKIW
    IeL75mQKMbPuq0Hs0eas7lo/ZPZimvE0cGET3Z1n1Zt7tqkHxGJXwyMzIxQhT91rsQAQTo
    fmcNQHUlJHwq62FdoJiwbJoy7MJHzE3EaVg7wiEjMDlXXNyelmnb+WR+DXXw
X-ME-Proxy: <xmx:y-n6aqVUbJTX42ukVJWrl__eKiHs6DnypN7yPXptDUOk8RQo3PNJTQ>
    <xmx:y-n6akaltKjsO5miz18UsGU2PK2iuJBuJUaFsBsorVG3BoF_8RozwA>
    <xmx:y-n6avTB0VJckj_hauQx4Ypj9wcGNfJwP5fIutoOFOphWTUfkIZ_9g>
    <xmx:y-n6asTTWHNor-VGA7cBy0Gnl2apYej2fgSZmSrnQGglA1T6itjG0w>
    <xmx:y-n6aq35dAN-tbw1UCtITSkQ6ceyuz_jMbkXJvk-yjOUu27Z3r_dmZht>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 06:32:26 -0500 (EST)
Date: Mon, 16 Nov 2026 11:32:25 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Mel Gorman <mgorman@techsingularity.net>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/compaction: sample empty pageblocks again from a
 random offset
Message-ID: <avroysmflhyRZ42p@shutemov.name>
References: <20261104101747.2485913-1-kas@kernel.org>
 <28a340e0-76f5-416f-a74e-f74f4a2c2d36@arm.com>
 <d92f9b62-5d2a-44af-908a-ef80fc8e1766@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d92f9b62-5d2a-44af-908a-ef80fc8e1766@kernel.org>
X-Stat-Signature: s35nt6if4he1mn7uzsf5tbbeze876bou
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32E4E16000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794828753-776820
X-HE-Meta: U2FsdGVkX18bI1iBid82zgm208DzTAMUELOxzlD+27Mc6WajRH+1ofcFfFSuLJXfONluSPGgk0RUGr2VwL5HtTuLlIYM47sXn+nJT8f6S0Mhqq860G7geN7GUWinCVIp4kWDoRYjbax6Wf9yymSjIJsapGKXLO2T8LH5RnYzEMw0FGy34uM//ZTHwGUfvTui0ll4kt6l2VQ8V1dj0x3V3w18bQuOXmPXlE764KqF5HDRfXLDNFQpL/ZsBw5U0Uy02ktQq4tS4kcKQtKrtRrfYavQSLXDC6pOhNniJEjstn5g8anle1EqvZ6RvZAWE9vXKDCI4OBC67eptv+4rVA8GijMnZB43ePtzjYRaYBrg9cdqNVgOlJ6oQjGNAtpz3OF8on+LmNnriID4cgF3p74rbB3woTbBR9A+6hX+1wEFkroubjkRIUgbDfh+iVW8fVWHyP/jOraverJ7rJi4PcuqoqYPYqhfV2AL299T6vS5tBqNw2Reslt2Od5rCV5bni0AtLCsZmtJBW8R+hXu2/03kKmBWpTrsRGPZw40AHzwzJaxW2uw00CJG+yAkw2vu1UQAjOUpEgNrAs500pO0s6cKb+QfMfxuKIWxf31qShIbdWk6f10YJj8phLcSr8WmVlsy8iR3FzCohDYcDzIa3HC8NJf5Q7WCE7El3KpAJ7jLnaeIsbBWeyC7hemj1dbk6CbkKfMfP5n2oDyu/TY2P7Fq0QSi0+6hjaT9z3WPgf+XDtpFF4feYsioZ8V5qPVH11HiqajZMy7V9BXC4/qwwPfKwZoPKSeFJAOlKqB/xAGMD5PhPdeWZmsRlo4LhUD47bP3E32uUBH7E36zWM3jyhX77364EsJaas55EZCap4kx1w6MGWu2p+A/dgBpja/KEJxjGriQNOJAFoXTHA3NiZuC2FPhdYb4ENCTDpUMvQmnnXrVKeJqbUaKeR5t7Eitzf/lXUMeP1LJvqxzDTUms
 LMfUqK06
 gjN1tbcQus9loVSoTcHTf0/rmtxdIJTUERFl+iEwZWexycfqxtQZgFR8r7V3asdjJqNNxQCxnJs0aToPJYcoWI09x9FhiMIgvBzSteaW84O6vJCA+X7QZrXzCPOz7sGMYQemdzUpa7lQTBQMUxapi1avTPkNxPadpe+AQ1x+ahHhvo2TqQl84XEj4LEsDyy0t14iIchKkfWO200GwnY3xv4LtV3cJSAO9n0QBiUOFoWMJTnJGFADK1Q1FpQSgns24pZGnl2ZGYr92Xk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 09:38:29AM +0100, Vlastimil Babka (SUSE) wrote:
> > IOW I think the probability this patch is going to have a downside is
> > more than that of upside.
> 
> Agreed. This seems to all be based on a hypothetical scenario, only
> constructed artificially to demonstrate it. A real-life motivation is needed.

Fair enough, let's drop it.

It is not entirely made up, though.

I stepped on it while testing another series. A fragmentation stress
test gave bimodal results: no direct reclaim in most runs and hundreds
to thousands of allocstalls in others.

It was confusing and looked like a regression in that series.

It took a bisection to find that the only thing that mattered was where
the free pages fell relative to the stride grid. The test in the
changelog was built after that, to show it on purpose.

The workload is very artificial, but the fix looked simple enough to
post.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

