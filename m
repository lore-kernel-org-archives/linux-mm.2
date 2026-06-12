Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF50CD98D5
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB706B0096; Fri, 12 Jun 2026 02:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BEC6B0098; Fri, 12 Jun 2026 02:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8F96B0099; Fri, 12 Jun 2026 02:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE7476B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:57:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E98F1C3972
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:57:37 +0000 (UTC)
X-FDA: 84870354954.11.A5D98BB
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A8C91A0006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:57:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g5Hua4rc;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781247455;
	b=WbZAQR/VM3dNUrBgvcEVLDErAGVreCiWhtsTg3mlL6gpAvrBwUmbQknyUXSCEfq3qAw48o
	pBr70ZlC/VkKATikP0xcrU+0LAuJZd3iD5I+lKaPvdZvjV3kBFlc9rkqLm2Yc3dVb0VPa9
	qh9RwvegSeAPkpFGWEv0Zd+wcTv8CsA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g5Hua4rc;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781247455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIitjL39dxJf9LxQN4sCrPpxW0XRSn3ANFFsR4nqH3g=;
	b=K9N5jLHEY2rsx7BZu04fd352+wyaXVv+5uhQ3h9Bow+IMc1EPnCwh4lkyK/RePM3QnLk1Y
	XCdODxxlWb0T3inMBMhXdqv0iP8cl3IvwDI9OEiC2t9I7b3e361bF1qURBRoRhwKvNx291
	60gtTN9Lul/Cz/TNYOaUv4Q+rx86p80=
Date: Fri, 12 Jun 2026 14:57:01 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781247452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GIitjL39dxJf9LxQN4sCrPpxW0XRSn3ANFFsR4nqH3g=;
	b=g5Hua4rcbgAG7214++AzORxnpvMhEQ0G2b1SP0zXnUOnGyvN/XqHHnlWXJmWGy9UrSlxIw
	+9Q5Gvd+7qjyrs1+4v3jTGO6mX3S85hhLxxP8HHIB7bg1BDEdhqLzIE+4zLElU5yHLyQL4
	QaCoOlEkK9ttpdv/2KUeQfocH/rkALQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 13/16] mm/slab: allow __GFP_NOMEMALLOC and
 __GFP_NOWARN for kmalloc_nolock()
Message-ID: <aiuthBHdDb0CNs3n@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-13-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-13-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A8C91A0006
X-Rspam-User: 
X-Stat-Signature: er3kmuckpruz6ofmmz44bxqngtwsdaue
X-HE-Tag: 1781247453-561285
X-HE-Meta: U2FsdGVkX19nXrs324/IULCBjzG0+q/oOumFM1iga40nvEh+v07IfoN/GY5oCmRoAtVuIgcKt7fC1e+1XkMGiRlQYM4Ukqu8f+qKA7ND7Tm6wz670OMUFNkuWvueNmUUrselZ3XTdpcaaIL73itM8NNMRJY3UCf2oZvv0zJN+FdvHUzO3RefIVDy4PG2+LXWeF2FQWVw5KVD04Trra529sNOtzs2i3J46S6ao42mMb85cptWBcMXyOTbNI0e0NNWRSML9xcWsIgeCFoUfm92QMowg18hz7Q4j8FnXOA0Y4mhruLi2X5gMo51AzDSLsUqGX//Q/Ewna3LKbjgsbkVmE7TFDqy+NuhF6A3vYqlMZTVw21Pu4uwvBlNGbMwb27m8usCYCGcuTv5bQYWWQCrHRpBDEmOzGVXwtlWoS++SYDNH84XJeNIGWOgIY0q2tXn/ttGd20H7q/Ma1IxXf1etXHZqMh/N+je55pJvHKZ81eTQk4x0LD03f0wm9cWPQ9F6rRT5w7RMlbJrON2uX1KmqMzSLNqbaCJHpjhBllHq67LCRMYN0iPq3Zn0JdoUUAYZPSJZTn9lcIsiTpjHmx6HEP1rf1A4dNDkF99OcsR6+mDaZuroL42foCsCQekgaFkru3mxDuzkA795iBtS+j9d5seVt/tSU9yiOi5aXqCFU3j7E5SZjWeAWFVhLPZoFN7gnEv9PQnkZHGyq+TnfLga4Y/clB08LoNmAzTB4qkpYpssNCPhQXNLXlf0KckAJR3XxfzY5ZAIIQZwMKdloO+/5saJhuAS9TSrjhUU+VKsECWfJp3Z6fudfvYRBhA3b2otCEYZ1Nr4/48D7tW523wyAwPuI4L9Spd8EdpBJPbjw1zYYfFDUnZTX0o0gy41ZnID2fdZifp8Z4OxiSOz+gd9cZD17q3o2WywLrTNrPf5avrYCiAucQfMAXZSMmTr+WIAEA5OSWKxdkwGAzbQKw
 hg5oQldg
 l9uMKSGLB1v+BBwteFZzkong/oUwgSjfvJryxzYu+EvGlTl9f4elYcm/M9kY1r+bVsKw205DByMrbwCwX0lJVTnzo3yxoYr+3uhvm90dSW/mUn2uyEfMNMMrhPrg4jWSi4bdnB2G6T/bvpYuqZx3Y/GQccth4UdlvdTjKwkPi1OHeXesEMFeVYDOZJ0B4BCOLUIFiwsX4d9b7XkXnRH9rTW7Xj4+WLq5GiSvlsjlKrNBtCDwYQtelcpYIDLQWU7bRPFJSREvFf37wDsW+PlSy+5//qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:15PM +0200, Vlastimil Babka (SUSE) wrote:
> The two flags are added internally so there's no point for warning if
> they are passed by the caller as well, so allow them. This will allow
> simplifying obj_ext allocation under kmalloc_nolock().
> 
> Also it's not necessary to have the extra alloc_gfp variable for adding
> the two flags. The original gfp_flags parameter is not used anywhere
> except for the warning. So remove alloc_gfp and directly modify and use
> gfp_flags everywhere.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

LGTM
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

