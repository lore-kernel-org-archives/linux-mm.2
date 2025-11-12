Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E616CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 12:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642718E0009; Wed, 12 Nov 2025 07:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F22B8E0003; Wed, 12 Nov 2025 07:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E18C8E0009; Wed, 12 Nov 2025 07:06:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 357828E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:06:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C68991404B9
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:06:42 +0000 (UTC)
X-FDA: 84101828244.22.6A16793
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id E91A940006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:06:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KydVqB5M;
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762949200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Rww5lSkbQz1qI6uXNS0kAognCF8JsETbZNPHP3L3TE=;
	b=Gq8lD9DFUcwH7eVN2IGbJ2gFk2Pi3ti9lWKwOUIPTZPul/2MWIXN8hxoAJd/Lb/5UNrJVI
	gKM2r/46sjXSnD3RHjgWvsQM6E68SecwnTXZjL2erTebibPQQOV3JO2KE1IQlF9u5QCd+x
	oxaJfFkAzXVf8uIbfd2oElI6KUIOIHA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KydVqB5M;
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762949200; a=rsa-sha256;
	cv=none;
	b=rAP0yzZHikW1NbivIfbW/cxB9CaBi8lPdkmT3+2vXbxH7i0ChtJxHtxssxytzX97Yf+qwD
	verE39ahjdU1dyrn67xdmlsZLxHCD997tOPcTWlmoYAP3Y7VQolPsi1FQ0IMC+Tv2mAM0x
	VLViYsN/kOMCYMKqtcsKOnOCQnC9gls=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63e16fbdd50so710101d50.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762949200; x=1763554000; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Rww5lSkbQz1qI6uXNS0kAognCF8JsETbZNPHP3L3TE=;
        b=KydVqB5MuPkdV9RD3UDwVnGBchDEj/xavZGOkeWP5eONcjf167xgOPrWqjbU3+pJWe
         cfy3RIiFbXsoNNTlcu9AI1w13cAkQdva+3San9WRy+6U/6lyMcKP3CCsvgspcKNINLFJ
         UA50UYDDvLZbwLAu0r02U0aXcmg4iWytI9p8yCfhgBkJSmuPi7uAUwXLP6j3nKRw8Avo
         XI5hWtJffWyLZBDk7T7huzAbWdTo4JAQ3mbcoPksVRtx1Sh4p7+INx1r1mKgFTg3+1LB
         h/xEa98pcQRJ6z5PJCa/ytXASq7g2BvXCTXHm4/aQ9bUrPF2N40x3IydJzb4NUTrDFlD
         wm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762949200; x=1763554000;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Rww5lSkbQz1qI6uXNS0kAognCF8JsETbZNPHP3L3TE=;
        b=iEOL3hJcg6X6TlQ1kB+f+Z7vT8oEA01EVOq+2ghc19009E7MedrGCBmHdbs+V/+gjK
         ShnmB2Va+B4JIQ8YYsWurlYP0BxWwYVoOlR1Y4hN5PJRaFMEZ+ZpaXbTdiLrp4FfNRF9
         9NO67UfHV33sosvVr/ewoitrKSGt+ogeJUH1JpVhanAUFC8Erol7ZCo/YEIhKwCuZldr
         Y70gT0Qfvmc6a/qVvTm29Mtt/MWL7DIeFyyWst+X0jazcNAQtixFCK+whrpJW6P7M04w
         spD/joa2agAPUog8iX/zuUVIJSplznf2E3Xfk5q8wlSbIEai7qOex6nqr2OPBuHlMxb3
         0dSg==
X-Forwarded-Encrypted: i=1; AJvYcCW/M87OVR/xPQuo5KqcE0S2YKCIV+0fgFEs8PQX7Xs65SzvjlQcrbu2e4KCVhQ7IJZH8MOOVmcokQ==@kvack.org
X-Gm-Message-State: AOJu0Yz/ej/chD7alvEx2dnJuho/5IRZIQ2CaKsS/MzfwPb4riYeW3i6
	Kyg6wIoYRQWQ1aooqWSxpOytFl+lgg4rX/J/pv7Vw8exGRepyDhG8ukRtYnJVn6sxxPFEJUJRKn
	2+NIcMFuvbFMOCpV9D9lZYcBSuxC/TUc=
X-Gm-Gg: ASbGnctVk5N0BwFlWeCyaBihqDP3HL/OyQ80NuRUfOJejPDBjYOHGvlHIyRb0r6eFE5
	7D03PmSojI4kljD4YzhPt59/YRJnyoS9kMuiSTc17X5wAzGQnUBIXdqUdATSKHusido6NgHm8fT
	Az0HZtPLBSuvbBcknZh4GGfOX9GdaGlFfPLiCYEkRTwMe8GXdXYH5rRorq8FjTO9lKr+Z6Z2PjY
	IBUxEza6WbvZM5Q9HI5dzqRB9U9x4xi8C2u9ETbPj6SAKbX6bWEE5WvTeK6nIOhs9OhPDk21A35
	MVv8295c+z8grEmXiw==
X-Google-Smtp-Source: AGHT+IE7oaQsaKznBzR8Ac3oK5FOFEcMdzAJjty5XgkozUB4aq/OhhvGTu5ZMJmYxWQI93r5GpFTb5jZk1VXVRkkkMM=
X-Received: by 2002:a05:690e:434d:b0:640:dda6:e957 with SMTP id
 956f58d0204a3-64101af01d4mr1785386d50.36.1762949199923; Wed, 12 Nov 2025
 04:06:39 -0800 (PST)
