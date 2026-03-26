Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A9D109E534
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1133B6B0092; Wed, 25 Mar 2026 20:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D666B0093; Wed, 25 Mar 2026 20:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDD76B0095; Wed, 25 Mar 2026 20:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8E696B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:38:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F0DD1B9050
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:38:55 +0000 (UTC)
X-FDA: 84586354230.08.8D8D510
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D700B80014
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:38:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bh8YUanE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774485533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9un29tqdnu/MqZNffW74CS8OnpY09NQfQ4AsAwZUZ2E=;
	b=fdXlN7vgcymZYBR+fEpg8qVxiBVNyVj9ntugylN13XqUwKiRD7uL2C2jUT6XrTZPm92ch2
	FawK8EdtWh8oAeTrjgoXZ6S4fZVJHT5WKMx++xpNLZLvpSRGhsBwYABMMn80K8CoNrRuwj
	JTh/9MpDydWqwtjml6K4kJfYZXXIAy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774485533; a=rsa-sha256;
	cv=none;
	b=nHNkioxzWQLCJbj3Ud7/gjQm+IC0Njw/JeJ4LKGsTh76pcN6Fn0aq0jX8R0qj81GM00W0S
	kw9aNoU/jElbktyfUv9sH1xsagaFIbKIKnHY9SEp3PgnrqV4x2R41RN3v2/kwsyA8AHuNe
	PLa6tH61Gq7gW2bSRI6Rkfs42jqngDQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bh8YUanE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E2F960053;
	Thu, 26 Mar 2026 00:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3133C4CEF7;
	Thu, 26 Mar 2026 00:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774485532;
	bh=FFUCjB4kqdoVSzQIVahoi0U9tLwThKz0ltut+AgLlCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bh8YUanEvEHCeFdyPxQTDjAlpfJiy8k8klzB6eh1WQhmo0J6+5zqrcdTU3+O/z7O6
	 7TDzgDCXWE2xsdhjLPpVJLEfrb0y3nj4xoTuf/HMS5TfXpUbTQ8hqYqRvnbhyaOvvW
	 8fqyMtbWm5vpOPSSJyMgnbGSBsDKIWEsJx6KVWipLW2ciGnFAiX7+i0t5uI8eHOELV
	 9XrgwL0x2sbo16h5+c1rmYhk2Ar1hK36hKgm6b1OmRQQA++BhrcsNKT7SNpFVUahPp
	 rd+N+97jetE6mn5cY1uyqYFkKnSCDPVfSrcFFRDh31hvSS8yBF3GeGS2457HzIHX+l
	 xPr6YhIRr6T6A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: (sashiko review) [PATCH v2] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 17:38:44 -0700
Message-ID: <20260326003845.77426-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326001051.76219-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D700B80014
X-Stat-Signature: nkrxqjepuxx8kzx9745xmdg13hdaqh4u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774485533-901505
X-HE-Meta: U2FsdGVkX1+3WW7wPhk+OuOQaQgLdR2lRfaPGKZqVZD3Uob5r6rH/j7i3J6T7aZbMdjhBBk1nXWKSNJ/W7yhTSLy1xFQcCck2qDjHDyiosw9XOR5s3ZaiEL2xZvPq8VoD50+e+BhfzsnXXN63hrX+ZHYlrc5BOijP65XWZfc96EqUkLv8ZmnIRMDxDzS8iyiHLCCK+B8v8UlHGouMc9jbVIyf9FOGpZSdI/pq2wUuCwtlk51HYBa782yPSx4yeD6YBYYTzSy7mza7mo0eJbcAyxi9naHmNk5nQavB0LdoEtRceDBkegc7rQQhd/iffeAnrezL4srTzdVfnfwtvqV161rhDsKtp8fxo3F6gHMQ8DaJvIlViAQiKQRY6t7pLufbasNmFqdKfgo6hH2wjI8qTWtFuwQ7YDgyqtlp8WjuKO9iYhjxUyz8SXsOt0lcTc+Hn9+DmTXgcu4eTU36hifMDjxi+UrFzk9OgxPS9vZfJlpK3p//pDCi76CwAwOlPPvxS/Ofv86OGMO1V/lZe/mp5SFQmQQbKgSa4njza0Fp7VNVy+A3iljuD4n3cGge7wrguDXEF7LdnOWTDEpNBTg8K0uywpMEEyJd5IWs/OLYP6pqw9/t1yEGlE3a5LjZesa7RoqqWjSs+weJuDQ4Finfvs7+XklhYigwnKwXKLyHRWQ1EVNJ/YBCLW3NfYaOam0lsLVGhR/0EF0GpYb5/2e7qP7Uus43CF/1AOjuBnf2s6L88Q7M9pgIsgptIp709xqYNMWWX5bKKoQTsOruU4Zxogx8JkWIcmxnc8xaNka+3aD5svTgBtbtRr85phHv2AaXeRPEHApFOYh/mGfBWNiCSDM9SI/N6x0wHWqv52BgmZ+pAoNrKDNx03z8zzJBEOtytUfblV5cO0sdmNjqDskvMEMn14Q5Yv6EFqmzEui1RQvqIs8R7Ktk5S+8mfPwNzLeDqrfj6Ei5jvLXk/IPk
 +wgib+zw
 wmwvst9Q5tFnRuwPGeIBwoSdM8purfCFwJ1KWnvZS9CO2DlQPSnnx0axKtlrHs/ESU+LxMxa0D+ZKzA+QIsOLRpBueSDtx+urcwHGs/kS5Vli6XnuaWc57qccrgYuh/6CiZu+WYvCWcoVzubK2d6R57Tpb6Mh3LK6gupMvajFA2M8qRwhyxTpFNbijzw3pjHEf4kHOZ8CExi1JuwaGr8wTFPxPBPL+TA8hEWHh+d5M2XFM9Z0K25OVUEypYsGbX8IDmc839iCPbjzhTCAyKq8lChu+uzaBeMQhRfPCANiVlVYkE02Ue5wJIMD+TVYydxZnPnusAj5bRomxUslGgKvPwWp8Niw5VA1G+2L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 17:10:50 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260325155221.202700-1-objecting@objecting.org
