Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E50CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471389001DA; Thu, 14 Aug 2025 16:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421BF9001D5; Thu, 14 Aug 2025 16:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366C39001DA; Thu, 14 Aug 2025 16:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21E0F9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:12:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2DEE1DDC40
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:12:18 +0000 (UTC)
X-FDA: 83776459956.06.45BD376
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id D2B0318000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:12:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=IdojiDFq;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202337; a=rsa-sha256;
	cv=none;
	b=l2JbzMuVMgdT8QIBypXyXw0i+hGxCrjYl91sXEujl9ePewGjg1NwirsLQ53IoR/jO7ckP6
	zRkp3efmR3ppmvO2xBissnHP/FOJYXbG2WHbRjrR/oyI6qBgvAfv8jOnEq1a4FFbejLO5X
	za1tc+II41RSgirypFqkWwpj4TzM5V0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=IdojiDFq;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxzbcrq7nK91VwgR31UC0slmrQGlL/0X3fwR0ytXvYk=;
	b=yxRjfjerdn4n617x9x6wnlCWmOTeoDSidHSY8HSrMrHZHES+gJwE6Q3x5Nwis4ULlHzUcf
	HsUWBrw7CTbV97aDJHkQf/Bs2Uvcvk/D85NYmJtwK9cAhdvOdO9doqS/sKUStozPeozOU9
	8HvNEna/H9Lo65Rcph+PsICY5PjfWSw=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b10957f506so18191601cf.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755202336; x=1755807136; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vxzbcrq7nK91VwgR31UC0slmrQGlL/0X3fwR0ytXvYk=;
        b=IdojiDFqnW2JGdewu0lpHNvh69b++PNltmrr8DUxbGGbAv1ye25WQ1XKqzq1EvKiSo
         eZ8egzm7rxiqQJZ1mi4QC+zKtF3lImhLknyl3JEGrflhHemrARn6xScI579Oan08NaqE
         gKxNRuChBkM9A0jxt6X3zrfQxuwt2tKf3IqJFsqKx09zde2/l2/uMHjmBaS/zi98MsjS
         aedWFkwDAeByF36jD2mOpc9Zk/dgjFXoF7MiqHdqxvlI/hjKbCFGLSCgdTKSM7ahgHlm
         jhQtu6DSAvrAIbdoG+T01Kk+zz4hBpj1MkrWXBCuXknxrAPuPBOqFWo/DnDr1uX6YpV9
         vaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202336; x=1755807136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxzbcrq7nK91VwgR31UC0slmrQGlL/0X3fwR0ytXvYk=;
        b=BGHp4Q6Wrkv0wr0/ZpsJ3O3NBPqTxq3xhK1vRmdGJ8J/Qy76XMpCNNSR8t+k3WTOUy
         UpQUfgYRdURqcpg0WCB7YIZJYjGvuWnW06qpx1C7K4C2qFkaUhWn37DmJSQN/1rtybip
         /3pvaugLaxKhRmOM2kA03alu7Sj+4tVHloVS4bA7wacC/Ukqudn0dS71RbcxwPJ/i1fy
         nkWX99C6hDX13e9xsPWYXNm7pwCSePNWggoq9wViPC9eTTMW1SFQI4L8khLzjsqIQmrH
         nDeZb4clea0eldP6FdWVmc8RSlnEQdcKvdj32+cikNLtbfnCFcJdcQY10NvM0hZdjxUT
         YA+g==
X-Forwarded-Encrypted: i=1; AJvYcCUK+v1lIHnMnLIURSTK/VBbQcm3mSLCnETMDi0XUBf6/bYqU6DGiRFvVOMnm0GwTUd7iqqaYpbdzQ==@kvack.org
X-Gm-Message-State: AOJu0YwUyw2JbVuDHGv97OZtQztu/lPjuHJhtQURwWfot/kJUQ7RGYHX
	EW0bVFmgWEZpXoGK+MNk92eF2B1nDGo5gruEoo1OSryyJKLojKVXwvJaMXz9ohJDEJI=
X-Gm-Gg: ASbGncsb3enV9q8vE9KUM6b5ZxyVF1Gbtt60vTanHimrn4mbDSp7TZr04m8EPHBYgtt
	VA/pJhvgbtfXdVr3hdn+88wnIIFwa14PHqZJnmTky5s9To/1cnMZoex/iJD28UZEmnXv04Mrdmc
	XSUc0j2x+kDhiAr5APVSLhqm5Yc5Au0JJ7G4A7X2oJtoRZUgxLh7HJ4Er6Ffz3LieJM9ur6InB5
	hZp34WpRL9eL8yoIKwbmFTmCSu5enDJUh/5EoVH+Mh/9lP4kTuGFXZCbMXmGdrLPWLwr/x5mm6P
	webtQHVbDC3XJjey0K6ypaBlG8LAQuG67ae9bflVzOL22AGsiM/iu1R/78J8Fah+1+e8bCZcnwb
	SffaWckqhFlIr0II/xVPzTSSOF4X/aBro
X-Google-Smtp-Source: AGHT+IHGbf38wjASlzpdG8s8MvlkeKwc6OkOeZzYzGmyvaBvUc5P6M+am5GJahVd5Ex2+2MRB/ryEA==
X-Received: by 2002:a05:622a:248c:b0:4b0:8a29:b5c with SMTP id d75a77b69052e-4b10fbf3e00mr47146221cf.2.1755202335629;
        Thu, 14 Aug 2025 13:12:15 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b11a87ab86sm1040601cf.5.2025.08.14.13.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 13:12:15 -0700 (PDT)
Date: Thu, 14 Aug 2025 16:12:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>, kernel-dev@igalia.com,
	Helen Koike <koike@igalia.com>,
	Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
