Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42DD4CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B666B0088; Tue, 26 May 2026 09:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5626B00B9; Tue, 26 May 2026 09:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594836B00BB; Tue, 26 May 2026 09:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4562E6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:00:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D295DA03F7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:00:35 +0000 (UTC)
X-FDA: 84809580030.10.1BA7CF8
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id E34F01C0026
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:00:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPOjpcEJ;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqRAcpX+3JOcvVi4m9jMhaxftvCUQ9zppcLisuvJR1I=;
	b=CwRkqkvONMKiy2mrghYryCgbJg0D9YGihO9tZvkB5HB/cCFwWxtQxmGQZsbyhOPP7YbH5q
	SaBAMMG2q2P4TbW0wZoz8nqAkj9b24kFz5L51CUQ2QtLNfKQEUmxnBx3C42ktKtZxGeHqG
	3Cuv6nOP63OAE/jEkr4FCojudzMYkPo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPOjpcEJ;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800434; a=rsa-sha256;
	cv=none;
	b=V5WWYlLM1/ey1BQkvanaEYWdXclDm/hF8oUl8LhJml8zpsO8fk6oJfSVD6RoeKJ2CVtu6U
	80JgYx2aV8Af7A4CJT0QiaFc9sgpXXiXq6rIOC1NgJsyhNDosxRiJjNmhLdlzZzCtTaHXG
	LfdeSmW5HaLYRp3j0x4I3i9TSSrkLi0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779800432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eqRAcpX+3JOcvVi4m9jMhaxftvCUQ9zppcLisuvJR1I=;
	b=UPOjpcEJWndGHzC2ELYwgruh15sSq4mQI7oByMYoO7O9/299xlLZuMnojhcNFoD2Wrmaez
	U3DRab8XDCYasgGLBuOp9fGzAP9fRTUlocJOrMu1kUe5QNBOKApY/nT3RnQRhMnhL84Ns2
	DvrVl0na3WVlsRfBH/4NweaRYxXT6CM=
From: Usama Arif <usama.arif@linux.dev>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v2] mm/cma: fix reserved page leak on activation failure
Date: Tue, 26 May 2026 06:00:25 -0700
Message-ID: <20260526130026.3881822-1-usama.arif@linux.dev>
In-Reply-To: <20260523060123.2207992-1-songmuchun@bytedance.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ghbw1318yechuncnbxtgtxadfw8uwoey
X-Rspamd-Queue-Id: E34F01C0026
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779800433-50359
X-HE-Meta: U2FsdGVkX18Iu9jl8HJtxV8PrbqFrGh+P2/tEWJMFju4d2kxUMwg7ax/ULgcwns7a5hV3LEu758Xq8s1W00+92sxBehhnDyXfqxW7Yz8FRe1zDxwJo72Rw2M23QIhjusS7mWlibuoX37luTxzeehqB4Qcs6TdZ17SGuihlbOnDfAZcehmB02oLHy2qpalhp/2uAJ0a80hd1t9SQILrNN7SH6LclRpTAYrL4NO2j37aYC9R7JC4cziOoXi+BI2GkSJOpXSATdiI709Ulij+HelRoSmBqh/e/JqauAzotZzlbPkbLsgPcnks7Vf6pP5waMnaSAT3L8dwujzOdp3/BdXErA1t4VnLpzOsTNCFaUEvOj06GAJs8tiXpytIxO4QemVveRQwegtujiFP9JI5SUy8xE7UQRlcmmrD0/ps/fadUt+dU9tu4yTB/BPZdyFTligCUxapnaG4o0+X+VnryXiTM96C8II+hzvEtECJ0vtWdBUuzxT7Q3z2vAl5MA00Wr2Heu//jjB7CC3IuvWBlHGSMU9s943RA+G55yT1eXGFcZyKAYmrR1l6QxYj9oYzj1ZDgfoDUQBBhpWBNlNYu9O5QsJ7Ry4Ao2qFqbQjiOnFboI8yXlyB2fq1a/hMAxgPGJAqp0tDrb61s69gv/OxhhlnGX20RWj9Py/WHnOvnnxHkcKLOQqQ/cGp7E3s0uSoLo4LnFFpWckOUvRVBVXhj2C4ZI1x5UidDE4Uai+BAjreYN4eCrgwNQCcFZHVUsh2zXX4rNBX1QhSAr9J6PoHvtsYgCdQgMpG5xp+w2Q2ybHrLUF0aI2ZwCQjRhZ7kC/0w9aiP0CyRzNMKIe9zNWKmMUkBNrIEHAkkSIIaZkQ5y8+fej+I7xPwr+MYILEXogtNl+vyE9ate/C8rArDM72NP494OdKB54vWpBTZFHE13Y/gsHasilzoYqWCEUzlSmogrANn+Gwif8I7dnTk1ei
 cQTipw8f
 R/9vnP0UqUKWs4xr4yi/BdNuaNL6+GSIFMmt8b/U4tk5qhzpOIoGJsl7ObDqoxaazpnJkkl7DkTndlWhQXFnX3BVlvqYP+O+uJeBmeD5hxZDQrsbCHFgeQW1LUJ1JLhN2w34bXu/w7VtM/aCUbhvFu9labHMROTxben/TB9wRTukAgDuGFSA2JzZ//kdVndeQGosLa5tKPQkVR3OwdPZANDyCZXtz1tBbGZ4POjwCOp3MbvO50ajKlU1BVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 14:01:23 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> If cma_activate_area() fails after allocating only part of the range
> bitmaps, the cleanup path still has to release the reserved pages when
> CMA_RESERVE_PAGES_ON_ERROR is clear.
> 
> That is still worth doing even in this __init path. A bitmap_zalloc()
> failure does not necessarily mean the system cannot make further progress:
> freeing the reserved CMA pages can return a substantial amount of memory
> to the buddy allocator and may relieve the temporary memory shortage that
> caused the allocation failure in the first place.
> 
> However, the cleanup path currently uses the bitmap-freeing bound for page
> release as well. That is only correct for ranges whose bitmap allocation
> already succeeded. The failed range and all later ranges still keep their
> reserved pages, so a partial bitmap allocation failure can permanently
> leak them.
> 
> Fix this by releasing reserved pages for all ranges. Use the saved
> early_pfn[] value for ranges whose bitmap allocation already succeeded and
> for the failed range, and use cmr->early_pfn for later ranges whose bitmap
> allocation was never attempted.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Usama Arif <usama.arif@linux.dev>
 