> # start of sashiko.dev inline review
> commit 24e25058b8f508495d0b3db33bed16564df7fed4
> Author: Josh Law <objecting@objecting.org>
> Subject: mm/damon/core: validate goal nid before accessing node data
> 
> This patch adds bounds and node_state(N_MEMORY) checks before using
> goal->nid from userspace to prevent out-of-bounds access in NODE_DATA().
> 
> Cc: stable@vger.kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..ed45a7443abe 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2245,6 +2245,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
> >  	struct sysinfo i;
> >  	__kernel_ulong_t numerator;
> >  
> > +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> > +	    !node_state(goal->nid, N_MEMORY))
> > +		return 0;
> > +
> 
> When goal->nid is invalid or offline, this unconditionally returns 0.
> For the DAMOS_QUOTA_NODE_MEM_FREE_BP metric, wouldn't returning 0 imply
> 0% free memory?
> 
> Could this cause the DAMON feedback loop to interpret the goal as
> severely under-achieved and drastically increase the scheme's
> aggressiveness?
> 
> Should this fallback logic check the metric type and return 10000
> (100% free) for FREE_BP metrics to fail gracefully, mirroring the
> existing fallback logic used when a memory cgroup lookup fails?

I am also thinking similar to sashiko.  Could you please make the change?

> 
> >  	si_meminfo_node(&i, goal->nid);
> >  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> >  		numerator = i.totalram - i.freeram;
> >  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> >  		numerator = i.freeram;
> >  	return mult_frac(numerator, 10000, i.totalram);
> 
> While not introduced by this patch, since this function is being
> modified to handle node edge cases, is it possible for a node to have
> N_MEMORY set, but have 0 managed pages? For example, if all of its
> memory is reserved for hugetlb or unmanaged ZONE_DEVICE memory.

I'm not very sure if this is really possible.  Josh, do you know?

> 
> If so, si_meminfo_node() would set i.totalram to 0. Would the call
> to mult_frac() then cause a divide-by-zero panic when it evaluates
> x_ / d_ ?

If sashiko's theory is true, I think we should add a zero value check here?

> 
> > @@ -2261,6 +2265,10 @@ static unsigned long damos_get_node_memcg_used_bp(
> >  	unsigned long used_pages, numerator;
> >  	struct sysinfo i;
> >  
> > +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> > +	    !node_state(goal->nid, N_MEMORY))
> > +		return 0;
> > +
> 
> Similar to the function above, returning 0 unconditionally here for
> DAMOS_QUOTA_NODE_MEMCG_FREE_BP might artificially trigger maximum
> reclaim aggressiveness.

Similar to my above comment, I agree to sashiko.


Thanks,
SJ

[...]

