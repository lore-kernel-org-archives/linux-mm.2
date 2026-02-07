Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE74EE0AF3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 20:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708656B0092; Sat,  7 Feb 2026 15:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE666B0093; Sat,  7 Feb 2026 15:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8386B0096; Sat,  7 Feb 2026 15:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 502AB6B0092
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:20:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0A81B99A2
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 20:20:09 +0000 (UTC)
X-FDA: 84418777338.25.4EB5172
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 17FE5100009
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 20:20:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J0yJTLbw;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770495608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CLN/nBgZu1TXV2x2w92nD7nqppwuTNa2tEtzd/B9Hg=;
	b=Agd/atIxr3ufqaqLywTwR4voDR+Xo+wFW0pHNrFXqflKP/3NXptHMMDbcBeBPsA2mjbqPV
	QVbWKT3gJhH6oF851NMrf4Qe1oXN3sZ4h3dbgluqudpUDIcfi329hNHetd3jOxQ87rJzrM
	Jg1ZFtlUmlD1L9El+TCXo7GZzp7vCa4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J0yJTLbw;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770495608; a=rsa-sha256;
	cv=none;
	b=ju1ALFhTXZuRV3/txXerTKlZxG4R2M8hpfRelALaW76mu6hz7H5/IpGAZ6lLeyXHkyAp2P
	0+twZj6XkBA3N+XlGa3J/fIUcg6gOnzwe4+mXY1N6NxcdUrbQUC6PitqpdsKgp641haXhm
	LGxIDS2klFoV4PvKLELcO/hz29hCTH8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4833115090dso4632425e9.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 12:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770495607; x=1771100407; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2CLN/nBgZu1TXV2x2w92nD7nqppwuTNa2tEtzd/B9Hg=;
        b=J0yJTLbwwCU5/wrhGuGKCkWjBeZd0a4i2dQdxuS5B6JqWsFduid0IC3Bh4ajMurBCN
         C54awTMozt6eqJkHXDUww6f/jn53BhMUZPyOWSynozgYDDpuz8LDH5TQ1/V6geNL++WI
         8fUs2eN4tZ+Rt1+CNPWQ3HN+TlVthnW6PEY3KmWk8oD6pfPLviq+cZkxPiHiWO6lLilU
         PGMBhqP0zAFr4OZe9puTNmU1qOPrIOMD/p4fNNhBLxjtk3+zA+EO5zZraBry6R8VEhgg
         51+J9dFhmlWu8YlutfDynjmSGDZEqAkpZ9LKm1ouIlurejPbwWz3AwvbEL+OvgtqXY2S
         vPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770495607; x=1771100407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2CLN/nBgZu1TXV2x2w92nD7nqppwuTNa2tEtzd/B9Hg=;
        b=alcEwqiTbOWOGTrv4K8ztfSZQlWg8NnLfyEdo+7t1/O/UvcUq4+CnHd4SN41NgrVy0
         /ygYO15RgMkiBQ08SG8WKPTLr2FhibDO17nHvyBFurJXTQfpwvunf4Td11FS56OvJz/d
         zq6Jthvlu8mP7PsZRQj2QVJA/+CvXuC4lRKPIqy+BRRAfeYKyc+1o4MqfnC04EmAtztD
         R2gA9JRvNWx3waXtoxqLFxGA37LL/yl+eSSauyguNspw8lftvUk1WQrJiQ8IQ8j+S192
         SN8YUlHQiAuaab6elJ45bkMmOki5JXA0Bq+BrUc97CueLfj01OR7jPt+xpT2+cAk8Kzm
         FWIg==
X-Forwarded-Encrypted: i=1; AJvYcCUcfaiZUsL5L3giQcyQFTbn4hjeBqHOKNIsrchZI1B9n+88GR8J//JB6oaGQcovCYAs/XaBbRPlQQ==@kvack.org
X-Gm-Message-State: AOJu0YyBoTLDpybQRsjLZBoZzx9zcgWCIkbcmW9ABg0ScNKD9VORo51Y
	w1Ddgm88rzCfyjEDroOJ46esjr/ie5qiUTONknt29sPbmifZX++EgjG7