MIME-Version: 1.0
References: <20251112031631.2315651-1-kartikey406@gmail.com>
 <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com> <aRRPvn4DYAhuGtq3@localhost.localdomain>
 <6a63dbb8-58f7-4511-8090-18a58c3206d8@kernel.org> <aRR2AV7_R20i4qi8@localhost.localdomain>
In-Reply-To: <aRR2AV7_R20i4qi8@localhost.localdomain>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 12 Nov 2025 17:36:27 +0530
X-Gm-Features: AWmQ_bnxqCiaWnCHRpe1E-k3cnJAWJ5GNfV5Yy_j0wQtY7Eb4hK9FmpxM7a2drs
Message-ID: <CADhLXY6keq6+0NY_=xiugguHNFGpFGc07ePWbiTTFU3qO534rg@mail.gmail.com>
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
To: Oscar Salvador <osalvador@suse.de>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E91A940006
X-Stat-Signature: md35m7r1nmbg7yhg7mu3d5fta96f48n6
X-Rspam-User: 
X-HE-Tag: 1762949200-594068
X-HE-Meta: U2FsdGVkX1+6v7WwO7V6QAZCvsXVEYYacfa0yYzRn3RT5iDiq50wdNBbZ2shVx1eobUe2lCW2Bin0WPWnCsMVkcljbKrvwpwM7AwjJudImJliFTG0/wIGpGarSyv1T4ncO7AOduYtt+iZkh+ikW+O7AV15OhznUQCOwhVKG56i2LP9kW4vU7PSD6d6dLr2emBNupw25LEZo3sZ+8HEzRR3h8O8TduVQbQWyUYFr4CDIZ//10gBkHYxbYXErjKxh20qOWr4BQ4LoRsrOzaVthr+cdedWfNW+tUHFX6mTTJQvDRQEcttwNuYC3ugIvj7vcBmNsm/OL2RFakiOwZ9R2wvDKliWd8ApcP5YZJEkGrxs+pNYXgsyJTtq41Dyt6SunaAFnYFKt3VY2lAb6+rKoijfIWw81e6SHwAiS0agjJaRhgikV9m6Q4+uFRXdCVfRrOEjoELlCltyeFYgjlPp6fvUzfPO5a3Z9xAmAmJkjzo62wmV0pFDtivptDg6P/vU+G4lNOBa6SUjljX7qwCpODnSi9JL8naCvxcUQ9lBNyB36uHe+BqfGZnAR7/hjlQxizRQTLQjZTW/mzdXKQrt0m3Z59qI0Y8cdx+6e/9jCc2VVSEEFYMY/LtWxM9deQyTb7LWxw0qxhDUKrQbb+CXV/CDDjg7Lrph7TJxkIVTGTEegLLA3xCwl4prQw8hQey23FsKkEv0lsNLKYtvwQCwJrsQC/StaJHmFx46yLGhWYO9P20KoQ2kv46QM4VbTJusGaK1tPnCjeswFPMmZGjtK2BGxnZ+8P+UnwqgOEJySUAnv8QXwshUcSV9pbHXBqtwhvSYHb1eRsxhh2vpnnM44tiXYYtHch/AdLkVfewNiGpfbprrA5V71IaxTrJnI7FXVOnpDkW+cHi67gZnF6H29JgpvQ3Ww1/yVPR5G6hcv42bgkhEi6tjti97VUhT+QRopiG19t8O3O61RodPHqNA
 7/Jw53CI
 iyN0QvAqL7dVwI3cXFYIzbeQwaQAknS9oUDhtcKt/wrhgNjiP9EBZtN6Y9SYjCUXuz7Bx5TYvtjTXexu7mRPPmlX8QTY+uCerS61VJPUYYZRnNXKQmTJubMawiMxk2wA2VwUxI0Ou9JFtEzMe4P09Q0n/eSWG4Gfoeu5h/QUdhgGIR5XCzsWpWYbvmB82yNmMsbSljrTZqvvTsNkSMsx+Wgb02Sj9t1hO+2kT+AjHV3ZA6HRrCREqWv34ZA9EdRCdAn6A23eRp33CjtdsFDdIj0pBMsKSSiSHpPo4uRdsb1LJ1UcVyhe6+aBCZXwaev4YbAVoEyvDyohA4WJ/UYq/r4Nk0qz2ehIdoKNAaMXArEsA4EFirYRpbTGWy80rP5tV/sM9q17kZt+NWSuoAPfhdoW13Zb6BpGpSLyhQdNJqUfYI+a+JGaNkUxZZpaM7xWs6FYyk+id+nwd2vjZev24Enq28nFUUaITVAtD48KoypUtR9hIYQ6CZ+fhUaxSJ5xG+OVRs6HALKZ8/80yXpSFCk0mn9tfEuDvn3jE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oscar and David,

Thanks for the guidance!

> I guess it is worth looking into it, I shall fiddle with it.

Great, I'll focus on fixing the immediate bugs in v2 and you can handle
the refactoring in a follow-up. This keeps my patch focused on the
security fix + the missing initialization steps.

> Yes, I would go with folio_zero_user() as well, to match what we do in
> all paths.

Understood. I'll use folio_zero_user() in v2.

So for v2, I'll add:
1. folio_zero_user() instead of folio_zero_range()
2. folio_mark_uptodate()
3. hugetlb_fault_mutex locking around hugetlb_add_to_page_cache()

This will match the pattern in hugetlb_no_page() and fix the information
leak, missing uptodate flag, and locking issue.

I'll send v2 shortly after testing.

Thanks,
Deepanshu

