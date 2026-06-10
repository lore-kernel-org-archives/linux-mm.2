Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61AD8CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1A46B0092; Wed, 10 Jun 2026 12:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972B56B0096; Wed, 10 Jun 2026 12:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861186B0098; Wed, 10 Jun 2026 12:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74AAD6B0092
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:51:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CBC31A01E0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:51:57 +0000 (UTC)
X-FDA: 84864595074.01.C896F17
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id 017AB20011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:51:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gXzzDIzN;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781110315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qO7PcTURECVwaL537JQLmKXQDPG+aZWd6lpbt9X9Cxg=;
	b=UKXU4gRpn6r3pnRWPhsGxpQPeRuaBe//cGmn59kNSBYTNUQ3ixteN1vAlgqgnXUYkArptJ
	h7itXbkyFpJ+kYGBj6EmliOxXZBoxOQzzeMeMPYrFCTWjSanzlFoVQuilRHj/4NwXzBF3j
	lKwKBVoEWKlRQTeHYrJ35kdDPt2J37U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gXzzDIzN;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781110315;
	b=rZgX3udiA+3RQuosaerwEedjqj1ySQp5C8weHLfekMluRJdeEroPJFD6gqmCmNwXpakuUl
	sLrtUlVwZZn0CUty7WcfzevVOeSAITcGap79RizqwnWgu6eLhz4dYRLqz3VjrTeBrUTtzN
	Yim1RO8fxaB/C4V1gTDYTpC9hXuwT3o=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ccef25789fso48385486d6.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1781110314; x=1781715114; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qO7PcTURECVwaL537JQLmKXQDPG+aZWd6lpbt9X9Cxg=;
        b=gXzzDIzNTT5uTO2WDWMh2EaPp+fPSU61/hmbUP6TKDrqHLyFAb22cIdibEpOhTnLtF
         ptIM4tPJG4OiI2lXd5ezuLncNe2LyR4+foRRLqFkJeIbUpiLj5yJ0pRCnRA4o10BbzI/
         SkgI5b/eKlv+tZoqiX+9kAu1b2IENd0u35EpR7vio4MyRQcKseSai97ctinTFawtFCm8
         P+6Tr9JKn3zlI2Di/NjO20RjfQowDk0t+FAINgjrMIW89GPIv9/TbAnGW55N1FNzTjwU
         jOJP7AjV9Xbo3AO5/KH2FTucgwZeuU33U6yBn2nAj5zgsSJU+UFxcdgDKOpOJewKSa+v
         H2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781110314; x=1781715114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qO7PcTURECVwaL537JQLmKXQDPG+aZWd6lpbt9X9Cxg=;
        b=FGeqJMo0T2cMMqR4B18ghl4RCvv55lDuHT2qzIf/vsPXnW/soQb0NyrZnZH0kvvMSz
         SOU2/wjt2FfNHJMStzbExHtORdjY+ATNe/mYiINDuKaURvkik0nX8yFoT5yLNFghG2yF
         NmCame9/2sU11SDKmna2S8XfUKtfI4mlgaZ/A2LH8ghzZ9YX7hV7lzFsmoL146kwlEqh
         LqiOwYz1GdJHhMJkOvj+t44udzctxNwo4cKy9GCbrFeJL8aPS7QzZ4fD/5RvxT4YpCQV
         BcIAY+FSGIhZ1WczGcMKs2kAu268dMBJiw3TGneKxI+8F5OhXWW8S28DjwJFQCYObt5v
         QcfQ==
X-Forwarded-Encrypted: i=1; AFNElJ82VEa/v5gvqM1XXjKdmPVXLgK8k19G4KxaWItux9PwNWFENGCd5v5Xz2hfnjTYJsm8eFqbe2PDwQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6Vvvf7OXUrUnDYYYhOPFjH63jULBFl4ZHkRF9G23g7XHPTspu
	lyIDBXu5eTggsYEtwSeN/T7KRswdxQasn0klP/7iUi2yHd2RpXA7WIRxrfGEmsAGOQg=
