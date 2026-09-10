Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BEC1C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D156B009B; Thu, 10 Sep 2026 08:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED8E6B009D; Thu, 10 Sep 2026 08:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD246B009E; Thu, 10 Sep 2026 08:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 015686B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:37:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72FE8A0523
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:37:01 +0000 (UTC)
X-FDA: 85197802242.25.EF5AC64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE79B20003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:36:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JrzN3r6/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043819;
	b=Jt7+u1mrJNxg3H/QpLUw7zUhEK3bRSbxzXH1zbbMh7Mt3VvPReMwVaX+WZ4jEpQZBo/Tls
	YSCt/XFHLZNNEvlaE7+JCevf46wTyoeQ1ntupyLXSC0ZayHis4rtaEV0HaJrZ8VJNLmh0n
	apYk9+gGoujMusISq7LVgXHPbCGmssI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JrzN3r6/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nW91mvS/Fi4pVir8EYL5mI4Ee2UIeScYvHoNKHO+nk=;
	b=UFudJTl8FPqvSnRZM5+km4qzjwyFfVOTYIVIGiG6rHsNkD/JSBXVy98VehtgSqBHlqR3pt
	OU/RT4xyLoyhNpPFbbNqmsoakkveDFG+uFuXMGDCV/W8t9YxdSkX11A/UY4+kMXcT0ARNE
	X93eaJs9f3InidFIjFoYVM+IfxZ7S0c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CDA2600CB;
	Thu, 10 Sep 2026 12:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A2D1F000FF;
	Thu, 10 Sep 2026 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789043818;
	bh=4nW91mvS/Fi4pVir8EYL5mI4Ee2UIeScYvHoNKHO+nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JrzN3r6/SuGu0wLLlhmnGwp16rjFX3IFKW8tA2Ub2oIen6X9Fy6XbcOCjDitcNsxn
	 iY8/jWDvobcGvrvU2CMKHqnY9JdNeVpWRGmoyUot83pgg6NweZjlXi5SbGmS1yIzvL
	 2gTK0mGB3Hp7CSBXiZdGRIYjs6AiY/VIYzmN4L32DoUVAuS9yGWuwRyYwS10MprPVi
	 bCgRrUUc6+F0UXYlCIxn4DFNNIIzG/mO8h3TXVAPMVR4SkEYQuchi+MLqmBfTAB8aT
	 tv7Y0SDPJD5uEVc2Uus3Wcj2t05n74G3tkFwg6omJ4WT5HjeoAfkBghnVnBCfvqWPn
	 ISd+jNGAOsEHg==
Date: Thu, 10 Sep 2026 13:36:56 +0100
From: Harry Yoo <harry@kernel.org>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/slub: use a track count for user metadata
 sizing
Message-ID: <aqKkJVWz67cxoGba@thinkstation>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
 <20260813161059.73855-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813161059.73855-1-pengpeng@iscas.ac.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE79B20003
X-Stat-Signature: 46hobrar8fyhciweohbprkhpe4oibybx
X-HE-Tag: 1789043819-244747
X-HE-Meta: U2FsdGVkX1+tiUfC0nZE2Q4pezqpkckLXh1N0J6F35rFoM+8LXISJ1SZ/MLMd2p/Knjfnfq0g4DTzZLZCAMjIWAaqY9Fo5TSTkO2v7bBnqstcoJeLT5Qnz1J9yqoWcLcfdmlYti18cPQ3XQci1/aF66pVj89KIR99lZQ90gUsNKn5LOr1fzgEzHA5yMwoEf9JGVAZ49ZsbddeHQqmsWIyaXy9vx1+Ap07E4gs0Jc5GJIG5wuAD0vpQ3qbtZhn3EFCx12l8t/kMYpOSNyhw8pfjcAdzUsmk54UP5GDMC2EfcfRMeBh49XgdD4hn2vyqnUxACUq8xkkDrsAhR1/RGKM5i0JaSCwebPNIATI/rAZ5aVltVVcWe0wugeAy4fP7XPRnNK9iLMkRnTeR87yvIp5sh7A/m9ZvrGD5ONclECWjIEfsEoEA2MUrmfmpLaRlNsUyp/gMKru2AwIFiK2jrmqkrGz6jw2xoAc+rEee+Khb+jc2f21YciRWVn3VbqPiHFb5c1xLn0hNgOpbEXe5QT3MoYZntxnKzjLc5t/t88axg7NRYvA6SOiqsH9xprBy1eVlg2A0Z6WIHc8sBkav4+2fUrwZOomrPgEBtMuM1QqMfLx+enJ0mv7VqPlIj8H1i/zGgc+LLz0MKwGJSiHZO6oGAvpmRyDbyy4ZNNX+d6Z+h7UEzQWXmg0G4rR2gM8KpIJWcp9HcE279muKIYbmgsxHDtYC1OQHkrCiHXdseKlN/HpifxdEWkLb7siP4YKzgrEtc2Pn46nlygF+tnwL4Jo4UGsB6W2y678cDEhF1XDrE75mdi899/nx6q+f6c6rNAEtVeOgjfID5RoWLV9gLjnMAlUKCNIqlqbDOvJQZPS0IE14sqDEfu3YHo60GNKaWxZCEWYHMntheF5LOsPd+Rxs0GB6pevravQlPgT/jGRw8RA/9N0uGLMxJOeBppPF3qrmQoorQRTCyvYqmNzoi
 i7ZvBuFP
 vnvQdr93VmEDLq+yl/nQOZP+pC+xiiyKcwlqKcb93PFII8WeEOp6uaZmQb3BwTMhJ3RxzY4wKJvEeym3vvBPd27vw5vqIkzm70qeHZANWJbVonlP1Ht7byVot8GwtyJBhOHNzdz45kiiXT1Ga3c/oGiwo/6ZITiKsjR0I+a9o9i3jOzleMTLZbsV8WDIllg0P/hivbKou/us7bsmdibaeKYkjvzGInrg3ES+kSS3I3a51gH2IQ1ITkLDqbVKfcp0J5vEAjqICI+pLYdRjKHrhrcqdJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:10:59AM +0800, Pengpeng Hou wrote:
> SLAB_STORE_USER metadata consists of allocation and free tracks, but the
> object-layout calculations repeat the literal count at each offset site.
> 
> Add TRACK_NR to the existing track-item enum and use it for metadata
> initialization, original-size placement, object-extension offsets, padding
> checks and cache sizing.  This is a behavior-preserving preparation for
> extending the tracked history.
> 
> Assisted-by: Codex:gpt-5
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

