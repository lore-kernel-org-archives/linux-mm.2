Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD0E606B413
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amKGKjLr
Received: by kanga.kvack.org (Postfix)
	id 0F1726B05B4; Mon, 23 Nov 2026 09:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2CB6B05B5; Mon, 23 Nov 2026 09:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3466B05B6; Mon, 23 Nov 2026 09:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B298B6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:55:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09D1D1C406A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:55:51 +0000 (UTC)
X-FDA: 85466683302.22.0281C55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E09FB1C000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:55:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amKGKjLr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795445749;
	b=v8e5lPZPAD11kWYVwWP+H9wb5codrbrw8/ulxLoeb2OCd6yc031fJhqx6D7hgZWKOBNQ3U
	GfM9rpkzWa3wxq09fQ/OqyxKk3t95TnpvQEWDtuMG54HYo18Ewd9cQvo88MgFYlTFSXd4d
	uSzLDgjWm3wtSSQHBLHojD3S/JKyTaM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795445749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtAIY8t++Pi3S54Gl+4rbcWBOhqrYWd+bondmO7DScI=;
	b=w5yizk80wCmbP/YenkefUHYoWnrDRi5Z2rIob9kTfOa3WD10l4Z3lnaiRX3zEeg6IWP21w
	/W05wi8pgoMC2t0zAkOrlp6SgJWriH1d3DQx6VfgK2yuCraRxdlV+jjUMQACihY5PY2ruO
	usyHeeV54gYeNptHqI+zu4b+gW+pcYQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amKGKjLr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21ACC43823;
	Mon, 23 Nov 2026 14:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368CB1F0281F;
	Mon, 23 Nov 2026 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445747;
	bh=GtAIY8t++Pi3S54Gl+4rbcWBOhqrYWd+bondmO7DScI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=amKGKjLrMeB918fIou0RU0zHleWRtLMqIHvIPFdOrYP6mXyq+lcnL27UVljY1Lu7+
	 8eMcs8+ZytsjN2Of//KZAjFxJTX968abnZxbASsXIGX8lH05AMNhd+zQWrl2JoOQBp
	 H2p+psmq7SnUDEErHhzGBIIfww/B0JJ58Ogn81q0DbnXyEE8Dyw9vVhkYK3EX1weMs
	 uBxDohLgp6O5yISj5V1d6v8hzhH6snFRSI6c+fCkfSAdUS8YHr5E5EbLqN/wB38Tyr
	 sEUZt+4Cp1pYw24zPlHEYRGj/hkiRf+YicZJz+95Lu5y1CAJ5EIhUijsHtFLCA0L+g
	 3ELcMgCRM+BPA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id AC573198003A;
	Mon, 23 Nov 2026 09:55:40 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 23 Nov 2026 09:55:44 -0500
X-ME-Sender: <xms:7FMEa3f-Sz6HgHM1Hz-jAv3ZeU_sNmrwds1nwGVg_ldynzJSk2zuYw>
    <xme:7FMEa7pTH-f5jXyuHfRoYHxUZFbH_XHUsPDYfRsRx7q6eXVS3XAUms_qJbwrzra_S
    Ko5YAjl1JZcsVe3OB1zqhJOm_LpLkNM08QHnH-yZ7M79AlUFdNcrxXJ>
X-ME-Received: <xmr:7FMEa3pJdAihxcgFR_7-7_62v4v-nrAbiL8ADCXZZDVGBfcDKqJpEz6M6kw>
X-ME-Proxy-Cause: dmFkZTF5/xtpjPpHesf4aE3Pt6SqRbNPn6rHFJce39L5WbVhcA6BqOMSaZbdO3uwhHffvC
    zz0SLl/RqCpStIBJmFLZ2miQpr6V09dAeZ2fN8sXfLFpbHB/OPdpNkFjPYaQbjLx73U5xK
    M6sgigScqL1FXS/dkG1BI38AQjOutbopnpGTPcKxaCTQSfFRsfOSDNZVASDxurl9knMtGJ
    XtRLMPfprJTsS9YAKtzbJTjWqVza+EEJNYKvubfLJ1as5UKbiqle0FV4Uf3B7C3PhpLu2k
    mCqqPBAMxSg7AsSlnp7+MS+i9NpUeqEghe0sCakC5uZ/0Z2IgkEMSeNvITP8XDQyGbvDkn
    7TuCq/CSaDAyCkScCZ5Dx2aHfszPVp+3wtyvl3IaL3JvMG2nMUozORFgRADVd3ggtTCK2p
    jCSZT5NeYqakFUa+Kcg7mr7Ciaeimz/mAz7OtKC4V3ByTzAMmTlEqxmOJZR9NlirZNmfjw
    PalJgEsnN9vXd+QTkADZBpNCzdM7MdcwjUFXTT0KAck8fRf99KmRIh/aaeONj2heRDcnM0
    ZlZnPrHqFbDoTBYj6IDAB2TdixIyEOQt4xVcAMwdH+xJMvpLjHB1l0eoaJQS3tfSHp4lLq
    Nyz6K6JrohwwD4iCBSCG2zcgeM2VnNjdMuxaqqUlTxfeWBt6TIpNcfsnqYng
X-ME-Proxy: <xmx:7FMEa8iZOU6kxNF6w-VPcn1t2VVd1tCY6ILW9SPAKaCGgJEF-0E8sQ>
    <xmx:7FMEa3FG9GRYhU7Uyj1tSy1KWlo6aZbcdfAQYH3xKmQWffIX46Kb4Q>
    <xmx:7FMEa0k5GSx9rpzw_wxnmFwPfQveqaN3yxBvIOTH5EF5TG58hZHqKQ>
    <xmx:7FMEayCtrwdh1EeZOlP4Otfrr93Q-JsHnuNvtoKb--j6hZsCdwRvIA>
    <xmx:7FMEa49bRadcmQ0hSzXHjH4Yzv71FAGwznnnU8lAfKVjh8Rnw7xJ-jfG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Nov 2026 09:55:39 -0500 (EST)
