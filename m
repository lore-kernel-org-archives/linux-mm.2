Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E4EC88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CEF56B0098; Tue, 15 Sep 2026 22:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77FE76B0099; Tue, 15 Sep 2026 22:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649E26B009B; Tue, 15 Sep 2026 22:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAB76B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:32:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D7481205D7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:32:04 +0000 (UTC)
X-FDA: 85218050568.06.86E7754
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	by imf25.hostedemail.com (Postfix) with ESMTP id 528EEA0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:32:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKevCqde;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789525922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5bulolzgbD7rnwFa9XUI4k1+KcZwVQ4ZyiskfXtqsM=;
	b=mt4IDTNnYSot8Wo8sbu80JuUbWR2SCMqYXQylfdlW8go+MNk+ZOEfYie6YTkd59ym5Tg8I
	GmPo6r4oQbA3BFujR2i0PxL8rt8xTKupInYc6UayfU6ZxQd6Ie8WIZB7NAKq3hIhFI8XIp
	0kaEYoLtG2gz8HR5jfOvSTF8daiFQdQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789525922;
	b=hObvpbUHfzpWa4ZO97Y3wE7HZ9qjG1TqhN9cqFHZUbQE6Pdv8ecx2pTBgjh188tuyCeikS
	lzlm6FaES6kvJepUZp4Tj8y2HF9gUTKGvq8Wl46JskPuplGQlpuvEWGPx7UFTtb+tRP283
	6SqYQ65NQDBxlGy0iOIkN0gjKXNHpDI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKevCqde;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6W4t1O6zL3vim3e+wdusHCDSqONbr3dliD7/v/Y/1c8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525920; v=1; x=1790130720;
 b=BKevCqder0SVJxHtfV67s+LrqRff5qOlXLFQxjcR0GvnND/mp+2QrBCp/yoJmKLHpvxeF68v
 n8w0vlQcdKIQV0gfdh7EEbHAKw4vuXgJ4v+BsUCyBEWZIFEiiN6CBqCQPYquwx6QcStvTrjdZML
 f9PAof3JOs4ZHUiq9STAhNG4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id ad698002a27eb520;
	Wed, 16 Sep 2026 02:32:00 +0000
X-Mizu-Trace-ID: ad698002a27eb520
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 04/11] mm/page_io: take a const folio in
 bio_associate_blkg_from_folio()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-4-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:31:35 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <CC7B7144-E53C-4A6E-8B47-61D4A440173F@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-4-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: 554mwd9k54stkx9huejc1xd3fbz58y5p
X-Rspam-User: 
X-Rspamd-Queue-Id: 528EEA0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789525922-884594
X-HE-Meta: U2FsdGVkX1/fXVm9yns+zY/bpxbu2aw5XvzdRPQHpUzoZlN14Op9a0SiJpQlAlABvfXJpolPUttsNnhXNms9Zzc+fYcD/8orKM+NK0se+A7m0bLiO7FUUAUHJKSYYkLfKoDcQJ+RiiRDwylvb+tyl8VN/UBFliZfAauWz+lecMNW2/Uv/UgJi4FYJbl86jvT3FAr18Jos9hJxAz9jUr9FiI9pTvy3hn3ustQUQ4EIKe8wYDl6hd2wnu8SnueThcE0S2M4VcH1l9idzVUxgsFHcE/rwsGuk9xtLE0b9JIWF8mPl53YWo+CjZ9kb7KtivLeFtB64/a7MRWgTZo2Muj64Av83PAxZw2d0Kh4T/RDPQ5w2jhiAM4n/xoVqCI5tQBmW34tjYunfxEexwosKcXJ9b7NZ9plHumIYPLt/yfZNHMqVbmWEHUyz4PNDX80TwPK3kTeMI1lg4lMl5cd8Xbe/yfEyupwZ8LH4e8immQ6zhXMES/oY2G4TJ9lvRWVexRatdXarLWkmMeBY9f/dOBHZVFEV4gl3+X+p/UCs4CLpL+Fvx273C9WEw8YcLmHBp8CPjUXl5MV4arcycGWdzTjdVaZb/STQM9QYdDTuDfwwrB5kZQs7TDDK/rRiS+1c4uR0oM1jJQy5Kxg7L+uTjfszHHN85TJezRZ2QMpG4kyoOKX+JMkSR7Z4/rfiJ91LWx6niiA7zhNvm8pHDbzb5shVc9JfgoEB/whsklPL2I4ZAgWaUElN4cqTqUIRO2VdaMyIsJWg6NpGcspA67eX8L6WLPTL1p3Zp9fiUZXC44gBco8Ny0u/Uxf+0A6hyFzl72ZWw7hDE+472ZAOl8jFGuR6artFzhhapblbsLTVzFRIQocoD+VDE471D/y5r80bTufK1qYSY/wY3LM/Snd643LBa2qkXD6vLMbC5Wuo8P/DFUV6yUQKo8Bzqra48ksOAJjVTK1vfirZbCduAALI9
 /2InHLGr
 2eutMuFqmfFZiYrvABOq/lILEwGvGrS6/LGID8lzTeibEqbJ58XNzUwxoWdeQiEC8SQMGLpNgrqACO38CcTqVwNWOUBR6pVA72naSVxdrox0E20KFISAoqUVoj6v3PPkbQnzvI2QKeSKi0hJCc/OOtJPXK4K8Iyd6rxVBpAf0htadAcH5hV1IE14wmNBZ4jl2HUIcfWOqA1Qssc8gcD57KFBrm2JqaLObiZGLoQdB1LVaCIDIztVrdN/edVgBkpuCnoF01tmfRe4IPW+Uy7ZM5/8B/HmGGZmXJFCpyDB7N0upT4L/mW+nTqGQggUxSk/wrR0O4quhGuivvqfeo7s4P8tm2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> bio_associate_blkg_from_folio() and its helpers only read from the
> folio. Constify their folio arguments.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks


