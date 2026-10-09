Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAE1CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 12:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913F86B009D; Fri,  9 Oct 2026 08:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2C56B00A0; Fri,  9 Oct 2026 08:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78BCA6B00A1; Fri,  9 Oct 2026 08:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5A06B009D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:50:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF60E160322
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:50:10 +0000 (UTC)
X-FDA: 85303070580.13.A4FF307
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A85C40009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:50:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A wftwgV";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=D+30l+Gc;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791550208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwuLlWvseYD+74dMnCLktedh4fOzXytMC82OiOvL5ak=;
	b=OrW2lO3Lmmh4VhWPnCuPpQD4lJoPIaY4g6Qtl2shGw2fyUwhB2QyODjbgHhjTHiYl6RCVu
	NCpJtj05SpvLpxKRbdJNpb8a1KyPhH2IRB+7yV6Sheo5jkXWU0gqKjU8IfywovYNIwoFMZ
	KXeOpzHDFdQQTFjww418kzar2zbY1YA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791550208;
	b=vdb5Z5l5FUtLWA8mBfTariarIs/wfo+g2XyXDWQf/K+ZHRErUK4bGy7fk/RDRdVveXmuHW
	L5c1dWIOCpRN5dDVU9ze5JJIQbVdIIUncxZpE7O8p8JlmIk3Pjb61+i0+EaX+wZ52T+o9O
	KNc92pXXrltnUF3zwCJ2U48RF0Ud1LM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A wftwgV";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=D+30l+Gc;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0435C1400122
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:50:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 09 Oct 2026 08:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791550207; x=
	1791636607; bh=kwuLlWvseYD+74dMnCLktedh4fOzXytMC82OiOvL5ak=; b=A
	wftwgVGELghKG4AwtQpy25D1oTqdyYSv1F0iE+dqzNYbQyl8drsVqpsja9Im+iVr
	AlAGCfNLzubPKjjjirM+khSbXmAMkgYIMb/dzJHKWucl31BPU/nsDn5KPYA4sm3G
	5bBPb7qiEjKEgtAnEW0UjGL4EVmBxkXsc/xu8gBAVfSorI7FXGr/ZwDNQWCroUnF
	ZIAdcRy0utvee4Wr6ScPnWqd+/+KoIxCMwePu/J7/inVadWDuK7WZWXHn5q5Kuh0
	hZS3lmaVONsdtkoyZx0nu10kqz0gziTTlw/IBpGipzvfcN8BjiigjeKPf9Hf2igB
	yp+cxfYzic08UK2uVQDqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791550207; x=1791636607; bh=kwuLlWvseYD+74dMnCLktedh4fOzXytMC82
	OiOvL5ak=; b=D+30l+Gce/d3Zh4f+q8ngVvAcVDQhSfZgGub0mYOK7g3qJZXjpu
	V9MFsEObI4hcjX13BGYAQzUBVNtBrOTiq1vt5QhrC21YV1Z4tFxqxYURJ7QJphBA
	MRPCJLPoGvR4KXM+dNr/YyiEbWNWx7vjMxMiiDPU9cMpPQcaW/XM91AH9aime9RZ
	PJzUZwTM9Azf0JAJXiPQsJPuZ6qV+KZGops9PKV0FNnVefAoXl1VJgr2YG8PJhDC
	vLrFLohrezJ3+1GoSF1ExImvwoSjwVf/XsRyodsNZ+TXW3//uj4uKMlL8u5ZrJ6P
	YPCH9HbHf5XZ7vEv5UgUvPumZFUr+i7Y4vQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791550207; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:cloBZq29Kk1iSRiULfU4+xtAukN/c0Ix/HTo5XZY8yt5s5N
	6FLZjg2hYhFNkA7Q/SzFmP40egBt9LgD3/vF8nF6wZxJKEVtpTOZ97s94EKkTppd
	LubEYErFdPXndTEx0i0uVtqQO57gypPtjSMZEfekCWfw6BIJEVyr96FHho1M7wfQ
	yMznOHyGUvk2oBjp/vNHIHu+JQTOJfqHkQr9v/g9eI0w3XPMjSrZs5EWygtsGpiZ
	S7kqVlQVQtMAPwx5ah8GgZp0oqib5asxJ1Co6vLMhpk0W/uJWPX/raqgsv866Wh2
	jBjmMUd9znKmPdFV/xOqLwk61SVbLQUh3n9TxhQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:dPwl2ptZ8KQ3KssmzCbccTofY//b/3Xh8ddybmaiLhI=:Vm/Hck2b9bM9igyRdhUPr6w4WmDAa6R5TgT2R8RCzOk=;
