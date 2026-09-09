Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCE8C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A0D6B0092; Wed,  9 Sep 2026 06:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522316B0093; Wed,  9 Sep 2026 06:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410456B0095; Wed,  9 Sep 2026 06:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22FA26B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:23:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2716EC0177
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:23:11 +0000 (UTC)
X-FDA: 85193836182.05.0AE5316
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id E72CD20009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:23:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KBHDXIYt;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949388;
	b=acuV0DUg5VaMa6/kDb20YJ0VNYkOSEHdsXNDDb6SRgOvDhwiIQyN2gyt1nlt9AiF5ovaV/
	EEg/aEyCC+lIC0dVYOJhcfTv21hV3MLJrXV8zR182xDk3fJqGZ7OlRSfKPTbi3+p/DccbF
	ZxzKsmQbWsFsGK6O6LpIgNo6VeWSSN8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KBHDXIYt;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UY30k1UeQzYu1OvDSaJuzIQ8I7z52NjmS+xQ0qJeoY=;
	b=vrHk84uvaGmJfkakbmKl1frBvPqOEsL6EWn2jzBtonOWLJzgVhvDgU1qq/6sZL2J34es0S
	m871uOmruD5jiULGRKIvNL1UspSiIvhvh2yUO3erYYw8uu6hFvpdgWLj9NG9Dp6+pDSoF2
	CVEzlPVUvoT/GkpUNBX/vLT6rKGZ73w=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-87ffa98d4a9so4893537b3.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788949388; x=1789554188; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2UY30k1UeQzYu1OvDSaJuzIQ8I7z52NjmS+xQ0qJeoY=;
        b=KBHDXIYtkYd7uymWn0ZrrOGTHvz4qmsaBwtoeabiBgZxfPOO68Jfih+qom09Y+0ase
         /BTOvFjpFYYO0QZdDMM6obijX0Z7yWbF5EUawOeg7xxBBKwmCvH7mdSvcEl1JiAZZrAI
         XvLEPv27ebUzC22ArcQ8V5yYQYMyHUfUkLI3UUHDEjSm4zwAABe0qXtlLrZvM22rV1ss
         R/otvq8S/oB3AhvTEEMKd5KBw5hxbty+xTxUIhDcWSjr2ilCRikb7aq+Wls3E9ySaRW5
         tlioQA15Rr7YZSoAhcAZVqSQzSA4eLoqpfLGnDLegQ/hwZJ/uJtaSmLEC48bgPj2QvTg
         AxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788949388; x=1789554188;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2UY30k1UeQzYu1OvDSaJuzIQ8I7z52NjmS+xQ0qJeoY=;
        b=d358Zf2logcw4t9bov1fKP//u/9u1wGgTkTJNxDY+8vH4RpoB7414T+PRNJtyWm+PN
         CkQWpL2rBawDie0xU2VsMxfBsOR/Gdn3Cjt6RxUUydUVGtkLOaY3Ze+3yrN9vjgLWuyX
         kiWNfHfRiC0Gua521C5ReKJGPSPdZj2WpV58zU2bk12RlZPi3qq+6LNne8jzONsDRgJS
         j+LbkBBVfwM0uQAE2CmzOFINcFY0wjpGDOT9p37BGfXtcBdSc8NI2lUvVxgwJydK/Z1j
         dEuRJ8puALTwgV1BjUJ22ZLenut735r3s6oFW9Zlw5krRpqqUvNJew8NZ/pO7/Zq0OyS
         4m6A==
X-Forwarded-Encrypted: i=1; AKwUvByWxaVf+n0+aJ4a0618ATQG9HaVgU8TzP8++/8/Ir1RDmLa4LVmQ7i2HASB3w3h29RQw5X5H5gMLQ==@kvack.org
X-Gm-Message-State: AFuF++nuTJovpmaw9jT6T9z6vspKmZ3AF6IZwVlDkZRuGdFRb5V210g3
	0UoNVS1iLubOequokyamj0Mco3Xz6TFJoGM2VAbNSjuf3larZ9lKk3/tQqzppBPaeQ==
X-Gm-Gg: AYBFou2bJMFhhRL5ogJxlbFxVuWZJmzB4LNXpTuL2wvhcsz7ONK69aQsBrEwxUIZ96A
	DLUJ+VG7QFe0D4IZCKAreUaQYrKWfiDODpaMI7tz27pAM3/7zVZ6fBOPXgvKq1WLG9uqPtb3gv2
	SNT2irVw330PfXVCr7g/MG/pgvBw0UvQrAVbq82WoRRyX1KwtVjeUbJkzogl2lNf7+s2JettTmZ
	0A68yUoxKzwTvO2mHU5GPqAJvmBebO+a6hZat8Fp/uWB/6W8KWMcfJ42PPGd2FOp9RWj8FM81hA
	v7xc9cPpd1zCTQWi/6Tod0NnRXWd4bc1qy06JBayjOq2V+blKcqg8NCXRDg7psHVgOpucSPGQer
	l9Q+ve1jh0BFqh7pb6uaJ1nOCYokBPQeFW+iO3aOz8yN6EYysGjSw97S1NGRjXh/1OFGgTse25B
	bbukzyjjbME5hrQZkgnhHV6dO1izYfAqUTHYg1+c1BuAhkbejuHZlhhbIepIWRlWCOEn8tdhpLV
	oiqMYRzC0ks5Vq8ooRSV95cKp4Ow3+O2rdv26L1WfQHou0cAyUsgom6bfc=