Message-ID: <20250814201211.GI115258@cmpxchg.org>
References: <20250814172245.1259625-1-cascardo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814172245.1259625-1-cascardo@igalia.com>
X-Rspamd-Queue-Id: D2B0318000D
X-Stat-Signature: unxrsr9sm4dzf5c5wt7by63r5n9tigby
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755202336-399247
X-HE-Meta: U2FsdGVkX181eHT4Xo/6cU2/osANwmAtVHKlAxjzeLlCqSUDjgaYDUIBJ0muxCcPqDrV5BPAwW/egfdrL8Bvb2aqinStZiNkCgmoshUX35zhXcjcnd8lltVJRtXesYLw/en48vu4NIkjgwfDhnfDiibFB8JUoKGbQRzMWU64XfGQ1uuOiRanA3rst48WXlzAuwuAB6wQvvyvqGR2/1VEo7Fx8Cpli6fhOYUTFP2iDf4+rMh8ZLloGPQX26EzgeHLxXmBEVSztTTDxkV51K3blukDZTjyrIt9ZXoGx45x9hyXLol2/RyEBozJeEFqgx9ebiUmcrrDKel9YjmmRW4ycj71TGoILlhqe9pV4XjXIuecHfAMVM+OgifjLRrPbv1zndbQAcufXUkcMOsdUfHPtXAAUXW2rfBOoJF+QW8ZaL6FW22bhMm0TdQkNnrS3U8DDKD2kz4UZzjDlfe9KB0DVe20h/qSSCd9HNFsRXPlSUtfhS9LZcerYrcGCfjUoVIBKkplgSUrtKpSPbeDn4qgQFU2zsR7HOmRLY1wzAjlnxeeUgFO4jGrJS8MB20OInPXXuC4XQ5Q5GD8oGIJCRgzZDlL6D+i2TQLq9ZI9iIejKUCRA4AtRVUH6VZPPu+CkNGyB9bsGr/Fc8+xaxNfTXP+vK3MHEVSJWxAgubmBzEpJe1A26WnlDKY2dgQW3SZZzYgs/U8Fop99TwQpED1RG5Kvax+zdZ/LjwBuEJ8xBElaeWUHhFCukKbA1U0BRok2xShDpSDiV6vEqFEfn9jAj8w23F7loZ5cFjazOMUzOnL4ydNvfXc4p6jzkmZgE98KvjuZigj32MqOINe+Q9vTxZsjkc5+/2e+Hns7OkE5n/LMBl6iHqu+OBhfdfdn9oFTJ2MGIQjwWZ5pWk+nPIgj8aKEIxjVYgVT/ALFKJ1Fl59Mb/CU/cFxQ15gQGyfsPyqtjseSBJNGOBnqbKY6BfqO
 W66CiJ7j
 0hoJZpsK1hR+X2EgEYtMzLSLzxwpp5+bThBbZACG026tkxf9vS6lCAWpTsnKRs75u8brj/9Wrl3yBfNR/aUTSNXE+wYN22RdKrPn4LQqKGrND67iADFeREMEdn8qQoYpfdCHkndl6vmUy4WTqDJsBMQXv7GzDabGdVeAkRAO8QTI/J06qrHJUHaCDGqhB5RbJ9tjY4IKDxKUkgEtUkf080byo4S84NYyRq/Zu/2xxmPmk17jRWKnmrmGwH39J9RVFQk1OnRw3VJKgVshaiubKGKydLTq+YywSWx86qY5GsmOj+pNfpxqCztuyctlyUbFy/NmBg9uvii8JS2EiM9ov30ucUniwqRS+ZP0vx01D1G07rW+RF+H6G5otw3MNuiEWPxVCs5wjA9+bpEtpOBLQSffzD/Gn950BbTaVWxGcRykoAkMTY6FEHrXdbHKtCwOljFLLBi7LAo/BOuGXKBt9GmxoJeG/iSEpvouG4Faw5MU246NlVeYRd2kDsJp6lld6+rG/vcmJrSpILjKXKl89yIOkiej4re1fwbijV+0F/MHwsEOeEzIZO2eh5l2sFSOAgKfoxr7S35f6LRExR/qjiiVLVK4PVvoaibOL8IAHs+XZG/g43mnN785bDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Thadeu,

On Thu, Aug 14, 2025 at 02:22:45PM -0300, Thadeu Lima de Souza Cascardo wrote:
> Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
> ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
> which implies ALLOC_MIN_RESERVE, is going to be used instead of
> __GFP_ATOMIC for high atomic reserves.
> 
> Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
> allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
> allocations of order higher than 0. It still used __GFP_ATOMIC, though.
> 
> Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") just turned that check for
> !__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were expected to
> test for __GFP_HIGH.

It indeed looks accidental. From the cover letter,

    High-order atomic allocations are explicitly handled with the caveat that
    no __GFP_ATOMIC flag means that any high-order allocation that specifies
    GFP_HIGH and cannot enter direct reclaim will be treated as if it was
    GFP_ATOMIC.

it sounds like the intent was what your patch does, and not to extend
those privileges to anybody who is !gfp_direct_reclaim.

> This leads to high atomic reserves being added for high-order GFP_NOWAIT
> allocations and others that clear __GFP_DIRECT_RECLAIM, which is
> unexpected. Later, those reserves lead to 0-order allocations going to the
> slow path and starting reclaim.

Can you please provide more background on the workload and the
environment in which you observed this?

Which GFP_NOWAIT requests you saw participating in the reserves etc.

I would feel better with Mel or Vlastimil chiming in as well, but your
fix looks correct to me.