X-Gm-Gg: AZuq6aLYY7KbXkpVi6Oohxo7CiXQouORDLA6JokE7wGcp97WoHgWRQXn4HXiosiwWup
	1fmYwCkRSIOFEFOv2VU28qziaoDH5pWZk5IqTaQ3+A4mpSFvzr/lKQwrlTV7dQIg0lzEtK1N5dS
	VXpoiACEsQhpI9KNwQmCRU0Jwa44QJq/sil6o1w34Vw1VMEfeDDwLOzrBCWqeJpDO1cEKdQyJQs
	dh1X4gsIPQbnEJ+hKm7ZO64A1Xj3bYVVDPejOUmR9qKjgYOFhzXCrbyD34WJ6x0enoDKdH4Su9v
	F7rUEzhBuEwvpg9Q+o9cXLYaRNpYh5XXrR4xpQRGRFF6SoC8JD4ENqR0kdZPR+XGaBguBnG1fxK
	O6gB69RRxcEpV0Ng32qIr7GxbX08Qq9SXujXzZHV7t8XNHcZaBBRDSk2Mnn7BFIIwRsuf9DO7Cl
	8zcrOjpc3Sb+MEBiP7L9KgbJ7rWX3fEG442iFwkwUD/HBddy1LGbVcemhZUd0SQssDPkWzYxO1p
	9Urk02ZsC/ejYY=
X-Received: by 2002:a05:600c:548d:b0:480:7162:fa48 with SMTP id 5b1f17b1804b1-483201ecd90mr108547085e9.13.1770495606497;
        Sat, 07 Feb 2026 12:20:06 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:9400:18cf:c773:ee86:c436? ([2a02:6b6f:e752:9400:18cf:c773:ee86:c436])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483209cfd77sm51750705e9.14.2026.02.07.12.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 12:20:05 -0800 (PST)
Message-ID: <f4e66e8d-d285-4362-8bc9-fef00f2f624d@gmail.com>
Date: Sat, 7 Feb 2026 20:20:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 01/17] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-2-kas@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20260202155634.650837-2-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8atpxnneb11ohfistrax6x9ze6htqoaw
X-Rspamd-Queue-Id: 17FE5100009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770495607-703772
X-HE-Meta: U2FsdGVkX19DsQEqgzDCs47L2pkhxPyDtW289Q/X9p7WBoVQgX4BrPO7r6kFvEiYhq+todX2hTUX+Zbd9LufB+08yTCaLt1ll8NJ+3sBbcLx73RW97X48m1vbTMoL/w/lcpdWXsGE5dnUS6KxVECRAf/+7xP7oTEORGNWFT4KTsFMtZ3dJkFkMzlje5Rc8KhPgKcrNn8GxSnQtRVvIl8+wd1mAeh+lqfUpUaiQlYM4ZzK0nWDtlZXDRKp3+gRaP8j+HP+ZKPbD9NoBk+l0nFkXd7gL2Dqy5JSyXOCtd3F3SFlpsPfgwgf0R5L9Eqez6aljdWclf2jN2QHQO0t80Djq2SRtTIVz6VCsT6ack+GQl1x5gq7V9ozeorYDx84MhrO/le+e+/O47n/eOKzstGn3Q4BOyNCtYGeu0BstHqFDuV746NnM8QP//gwS6xdkBqobG/Rgr2x8eX0ITyVQ5rqMKwFCAibkb1FDlLEo8LU6FV/5ODcs9BTe2abKyzaKEv/UOHn8daJeqCBPbAed1vRQjx02AdOOT2ckJu9ZhU/B6FsgB/a/CVvZ90stG4D+z8YoT8BkOiVp0pOk3iF8hK0j/BXpupSvUaaOjpAHubHLdhBjWhiJQP8TGDc/hZZFKcf83PDDJzjyACTTwz08h2//zH1cQ7vu61vA5Rpkqrb/aVGpy6a2oDs743jqvS6eVjM4FC5XM93YYJj7tbMXaYDsTyhgXV+GHvA8OTCSSwRAuKJs2vaNJM7a3B010el+0pakWq+SJuB5aQKajU8qaWExzEZ8zoBGW/6fopqhs4xAhVOSCvK74Iqlo3qMBrKVjHQbbgOkx5P7fx9MCO45EFsSaGcl+nshIdqE3v5PNT+3RWKqN6wM/qY7h5rQCKqh0vjxMXXfaiWgo6AmUDbqrTxky0udNLN/KcWcYI28BdCWGvaGhUxwQHWfBAZlK1Ks67hS/4ZPh4JoNzYvI+KFS
 PczAtSGp
 gLApnvRx3ybpUNgNWdK5t/hiUj9fp/NYgpM7S2+DcjyqNKx+02fGhaNiUyTDxjuoJYTN16HZm8E9MRw6647OP9i/zxx+DbPI/ZHkeuHlidm3Rjlw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/02/2026 15:56, Kiryl Shutsemau wrote:
> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
> 
> This is preparation for adding the vmemmap_tails array to struct
> pglist_data, which requires MAX_FOLIO_ORDER to be available in mmzone.h.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>

Acked-by: Usama Arif <usamaarif642@gmail.com>

