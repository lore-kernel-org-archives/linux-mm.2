Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E81C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68CC96B008C; Thu,  9 Jul 2026 08:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C566B0092; Thu,  9 Jul 2026 08:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504FD6B0093; Thu,  9 Jul 2026 08:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE8E6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:59:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B77D4A0147
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:59:51 +0000 (UTC)
X-FDA: 84969245382.22.3C62526
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 174FF2000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:59:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J3lGK4Te;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783601990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfPuN5XK89i90iKP7N1UEg6cXPRSfGHauPrCcp91Soo=;
	b=ssWyxJWXF4yieGZXKSc2evR1kxLvtCcDyqpp4/fYMYdE1CnzZicZd2hT22b6OUnuHNmAip
	vtsIdZrsI9i87PUY2Cc2qiaTMS1En5oXge085+9yTe4s2g1LWsM9DfERy6uv4y4z1OWM56
	Uy6gwWn2ga5O7BL7HGQvV2wLwR+Fv4I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J3lGK4Te;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783601990;
	b=urBDp9Qmvs7YIf66BTIa6DhAW7VfX0acRVAjNjftaIIEY94MGzeJMsK03z5ikiypSEQ3v2
	OlBU23kp2xP95E/hE0sro+adfbpvV8DwK08Hbdyun1YBBYNJht5fAIk8jfG/DUq9OfBALn
	ik4fLUFnWTbIzDb1D+9Vz3Ym/+kWltc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0850043651;
	Thu,  9 Jul 2026 12:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B3F1F000E9;
	Thu,  9 Jul 2026 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783601988;
	bh=dfPuN5XK89i90iKP7N1UEg6cXPRSfGHauPrCcp91Soo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=J3lGK4Te1f4zzXGsuskTvVM2iBsyuSztXeOmCggDo36HjJ3cFV8/MZPAkLsLFQuzS
	 lNVmeEbnta9/P5w6O6w9uM+11NdtyZUs9hA3OafhOr/Q4UHG5Xyq70hDx3FmpkjRla
	 UHBbV04VVT4urrcAR4hxuiIPkP/cdxeSW3G65y+mOSwDdd9ogtDLl6pcH5//9D/KrN
	 zlupO5ofc9MYYuFPrlnmkEaVq8YXf+uicS8JLzLuThh9pdRXv4cN+Hddu9XJIwCiF5
	 4nMf33vBikptKw71xYxPVonYLUz/vsdC46ymFQu11EvLzSAapT1ixwKexH6HjjBnD6
	 1DSahxeZccbnA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Alexander Graf <graf@amazon.com>,  Alexander
 Potapenko <glider@google.com>,  Brendan Jackman <jackmanb@google.com>,
  Christoph Lameter <cl@gentwo.org>,  Dennis Zhou <dennis@kernel.org>,
  Dmitry Vyukov <dvyukov@google.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Marco Elver <elver@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Tejun Heo <tj@kernel.org>,  Uladzislau Rezki
 <urezki@gmail.com>,  Vlastimil Babka <vbabka@kernel.org>,  Zi Yan
 <ziy@nvidia.com>,  kasan-dev@googlegroups.com,  kexec@lists.infradead.org,
  linux-cxl@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: split a couple of headers from internal.h
In-Reply-To: <20260709-internal-h-v2-0-695631425968@kernel.org> (Mike
	Rapoport's message of "Thu, 09 Jul 2026 13:00:02 +0300")
References: <20260709-internal-h-v2-0-695631425968@kernel.org>
Date: Thu, 09 Jul 2026 14:59:43 +0200
Message-ID: <2vxzh5m8l3nk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 174FF2000B
X-Stat-Signature: 4rkhkq8jptrj87sftfjsrhbesdiqugmm
X-HE-Tag: 1783601989-950230
X-HE-Meta: U2FsdGVkX19FEAQZUympXsIbgjfk5UGxCMJ6GRIP8ZKfL2qFT/71c3XoH5Dymmh73wyd0D6BE1AA3Vf3LXkWNIO87MRUg8X6clRwCKAcsMR2HYKhnUAm/mdFFlfyfwE7KP9GuIu4iSJxGKfRmFSjwuzaJGpHQu9zibmk/a73S0p2kL0HS2wEuoF2IuOCn5ct1Xo4AhjB7NzawpXKZyr6AMeE13IQTDbJlmkW5VW37ZpkxYdi3pLynwg/bPpn4mz1gIKc84MEsUwi+EKYW07cE2s/wuH82qdPPP59p82qcLdcfGi64LqHDehadZeKPFT8nQadfKa6Z2gPf6a98QlGG7khjTqhHLfFTfB4TrqXR9mNKU9I7ZSOnTFMq3eUYAo6/3sXHQupmbdNaUV4tBIPX0A+BGZ45HY5/Zz3n13Re9mjgZmjFG6AYl8iIpmgv20/jnSYZhmr1d0P+IJr3Hh0A0utL67LSQyXCrxUoswpiHLyZyBlEYxY/oat3U984pcCicfgUCivDmcsFSjVs/y3cwXO89lFTJ79xvFGXYFTNF+WCaakv3LsjRg322QhZtwAJoxcGVZ2kqTq4wNE0OQSt6QrVdFr/L727OtUQkeHI2Xpm/Rr7yk6/f97v9oZsC8Ymj8hBIaDHgul4CUyQyYXMrQed4+OWvc3gQO/lXbt/ux6xUlW+3uUXcPcNBCkx/CUTefANEWf72vk1My/UVPRQhhUB5PRT53dyg5Mf6oXlr9qrzBjUlKOkb0g6NeS1dCRT28EyD8kvrrpEyWvC1r+R8lg4HmU/vYlnrk58GqylDsJ428/i4+yjGAp/Q+50Y0QLEL6IBpACBnS+9VKRwh6D45INKSFPj6fXZ8zYCJHoRECRwwX/gMsSgrW2c/IgxoCpipioWLhvCfEDAmuPSUhHHBZOP/eUYs+FMoiahZrEVHPYUTqWsDNvQ9yKAYb8cbJHfDY1QGRBAccY5O5Hco
 4z0np9up
 FSSyj+DMKlzxjSTSv2In4UFG1MgSrfbYhUTK5GZzTRgKWM8gQcv5Rop1G33YO8Rn4ULkZlVPviD8N+cJsAmPbdB1ZoHzXDcqKzfdo+rwGjyGkobqrNcFxLxcxnd/7JqkAfKLn0k5g2SU+h3MfrtbObpn5SXd3/a5NY6LWTSuJC+Ew2Aflldp01jVt4K2A3Jjhm+8yRUmA1xCTqWb45j8EKtRn+eerGUBucTatxusOXUdiaH1nwEJ0nX8dKVaAXI302Y3o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09 2026, Mike Rapoport (Microsoft) wrote:

> mm/internal.h becomes more and more bloated.
>
> Split declarations related to mm_init, memblock, vmalloc and sparse into
> new headers.

Acked-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