X-Gm-Gg: Acq92OESep168xSF0kKdlmhuGivywTjZm3waxLrlZZ5ymLgu+t20fOsduuWhllb6fBv
	KGySL121IBUcCper+1VjLSZqPNvGFeiiSQI6AL4QniJoZbvKLwM2grGqC2jlmxXmGH7kK2H3d7B
	7vD+L+qxLDcVKez2rgz9l3YShf8u3zZ59OTLov144o8Rah6lUMElSYR10GLr5qsqpwpPk3TimtV
	tBjmhy+/JtR60BzILY1qJ2qTReNOUGHiWYnZxRcZ9oO9RWwIAhvC5xs7CWcaEfdrCjiQTGpLKS0
	C3JHYSv42KMKLEsTzn1RLLc/zqdkFHn8otJjBsSeaO6rXVzznrV2fK8jjMs1rx3iuTianuWFgXm
	QTr1G5NdSyW0yX9aEyN+zdsbopVnhn0vO7otxsd1wp30EPDTscLgRgg/mpbWt6Thokg2W8gwiPl
	dX4ZZOLS8ipvFBXBbfkvURyUd1Kt8iKO+q
X-Received: by 2002:ac8:5f84:0:b0:517:b58e:a1e4 with SMTP id d75a77b69052e-517b58ea315mr236682201cf.41.1781110313972;
        Wed, 10 Jun 2026 09:51:53 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775e2e16dsm222674371cf.31.2026.06.10.09.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 09:51:53 -0700 (PDT)
Date: Wed, 10 Jun 2026 12:51:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@surriel.com,
	david@kernel.org, baohua@kernel.org, baoquan.he@linux.dev,
	chrisl@kernel.org, kasong@tencent.com, linux-mm@kvack.org,
	shakeel.butt@linux.dev, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from
 readahead