X-ME-Sender: <xms:_-LIaguEsuIEEDDbRjcyfdA_r5MOKD-R9ZuR5Ru7F_nrZcX07q3nsg>
    <xme:_-LIalMOTtzHnsFuJNTXMrLSt3nZuHG6xA8-v4ZCFon_i-fkYpUu7RNBhvhlFFvWi
    WOlB_4C9c-ruQbhJHELgDnziTE9WxQOsw2YlpgrG4206d8EVQIOG7g>
X-ME-Received: <xmr:_-LIaqXREAD42QT4nykwIDeMg-hS8YPOZOamHPFYr2Rn5hYIUH5jTKrfFuc>
X-ME-Proxy-Cause: dmFkZTERXjv5sRhphf2UpmNikN5/RjMZ9jdv2AoBQ3JcwuQkL+3XVeY6isvJ/I/LHHxVfn
    MKwVsK/+JLYhLu9ZrsWE8W0rCySsp2zlzECQxKGDnlMSG71Ip3pNKIKK2mocz6/wEaNrkF
    7TA6zmnT5XM08JHDewuy71GqykKz0AmDsneejn77fVdgbVpFO2viBVmYbl6T020Qj7ZyTs
    jtSROHjwQMvePCMcSRku+ZeCkxc2CraVCmn0F5I/pbfzaxI2d1NPkMZFfe4v45ILMJqBcK
    THyiEYkQbzTWWuGKgnbx2D9+yDexwl4Y8t54Nm+i0K06Hrd2I9AYEUu+LtwsAn8iy8tYQu
    /RER2RoYALbg+AEeDMuIcA7xo9Bw9oVDNBUt8GBTNQKHhiYyvGnE99BcPF4Z6H9Sqjl9TU
    SzfVqySmJTqUp+dvjCbTwthQ6ZdKtalOx/l8QeTNp5xFTmaFF1DVfNcvM3pyDPpb21Www6
    3R3slpGbiMqAzaIIRUsYMPRPNxuTaQWRtECOrTDRwaaq/Vk38K3WtX2Pghy4rw5doBSXNq
    E9pkEHFEX0nrwHiLAo6fFaNSULmknGZhmsHc3t4jTpHIwDKewXL9fimqBZTV9HK5kVaQnZ
    agMSisNVLgaNkf5hzfNCMymSL//IYqaAJA7B+GsF5DUsPdmLKl9qp6ZaY0Qg
X-ME-Proxy: <xmx:_-LIatiCMneJH0HIy2y9okd0sPi4VRQ0NWsj0kBcPJyK5DI8Z5iRnw>
    <xmx:_-LIak1x8Jw0mvKWmn4PraDfclGS4gfCfhVK0pwixN5v79DHp4BOpQ>
    <xmx:_-LIav10mlKaM1P9mVDFgzrLZsgdspP3VwVWh1v1YsKz6JffEdLcjA>
    <xmx:_-LIalxN4F1GFZFaV9wpQU6VAthEXluLxW7Z0gQLgg5iDh387ajG3w>
    <xmx:_-LIanXgaClIrAcoxotbckLmHIRKltUhrrAX1lztfmx10PQ3MqjKauD1>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 08:50:06 -0400 (EDT)
Date: Fri, 9 Oct 2026 13:50:05 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <asjivmGzSIqTzTXB@thinkstation>
References: <20261006091815.897133-1-kirill@shutemov.name>
 <20261007155316.2010164-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007155316.2010164-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A85C40009
