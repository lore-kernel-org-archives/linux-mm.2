Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279AEC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EB46B008C; Wed, 15 Jul 2026 10:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1755D6B0098; Wed, 15 Jul 2026 10:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3066B009D; Wed, 15 Jul 2026 10:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0CBF6B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:00:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C4188013C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:00:53 +0000 (UTC)
X-FDA: 84991171986.20.A1E6009
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id A47BE18000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:00:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=H7oIxqye;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784124051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqH9gBKIbRjL89vi05p9Hog3cwkQA8VspLKF8/hJCJs=;
	b=e+vPPtJm+BLOyJWKwMR23pBDHB+TkTX0fiiQTTBJecMYFFu+WzLfkxBbTk+uG3gimozOWz
	RA3Kwwp1hg9w84PEFkVHl/iqynXE0wcDr1d4nwmOKWYqkU2kprV9KRlOW3qizx6wwIY1aL
	dKvR9fmktNLeOsQ+84dyI6qpy+07W/I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=H7oIxqye;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784124051;
	b=rbFpOb5jcQm9Kwt0o6XDwVWzfqAwVOYYv0HOQU5PBLYxEzdU3JHk/BjX+Nr0kNDBaHI6RK
	x26YRKMTP5Z5XGCQGlrh2ro9vRdxc/2EOL+ZhJc2cHmCHLeEZTjTLFLDTcibAl61R7mX/X
	oM7p/y1R/JfwkKE5rw8aRdOetDa/cq8=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f36a122fdso2384169f8f.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784124049; x=1784728849; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NqH9gBKIbRjL89vi05p9Hog3cwkQA8VspLKF8/hJCJs=;
        b=H7oIxqye0kTflKxF/QI//02XUa4Gimmc7doecg9UkTVRCw1t7chqsSJGJfPBGSBep4
         v4TxQhBot+6zq37u4AbyentDfpzgO01AOT/akPT5VesstJrlOUWuFVDTYf16VJgjK73z
         rPSUHMmHM/pnYWpQso+9nkfjhaahBY7ddhQF3950yxIPTnQixlthdyH6E4quBg+vCa+y
         waEvsJ0BSSBJd5f3ob1dZKGRAPCe1aSfrB+P/+j8JXlnPeP+iamkJo7wuepAHThIFQ5k
         /cc+74Rc2vvOjCnKQg3USyJN8FLkEenbMY8aaY3na1aoHdbT5qxO1tWS5nLR6J/XU8Jp
         sJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784124049; x=1784728849;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NqH9gBKIbRjL89vi05p9Hog3cwkQA8VspLKF8/hJCJs=;
        b=lEVijL07zj/5QsbeuTiLY/pgblMT0/OzvpO4d0e7U6XHfsCU2Xi9EXczz2VRtuaOib
         Jw42pmuHuKA1hyUfnATv/CWrRlKiUGZA47MqUWKNj4g4k8TK0VvSS+joJq46cBqAdG0m
         nyKiqht5U8UuFi99bAoJWC+tlb557oQY4zLfWglkFYJoguDv0CFSwh+ZHv0x13fM9843
         VB7FarMKog+LRfbOQTFK3V+kZywyjOfSVs4RimaRCahmUMyYeuJDlqFGzC0fd5DbWCId
         67ISeXUS26TSRfyTAsR23r9kpkgN9m8Gct/p8jLxXtkuiwz10CB0iv56giOG+yHiwDWw
         ZWmQ==
X-Forwarded-Encrypted: i=1; AHgh+RpyUIQskuNi6DMB2xk4FyG6YkZzx2CfCld4mxViJ4SM0Ufv4ts/BWkKKZ5URSceOomq4ke9PWdJPQ==@kvack.org
X-Gm-Message-State: AOJu0Yy45vVyR4IjL2e7BFRsSSgzWq7f/z2AtFiCnqbIbre+/jw7gzV1
	tc4/QkRS2cMGccd6xYbKMRxGwC1U7wr0nuaqSPaTRqvzryb6j3tQyQRWvuqhwjb+0VM=
X-Gm-Gg: AfdE7clDvHfIlUR9ki7lvOv1x2QcLFle8vNErSfXVcBHIVoIqIoK/Za+kw8jy/Qvl9D
	Wkifii6X5etKol+xEWzG8MS62SkjhG2CAgUpq3YrlmOHNoLBIup1Ybae5C/A9X956cQ1NKLfw4B
	clUiKkpCM3zP34MYg/dL1Uj8OwCKFx4N38gb7331KL6jGmAVRKz/OSg5g3b5c7/g5nfcGUJuIKz
	DsjdXn/q8ChDwqswC6jq2iGI5qHMk3Q1cXWrmizFjWIYggaP5yahgQgEQtBHHkvC7VET3ImnYYY
	LIAsuNlwjQa0rSo17NW6IFBLyGQoE6fNqUgc2geLdMgcqdp6cLrnVb9VZ2qYDQYNKqvmGQZJ8YV
	wFatpOT46cEApHJ1ZJ8tKe/gRfNnUBLcPFtE6YOCg/rZgUD/GhrgWr8Cc6Ci5BjYf/ePTsPmhe5
	oyxvGVTslyWYpVZA==
