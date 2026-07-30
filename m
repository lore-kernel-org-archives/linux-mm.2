Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8516CC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968926B0092; Thu, 30 Jul 2026 08:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9186F6B0095; Thu, 30 Jul 2026 08:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82EE06B0096; Thu, 30 Jul 2026 08:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6896B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:41:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9EF38011D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:41:27 +0000 (UTC)
X-FDA: 85045403814.03.865AABB
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id D33724000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:41:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KmNYeTuB;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785415286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Yn6zB4FyaoOlg1O+5S/R+uP7IqARiMq9a6Q5IJKpbk=;
	b=JZr9oDT6ChHA0kDyRxTVJkicA6vagcmAEhXqkYlanpcoVJ9MG5OT1rjXH7jxLZf/2G1Z1p
	ZwdQQsVIYkOjvihsoe7saDMWL9ob0A2cy6bxU0ZPpcNTQjaUD14gqCIT8xkGn2KHT+bWlq
	OTjGMpFrnotWhiqnMwFiYBGfDP28ryY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785415286;
	b=qOI2J/jnQ+hH3tctSm0rSb+lnHgzXti7j3ymdsB9yrJ6l47dXm4F0XmY0h2EI78keH4JT8
	JzA7Ck/Kf3K4gt5LK7mLGNoCjd+esIlsIwgjJTvF1SJdUytOCMTYgELIsSzvjKUUOBzr3p
	162smrD0eM+0cZc7ohcdgkM/7O9CfL4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KmNYeTuB;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 30 Jul 2026 20:41:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785415283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Yn6zB4FyaoOlg1O+5S/R+uP7IqARiMq9a6Q5IJKpbk=;
	b=KmNYeTuBY61Zd8qBvi5I7WRr5XPb7xsUl3E3K8/7mKm7457Qb0FUwKaz9ZsvAaWizpNg9l
	ayDE0CAq8tIY57qHQL9Xf3oqg5Cj+4+7sbYMD5psOO+kk3UNCYAWIEk+vNOSinQvUR1AIg
	E2dTua96p66XoI2NTAImSv4NHgVXBEU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 13/13] mm/slab, kfence, memcg: completely remove
 obj_ext for kfence objects
Message-ID: <amtGQIpVU4WoWiXf@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-13-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-13-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D33724000B
X-Stat-Signature: tsb7aw5psfr71ubaufj5qdw4jxokid6s
X-HE-Tag: 1785415285-631646
X-HE-Meta: U2FsdGVkX1+l9BXHpjYgCRfwGDtAIKRp+JgtL1pbj17oMFskYeNv4InDRxpOsNvAbCf+VwuyKhvtmVwoAl4EHMYKdAuJ2ihObrFtHd2wV55xCea57qP4GGL7FIV7lDqV74fPv+3ok4hO1W4YTZNCC9uqMQcPv0Mxu/mDogd6rNNKRqx0zh9VImkIuJ+31iyiRU6bD8+fnt88DnaV4DV8B2zUEBOHz3sC/QQOntdVdt/AXrftIldgDdmNojjRrQ6fmLBmKyyuEX3T29zkEv+a1Liq+2yZkm0QrUbujdN9FzODEvd2S0y9UCRKJ8NXc03mSBeJcZuBxQCUb90zfT4Cn5a0liCxCZTT2FUcVCtCXnGkn5zmSSlDnxy7JIDilNAR/aDfqP5zDj2aIuQuXl3OrA4Dgo0F1FchZuAPegMjTGIkjfgQ8wJTaU18+gtC5Pl1HXWZj6mcg6G4zvP+sIoBehVf9RaQBB23RnZdhl7RqOZ3pQHjGNWl4T7GbfTHDmwF/pcm2BDrMtLZcDjmEAs88cSikUiq+YNFjILYCuNuSgcPVaqoTXTYEw3ZQAu1VYDkpNy9l6Z9sCtLjsesjEBcjGd2RQ/jZShephyBxDdmSfig0HspN6SlHZrGNtQk3mOIclocJRIhOc6JY9fly7JJoTi8iSc8Ox2jkuVK4nGxqJod5+P+Ez3FJCgcW5hIkHIvERAsiyP4Rn7qEmXU8dUU/hTOjn39owIxVdsYyOuTwBMfnpAwY99VBpyIUKnIAIxixNd8c0hE5QC1NgRJPFj5x+zoyAjGhle7ymLZUOTs8JYpXrytAey5UhHlj0Q4Y3SzRvgEG3XZR5IWXRK0uveLakssbNFe27W4D5fe8j4w6/WdEo8N68bxsNRJh1DdyA/SwyT7YPuO2mZDzVcIlcz+3BTWN1svwzPYTTibSRGfvDYTuHhTPX8pIPiKpoU19GUsoY/eKR4kH8zFOWFZ8yd
 Em6aDoyJ
 jZ1CwkKUT0KWiO5etSvoqMF4bLnsFcCJV+TDjhweUhHKvOtZJaBGxvWjVG0oPfdHP0WKWTSCwd2+3XLne8BNbYT++7M/Rh7VsR6z35xlnZfmdvzSJAHGfatHDWpYSc1GlSIehVF5nSflSzFn78WYN6RIJ7r07Vxcl4zbFHSAg96hXgigwkXmzU+QnA86dENLrQ73LLFgozWSP3wXTSPFaPYEgQQM/NsSvcDZD7TKLRPy2RXAP1kTySlGrF8R+Xp6gLzjNXYkaZdeDTOH72+rUiTiukw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:54:07PM +0200, Vlastimil Babka (SUSE) wrote:
> We have already disabled memory allocation profiling for objects
> allocated for KFENCE to avoid complexity. KFENCE allocations are rare
> and there can be only CONFIG_KFENCE_NUM_OBJECTS (default to 255)
> outstanding ones at any time, so they are among noise in the profiling
> stats.
> 
> For the same reasons, we can stop memcg_kmem accounting of kfence
> objects as their memory usage will be negligible wrt any practical
> memcg limits.
> 
> This allows us simplifying the code and getting rid of
> is_kfence_address() checks in various places, including slab_obj_ext()'s
> usage of obj_to_index(). Instead we rely on the fact that slab_obj_exts()
> will now always return 0 for a kfence object's fake slab, which makes
> those places unreachable.
> 
> All we need to do to keep this assumption valid is not to allocate
> obj_exts for kfence objects, so the checks need to guard
> alloc_slab_obj_exts() where necessary.
> 
> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