Date: Mon, 23 Nov 2026 14:55:38 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
Message-ID: <awRS1q5WvQyKLAf3@shutemov.name>
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
 <a066d403-1608-4c0b-b06b-0b786e71b12d@arm.com>
 <av7_n5llADUbJI-r@shutemov.name>
 <38d06816-e138-4edc-b26d-499617870506@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d06816-e138-4edc-b26d-499617870506@arm.com>
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E09FB1C000C
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: t9ic4wrr6bwqam5urhbwh7e18qijd8sz
X-HE-Tag: 1795445748-316206
X-HE-Meta: U2FsdGVkX1++nHXBKTJxjO57rOYpYAIPoc4nGAPX68U7OFhoue3wbqPxFjQbFGuwtyU3RbyLqnitFpQO9vTPCe3QUJtEQFfcltCBQN43U+4H+EyjM/fXXh+yy1umM9rtKnV3/No6drAmmpSV4bfd7ZShEwtLXhGR1G50LlE21+Zz71K0/LXfwtGtyMb59fL1O3Xsk5KkpjsHgQ/+ZtlHUIesjZarhquBaop0Ade2eZKmcyBIijo7y59CWfGHtiEjHN5JoRUFykKqkD9lEfDaua4nPMZnZJt5w8PmS417Adk5d9BQtzSy2QEosl5Irz7hKdQEjL2qOE/SH51RmKeWNeUyXq1V6x9tnf9t1aFY9K9QlXt7kECYGJ3XBBZmBCiJ0LFo3S1b3+QDdieW/JMRafOKbkYHpGNL5wlrQ/hzb/WHAwTSXG9YjCPIEfTKgnDtrhybi+ltNh4MviFC2/D5gUm5TWY27D4WGzdP/6ctywPkCRHZE6rG3Rc5NXcV7GIq/f8+OqXogKOazsJY/oEJu0UeBLTVxbyTJVaVRr7xBtmgICexNjqt7oUnR+ichhG0PdZnSYD7cUHxK70mWYSxr6r0WOu1f8T1zkMumLipRIrhHetZ3wwmFFAkR842CkK+iElOa7lFMJ3mqoiR/fgcF5JrQlhAvn6En9KxX2D8pSlyZxj9vPwD8suKnuTF2MjHzy6F2W+zKDqN6DHkKuNC73MKYreaR4HV/uG/26GdawyU/1n4k6wIjl677k4MasK5+5RNbFUg+M7BvwDwdj/+cq9AXpsz0Nd2Mt+DG80nAmHt0m3xDDgClYqHr3GmvTbYiH5hVNTupkGBlRZbcFNxTYj6H1XR7/Jb+Tjlv7/AIVMR2EYI+ZnYNajkk8vDO2cgpphjKsHJyZxbs55dXfTS9q91v6zvEFjf6UGWXGgJZTtDZGw2+cUurPqwiAoT6ljYk/i5+QUfeqZaQ4xj0PF
 AEu+Hfur
 0AVzjtyjYuhwS2HZetYEF3BldQeVPmpFII690vJ833crmTy6N6hGiHsmN0wjlbf14llKCBU4w8FQDToEt7jwni7O2xrgPbLYNUUVcmvJgstFU8oLQs0EhyNWM1Plz6CTyUjgCtAfGxIoAk4E5IZulNDc6cv4NYrf4AYVRsIdVJox7k0P14Q9Gpxza8cEM65PJt+nmteQD1f8i8mkbM5DJn7N6Z8zPC0b6WqV2w5el7gmbPuuaHKZxQmNtGWJPjgIo2n1GfJBxdNrMPQSCwDWqDpXuxXqn20eqTvl2QUikDiLoDsh/L6MJng1AeZsYMEl8bM5HiJcL1K+qUMneKNVQIboSP8QUbF8buKTQlYhZpBN+f4kvpCNEapCp9LEEIT653+j6C273Rv2VBEoLUoyOPr8eHRncuxbO98HUYH6RNeLdFeaPt8SVBoZX0VgdBJsDOKEUdoiwBorg6GwtKgQbKqwbhd89RhD02pTULYcGTCu2n4Y4U39S0oedmkJraDjBlpJ8DH93a/I1ST5VBypWZ2KxR3vd8fYcVBvf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 04:11:37PM +0530, Dev Jain wrote:
> But, for the existing callers who pass order > 0 , aren't they also checking
> whether the allocation can be served?

No. kswapd's pgdat_balanced() and kcompactd's __compact_finished() have
no allocation to serve. They are woken with an order and balance the
zone for it. There is no migratetype to pass.

should_reclaim_retry() has an allocation, but it asks whether it could
succeed once everything reclaimable is freed, not whether it can be
served now. Its order-0 part already counts reclaimable pages as free.

> It is confusing me that both alloc_flags and migratetype are logically
> part of the "allocation context" but some callers are doing
> alloc_flags & ~ALLOC_NOFRAGMENT ... I am not sure whether the below
> Sashiko report is related to that, I didn't check in detail:

Only should_reclaim_retry() clears it, and that is what Sashiko flagged.
It keeps what the check did there before the series: it never filtered
by migratetype.

Filtering would send movable order-2/3 requests, like 16K/32K mTHP
faults in a MADV_HUGEPAGE region, to compaction retries and the fallback
sooner. That is a behaviour change of its own and needs its own numbers.
Out-of-scope for the patchset.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