X-Received: by 2002:a5d:64eb:0:b0:472:d154:facf with SMTP id ffacd0b85a97d-47f2dd2bd5fmr22313384f8f.42.1784124048779;
        Wed, 15 Jul 2026 07:00:48 -0700 (PDT)
Received: from localhost ([2a02:8071:8280:d6e0:1353:8eb8:c84a:b6d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a9879sm17535061f8f.22.2026.07.15.07.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:00:48 -0700 (PDT)
Date: Wed, 15 Jul 2026 16:00:46 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, yuanchu@google.com, tj@kernel.org,
	mkoutny@suse.com, corbet@lwn.net, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
	axelrasmussen@google.com, weixugc@google.com, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	willy@infradead.org, denghaojie@honor.com, baoquan.he@linux.dev,
	kaleshsingh@google.com, tjmercier@google.com, tao.wangtao@honor.com,
	zhangji1@honor.com, wangzhen5@honor.com
Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
Message-ID: <20260715140046.GO276793@cmpxchg.org>
References: <20260714121529.2237261-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A47BE18000B
X-Stat-Signature: m9k5p5faqtfwrz3guaq14au51u3ruuzd
X-HE-Tag: 1784124050-298217
X-HE-Meta: U2FsdGVkX1+pwg++IYfZ/B2Q3COJSxpIvtJhCEhoHY0ElG3POt12QY8GG2Ds8F5KgOOSa/D/oZ3UE6mkXFZVoon1hGj6rDwybPGD6hHy79zDoWufKC348hxgUDGGhdKt9YzqgymnYW0+57tYuF8jdF0/1NuJ8oJPjgsjpOHm5D3LTNuA7bEoDnUKcR+hFjcS/lBWY9ZpmAJiqY700ED55NNJIefFxELIq6qSyRrOAbVGprf36aHNT4mbqlbdrb4ORJAOj5vIIZXca4nbaonwkARnfJvNKXedZr2dIu1bvebQj4K3G95kvsiCFkt95kaCU18t3hpl5hm20argz5lZWVbasgdnRSfh9NXPCCvWh3E2+0x1s0TbPt09823v1H/aY+DuUCiSStYmhfJn9pNv0NQ2Tdp6Skg/vPdA9lVToKqhSbwhNwCzkFUT0+uMnBjCY4de2QDG9sBoZ9ciYlHqbKbRBCLePB072QzHZvXFthP+rpiB9xRQnNMxLQJURdmu7oks6oH+Vkkvg6ABkFovBl/csWCVqGfrPLWAc3YfTvtDtPSiRd52ZrpWfR8L8fjKdPK+BCODYqQ0livnep9uIC+nXxrkVpnCArJrbjPC3PafOFfL0Ub96yWe0o7oaHmvPeguj497hVZv9wCDodFeWaHmYtOG+Ss4qtvVYSPNUNioG0/9m0yGcN0GMu38LmProMOxFIsWikF1zj3ve5QxO+rBSBQnaYW/EfItG5akCjntYVsIIs2f57JB1/w/FNOYj33vLNTL/LsqMdKoTH9vNb7X/B2CQn224yv9EkrC5UETEexCsk32s7bBjsafdIoEpBHlZTnuEfZF9pC+SNB0bP8Nd7T7AwDaHfZQ5HpDZrD8dGFv8Pg+XEzUXCRmQtSz4DwlCnEN1YHhFvDGXVBIaUJxZo2LGgd1EF4eMFGvsN9nMfHZGPQWlBc1aPuRWq25ljy8zA2R2AsBSCO4JrM
 Sw4H/xse
 CekFh12es9fdCMrxl5nZWJM8imRoANyU0/pFo0CvJkB8SVJgCmTFt819d6QQabYMlY99WNslAKkJSTKslxZsn+CV0uu6MXVk0xmd0YjX4xwwgg8ZvhlA4+YjKuzgHPnksxe3VnabJmBwxeo7dCWUaiFGr5nvi7YThfsgrR4+vm932KWeBEAsujcmRVoZMOqOnc9gzcrNMsJ2/vQurZ8pvRPW/CMB2PcpdffIyJmx/BYTrUc8/g9R3et01ooBD+BOXnN6+YGL0Fen7lCYvB+YbW1yrU/MJWlL/TJK+kwbdiBoYfnWguBYpDfMFPv1u8Mkh31N/3g9lwEPjJmh0MKawW1mnswgwTYednnxeGumIslFXdP/HUgWoesQOMQl6AcWd7F4WvtZoFNkUESGwKxhzpdsnPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 08:15:26PM +0800, Zicheng Wang wrote:
> MGLRU inverts the reclaim order when anonymous memory is faulted in
> bulk: anonymous pages sit in the young generations while file pages
> sit in the oldest two, so reclaim evicts hot file pages before cold
> anonymous pages.

An aging inversion in the reclaim algorithm seems like an exceedingly
poor justification for a userspace interface to work around them.

