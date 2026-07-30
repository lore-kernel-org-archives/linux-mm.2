Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 339A8C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECA16B0099; Thu, 30 Jul 2026 08:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D506B009B; Thu, 30 Jul 2026 08:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA6E6B009E; Thu, 30 Jul 2026 08:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BAB36B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:00:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99C7A80116
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:59:59 +0000 (UTC)
X-FDA: 85045299318.07.DB79377
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A0F4180003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:59:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6fcX+V+;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785412798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFyNfAcYv9RPgYotYZ60HIainFhyC9UXc9B2zptyL6E=;
	b=D8kBYfoXg8kYjmKbBYthxFP7uolcRY7fXnWoOpGr81C93hSozNv/QjnPVvLaqGhsnCQqhN
	7DaRNKyVdGdigV5w+s7PxTrDsJAkSiiN6qcZnuzpBeWNXrBvqb3CDGDrqZP+98r2DRpQ17
	3PyeQ9i5BX4nkIOP+GN88zSjj26BBzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785412798;
	b=FJ+rw/fBj7G5FgvOESU0jWQpL8IoqZEoIp9uE9dDTftYekt05c2h9q4whOGs0iWpFqutaU
	KZ/jg6xC9Wk4XJP2ELlDz4LQWQOkJXzB8fr5E+DDZmDx7iNXZT6wNVy+NV0S1ocZxhgm4K
	lV19H+925xrhjkHa9bRKw/urhyFjc1k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6fcX+V+;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 30 Jul 2026 19:59:43 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785412793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tFyNfAcYv9RPgYotYZ60HIainFhyC9UXc9B2zptyL6E=;
	b=H6fcX+V+Zq+Tdlen2oRt4iHMVx1NYD6p/BkA43u0HK8EKE7Z5RJ24pck1jTyqQmsGiDTZI
	pnXhXGMBImTQby8sdSZsu5+k3ql23ZYX2dlrF12SkWghfKiw5KmzHH+KilqDA8L0lMpjoE
	85mDM69mmQUC564eY2GQuZ6dAHa2Yuw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 10/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
Message-ID: <ams8mMMzBmu1AoLz@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-10-c29ef0f1f257@kernel.org>
 <11f5028a-3fdc-47b4-9712-559c065b87ba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f5028a-3fdc-47b4-9712-559c065b87ba@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A0F4180003
X-Stat-Signature: 63dokem5km1hk5dek1hig4bwh1hqph7n
X-HE-Tag: 1785412796-880062
X-HE-Meta: U2FsdGVkX18DBwv/N5RZwwQTVhQE9kpRMnQygOq/BOHy9BeWqGYl2u7+TBInC+F7LQqqI1/fPEVbIA4GN1MTaB70FbLx31dADues4Qql7Ucz2jcV/tUSy0r0tMxzastEVyroviAIqfmRQzta7I+ixrRVcMj2W1QamnA8gUsQCUlcWxP9jBIw6H/13gXXof+OnV7nSgzY1XizGO1zFwHmv7L9yFlZ9AtKDgr5gK+HMPNtxycefJ/ZkErKqqY/FPY+TqpTOV1mQAxp486A0vC3/sDB2X85Bs9vV0Ui1DvMU766YAhUlb+doR4D2z4Vts0iouOU3aLTDA/Cq0gSp8s5HZpVKldUgkHorPAWI0SZguPri9HnUeF0yrvuKd6kKA2DEySd6OUnvgeyhtM2NZBP3yaazxltbvA1pahQn0dw50eB3FIU4mAtThANnIsHYh70VDHzlvCi/NmWBzd7fNVdtoVuzyRkB4ZRokGRzzAZEKVYIkGijiA9UE778dj+07Z9fCd2RnVuxsU6m7UEm5WPSImKaHu0GqW/M+uZC4AmB48lBLExHTk5/7WoxzjkhYfaWzROwSDv6MoDfOqFMIItrpyRoiZK2dPsm0+cmbBd+Hd6IWKwbbU/KVqBpgejd3pdOrTySeBTIvf7r/2gjj2udDx03HZcLESz63y+kgyj6xQeSGFoEfcYeLFl++Vh67Czf7NnPsJdd6NUjJCPh0km8zA7MxoM4X24t7WaVpz2HlUlhRQUiU8J8R6qoecdOtIiuzavFogao8rldjng0/nlu7+WYVmnPAQ8v2jBTwNt1cMAn8uVUYOxamGCeANDTR2ZoIyuFBQwN4FAMvusThNHyYAHl2hNQPUPRFcSnjqU6Ipoa9U9YzKxl4DNB5xJeNbF/+tBNOHUEoh/kCR/r0MwAQ4/y+LTb5Kgr+mzS9T2JmFU1a4UTMs3o14jF97V46mYRi+4ZjC085nozRgTq6T
 uA4YOOgY
 Vt1mgxfNlSNQU6xqpRjJdv/aqXlKj9E6kKU951GuyiPy1VCcOe+VdO0aqrS/nTzl0wcuqtWE9F9S9C4bi5Bm1poKWVQOwOxjdqQNcKe8rKfkW+6B/SH2g/akFky63sZgFnLqH4ARkmEip1lQAQa872on7tT2iHf6AqAa5fgHCLubp+IHwcWg48btRV06fhFht6SgEFXNtS7BuROi4WNABIxmUavzv54QZkJWqEHgqeU/nO6HSBm7pfD+Ldhbw26JUkezk6IdsZcjHbQpWIh6zcc4liXC5QVaeOB33hWv5wyvWOfwzZpjdhNnGphcyihi7y2KPI6QJXsJxO/YlNIanPUhhv7Q5T7p/Szg8l93mp2Az7JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 04:07:48PM +0200, Vlastimil Babka (SUSE) wrote:
> Per sashiko [1], a fixed up version below. Couldn't trigger the issue
> although seems to me it's real. Perhaps can happen only with SLUB_TINY
> otherwise the sheaf can't have obj_exts allocated from objcg charge path.
> 
> [1] https://sashiko.dev/#/patchset/20260727-b4-objext_split-v3-0-c29ef0f1f257%40kernel.org?part=10
> 
> ----8<----
> From 905c6500e597a8ecf123ad167698f0a0c1a764bd Mon Sep 17 00:00:00 2001
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Date: Wed, 8 Jul 2026 17:04:36 +0200
> Subject: [PATCH] mm/slab: reduce slabobj_ext memory with allocation profiling
>  disabled
> 
> When memory allocation profiling is compiled in but permanently disabled
> on boot with (implicit or explicit) "never" parameter, stop allocating
> (thus wasting) memory for the codetag_ref parts of slabobj_ext metadata.
> 
> Do this by using the new slab_obj_ext_has_codetag() helper in
> cache_obj_ext_size().
> 
> Additionally add slab_obj_ext_has_codetag() checks in
> mark_obj_codetag_empty() and handle_failed_objexts_alloc(). The
> functions might get called with memory allocation profiling disabled,
> when the obj_ext array is allocated for objcg pointers only. Setting
> codetag refs as empty is unnecessary in that case, and with them not
> allocated anymore would now result in memory corruption.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