Message-ID: <aimWKLoE_BBFkbE6@cmpxchg.org>
References: <20260608143242.2869392-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608143242.2869392-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 017AB20011
X-Stat-Signature: kx5pfzhgco667i3yze3p6xdiqonhcf8h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781110314-485697
X-HE-Meta: U2FsdGVkX1+VDCH2PiQEr7CeDn+EMALgh7Uv9w90Ig71TdYFvxBll+WBUb8i49yJJjI10zgyQeYbwOt5zb/Sh+JM5s9g651rOwJIiCxYyPP9j+hywknGMTTKU1vNF9tp7zP3tQwE047uJttlXe5vXxGaMX2HbEYke5fdNu14wvfse1ztvIRK7wlzsHoyP+/xQjcVGP9BjCqGRHafQfI++Spewhe/1LVRmZalhsw96erzJIBe6GN7cgLDsmbe3bH1rVm+inhPWMugPymtneY5KdLapnCQ3HtbjHEVleULU1ZoVHMpHC7igJ3+G4O+ozXYayl32KkrCHyNXLvXEHpDCV8p1o4zvkDYkBsCJJ8G0R4GE33oHpI7UYuoaUn+V7ZdYlNTqj9ud6ss6Sp4OTW//cddVVFJI0PEe3jRdFgMJCuIXa3ehOD98bJSf34Sa3H1CI6NqRwBkHJ9hNTBhXyQQnXVL94m5D1lbRDHoGMk9t8tyuCoupxwrvuepSJ2PblVnDZOKtVLcmZornh0P2W+Tbth9i0uhfQPq5hm/n5tP2EtPkoWEmoKYvInKLSdxE3JEboerNqTVtBCDYQIduK9ByUOkBlumrwaKMDQopliHKXJDovj75Udknz0KQYvGmJM7pkNVPTKzg0h56o96GeTjEg+z/a/skdcDuSW/+9qx5xiPDg2704MZcF+sTeKeh8jj7CCgb7mt2jmZnIJSFh+iWYYgR8KjNsyx260A/BZGGwFWuxoxKcEWzoDBntJleAosbTqbc2hljWUIhGTsezlMXFwzF4N3sPj/BYBSAI076vRBI7PJQcSzgBvaic4IqQOWaQZkZWQeQhxnswaSwBQQmAQmVWAiyoT+Aexnb+MkhkK1teP5flLLEWCLOlXkwUuNLNH2PwXvzIob7vGPpsMgFRq1u/3bsc1T2c4iDNz24AULpUJFf1hiInOT73eG/ZGN/gjjFC4WBdqD/G1sUl
 dyLq0WNl
 yCp27e1RvgbRHR5Wyw2TKDdUIpqQntfvaVGq7VYXYpdXCPbk7g83er9TvRefR3CniyQ5f5liUpV8vcLwxeK5+cOj0v+nT6AcmEZY/lMDc8/mGuFwEVqdDgaOSQ7ZsiwM9G8fvdCAlHPUGwzHnG1O3D/CisobA0IOiFjsA5ZHQYuP0esvGDGT09FumhoY+RwE5UmlSl7hoWuj3TLltARchTfCzLYJhSwAC3wsqnz4iwlYWutUW2tf/INodMnr8i4VwwUHJvjRLh4vSuaIOaSCCgwc0/mGbSvB0jIkxc1qAKWPv2e5LDmFc0vy4wgwDRBmAJPPa/ku9jECZyu0rJyGMjIEiUpvzGxa1PwQvwaYKxz0yIPEFdDpe9+he19S3hL98AiaBxl5/W9AkjYF4XByG0Wr1rOTy+mRcaQD2uA/Ur+w+PLWIBdwTK09FCZc064By/kt+rBiPUh8jGw8U/KtqIIczA9m9CNSBthrXLPnzV6J89gxCOI1zXdv8WWMUbxqEyQYQnsngTcI9I1k29CJcM9C7eKeJgzkeKP5L8yfEAgz+t/jtKkyTRP6ccQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 07:32:42AM -0700, Usama Arif wrote:
> swap_cluster_readahead() and swap_vma_readahead() end the readahead
> loop with an explicit lru_add_drain() call. That drain is a leftover
> from 2.6.12 era code and serves no functional purpose for the callers:
> 
> - do_swap_page() ignores LRU residency for the readahead folios;
>   it only needs the target folio it called swapin_readahead() for,
>   and if the write-fault path needs the target folio on the LRU to count
>   references accurately, it runs its own lru_add_drain() at the
>   wp_can_reuse_anon_folio() and do_swap_page() sites.
> 
> - shmem_swapin_cluster() immediately locks the  returned folio, waits
>   for writeback, then operates on it - LRU residency of either the target
>   or the readahead folios is irrelevant.
> 
> - try_to_unuse() likewise locks the folio and calls unuse_pte() without
>   depending on LRU presence.
> 
> Folios newly added to the swap cache by the readahead loop sit in
> the per-CPU LRU folio_batch and will be drained naturally as the
> batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
> lru_add_drain_all() and so on.  The unconditional drain only
> synchronously flushes a partial batch and forces contention on
> lruvec_lock.
> 
> On a 176-CPU production host running a memory-pressured workload, this
> path was observed to call folio_batch_move_lru() from
> swap_cluster_readahead() ~28K/min, a very large source of LRU lock
> traffic.
> 
> This is a direct continuation of the cleanup started in commit
> 1aa43598c03b ("mm: remove unnecessary calls to lru_add_drain") which
> removed the equivalent drain from free_pages_and_swap_cache() with
> the same rationale. A detailed reasoning for this is present in [1].
> 
> Remove both drains.
> 
> [1] https://lore.kernel.org/all/dca2824e8e88e826c6b260a831d79089b5b9c79d.camel@surriel.com/T/#u
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