X-Received: by 2002:a05:690c:4b85:b0:870:c600:686c with SMTP id 00721157ae682-87126aa77d1mr116385687b3.18.1788949387337;
        Wed, 09 Sep 2026 03:23:07 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714b62503dsm108473437b3.38.2026.09.09.03.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:23:05 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:23:00 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 20/26] s390/fbatch: no lru_add_drain_all() in
 s390_wiggle_split_folio()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <d8a9dcab-4fc6-1f28-d6b2-e9231f3ba150@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E72CD20009
X-Rspam-User: 
X-Stat-Signature: pb7j87oshokqwuyi6exmmhc5ddr4bdb9
X-HE-Tag: 1788949388-407647
X-HE-Meta: U2FsdGVkX1+9jbmFve3DDBvBfAt392qIqyae8hvFuZ7Tuux14/zvkiJpLdc/5FDMvPh4e5KAGMXwBOgpOuYmfVEJnZP47YUYZG/8qMjPvmf3pnvjz2WxBJqyiks+6H7kYzZCIf2DEo7nLe85y4UStvhGCGv6wqL8JfQ9tt28zzKRwNxDfUEDzA8Yxx1p3Jwv2cUHY0crvnteXDSpQNqVKsVV2M/ZTzISTtt2DnoW7ra7OcdERK2fUVY37xsmorhWs24AszrSilJ2sRcmksaGqVOebBzeD23C3mMH8laAd1kN07JapQ4DaVXL7BoF5h0kWkCU3wmwoyZ2qVDhParY4+8JBbYA9sgiiMDC9BKX3uXHlkMCciCAdMPcArIFmsBhdoYI7kXBGnTm/X9cqE4LO2vIirdYRVPCIkmuEy4NsHnNUjhnBFteyHnVsCopyUUfbnJ7AbcCzgfzWnV36d7CLFlHs4h1vnPwN2AgQHO61sjDX7nFrTJRuI2YZPqbBRObHFV89CpbS5bJcZ44OINU3AU7Cw5R4v7R7zEv7EdDVASr/gBQdwJ2BNMlMCQbPs5bjMWngBs7dIfc0RC8n1fV2hikxyYRqgKysVO9fD5ViRtJt4YaPZDUUCORqMFDgAS4ubV/KPIc8glkUZWgcknTyoXDM+6leWyzMFkSqOJSCst3HyMLvMTOevUCKZZfOq9LxEmndRUOPQ7Ehlw5p0efAHXfX2PmJXQzkv77lsp4fcWgYEFb3smINJ33GZaVbovy508Towu3rxp2EFzX/F0nuBVn70h0gKcbMffAjnDGctfQfQUOVwlLSpgBA2UDJO0xmbkdYtgcJG+TZwL+GLnZPvVeHSV/4vc9fVleoQ+liO3XiyAkV+Q6XpmZHlNv4+1+e3aSZHTFOrbdEPnc3gXxYMzVKQ1S03QYb0XQDU+sCv2+z1mUpA+wBUxLy0f3PiUIzQsxrdoU4MDV2ENkGf2
 TgUpnXsm
 TO+s29eM+p6O3narh9JfpIs8geTrFSlROXDRFuMufBzlJ/BOyevDQwbmE/adkYaGi3lwKfHhy7aCvbp/L/e2YI6vB/uZni6ian180H175CC7rfhqRVOECncLsLdl3cFBmJ7m61GZkGXZl8R7D8TF/PacQyY+sdHT84Ok8nyvul7/WDTeGADxHaiwAu0rknFMRvax2V9EvuOZH3D27UrQPhp9VzLE7mvHPpo03SrW4LFuBcn7AZyIrAyTHguN6U6kUICDQe9lhmUbcRHEmLqTgyMmfhDBwgFADP0ycw7iQxscflOFoh5FweRey0IPpfu7GrUoYtsF8/AO7XERkHJ5+5M+FgxhyZR62uYkc5S2ggj0yeqfbN/Imr0E5dOmjzNgN0wDk5Hq1UpBOFK7DrAOwFhC4BlNlyPVPXzaMe792SBsf6LINYpvsYXPuZjZt/PUEU2lSiy32FrrPxRti0qY6O1bzJCfOdGpsIsPj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

s390_wiggle_split_folio() has no good reason to lru_add_drain_all(),
now that the per-cpu fbatch references are gone.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 arch/s390/kernel/uv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index dc14ebc0105b..120a467026a5 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -364,7 +364,6 @@ int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 
 	lockdep_assert_not_held(&mm->mmap_lock);
 	folio_wait_writeback(folio);
-	lru_add_drain_all();
 
 	if (!folio_test_large(folio))
 		return 0;
-- 
2.51.0