X-Rspam-User: 
X-Stat-Signature: fr5sn3rafp51bmkqyk6cmfor4oihxc8z
X-HE-Tag: 1791550208-63046
X-HE-Meta: U2FsdGVkX1/1Yxrm7StH6sZIAB7t60EfciJhpaWmX3LdRWwU+2OE3ftPBCiJtIxUGBnG2HShhjFuFF9xBS7Pn0wNNFwtFT7rV4mKSZ93VA6ZjTNPzVdPmPwu68ybIj5XSA6yoWYdq3X7RjwDK0V8+ymNeDo+P5AdVutji+QpyXSEcBISqrpVL1ggAiPABDkfCriQUpJTVYzW8F4x3e3/Bp85nbkFh5hJsdfjw5Wpk8gV3x36OlTqRUkiOQ6pUqIJmveTfhvGqNlOZMNkln5aIuKa0HWZOD9whXBRHSfpMrLypeOw6C+lbWpXm51RcJusufkmLnCT/nB0N32mIov5O9sPeVS1eXP2HGifMGIHMz3e6Yefn5svqfF0TtvM5NIQCcptBVQWW+FNOFPh85eQ0+M2va2Ttbo/s1/SdzwO/u60YEq347Pmx+B9S6ZlfkTbfVen7lXZ01IEwvvh6f3GA3LmTpbMdBBaQ2JN30UfJCOaipdYnoQXG41mAISegGhvALeVIMVXPnuTvpREFxNbNVfwXw+oOaoDpvmHqTNepSQXln4tGxgGsDqovIhmwkk65X5AvYbO81M7j6rrfUk66aLlheZa+XvOeTxLj+C6UJWVWn/t9kwzNgLsHXvy29WaZFBwYaAKlqeUghGXOFeT8LQEYLWb9DbD3l2y12k32wGFXB41gGPPWHDfLHQu0/KmeBTC+mNPEdeafXziqabK5OJPol6p/PO+Nl0YLfZmJK68Jhu32hq1SNxLWL+S2h93vnFFWa4PP4t0juKtzmh95k8IAR/pl2WZMW6xwKZYVg5TPZym4YBS9MGti1hH0R5KjthWPiJx906HSq9U+nEy7WOGZ1u3fYXKZI0MNKxYKvx0+yKKWmxyCjfg0K7hm9RadGuo4HXT6MYve93CWbxxdUW0G6U+Y1P8LWgkm/FDbHqjQs5m84cb+K2GFQ1sZcpyCyjZ9KOkvsuH570vQvo
 Jj3lk2cy
 04BTBsnWKWiEb/1Q74iBUzTDZhWZ0LEw4k9K+VxP569yURbS6LNwQWFhHjDjrKIKJz2AcwdzHRE1JFSJovjREdJwi6dcVG6REssTCBj8/Yfq8hrIF6N8/qFN8dzc4vOOxxsDMtj/SbXfWI4IM1w7XH9tQKMPv/a4zY9BHSInbg38f9PYR47YrWqSEiA+km58S0qcFtdycmfcfikEbks56P4xTTxzTwGtKq3ap8I8ihUnt0fHOS1PeXlgjWUzHBfLw83a4HOblJjPZVpGmYasX4H31q2dKPqS/kEX0GzmVccKlY5C0P5Tc4x0tyqJkg2FEDsoF/gdA7eemfSZHF448ZJVLGeR7sgZYQ0D3DchjUMeJoct0DcjXcR+pPsfkOw98wZZ9vlAsUDgI1SgGyIgkDc1xuOyzrPhLS4NBlShdkilot7UwZhs9LlGp73VmHRhBQY0ErtHXbQve6PBLpGsuPNSDVZ56E/4ucq5ava1iR+sGMLq/Y1FykL6TG/rQ/G+T9XZnhinuOXFvyPq60BdOarckx31Ee1lDGYlte8QHec1TPmIxC+v1gvVKsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 08:53:14AM -0700, Usama Arif wrote:
> >  @@ -5007,14 +5034,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
> >  	 * of free memory (see __compaction_suitable)
> >  	 */
> >  	if (did_some_progress > 0 && can_compact &&
> > -	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
> > -				 compact_result, &compact_priority,
> > +	    should_compact_retry(gfp_mask, ac, order, reclaim_order,
> > +				 alloc_flags, compact_result, &compact_priority,
> >  				 &compaction_retries))
> >  		goto retry;
> >  
> > -	/* Reclaim/compaction failed to prevent the fallback */
> > +	/*
> > +	 * Reclaim/compaction failed to prevent the fallback. The retry
> > +	 * budget was spent on making blocks, not on the request itself;
> > +	 * give the fallback a fresh one before considering OOM.
> > +	 */
> >  	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
> >  		alloc_flags &= ~ALLOC_NOFRAGMENT;
> > +		no_progress_loops = 0;
> > +		compaction_retries = 0;
> 
> Should these counters be reset only when the work order was actually
> promoted?
> 
> For movable requests, and requests already at or above pageblock
> order, `reclaim_order == order`. Their retry budget was therefore
> spent on the request itself rather than on promoted pageblock
> production. Resetting the counters here can give those requests
> another 17 no-progress reclaim attempts, plus additional
> compaction-success retries, before OOM or allocation failure.
> 
> How about:
> 	if (reclaim_order != order) {
> 		no_progress_loops = 0;
> 		compaction_retries = 0;
> 	}
> 
> instead?

Fair enough.

A movable request only gets here after 16 rounds without progress at its
own order, so the reset would just delay the OOM kill.

Will restrict it to reclaim_order != order in v3.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

