Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB1ACA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0493A6B0005; Sun, 31 Aug 2025 05:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021DF6B0006; Sun, 31 Aug 2025 05:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F916B0012; Sun, 31 Aug 2025 05:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAA0C6B0005
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:08:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 650BA58D45
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:08:33 +0000 (UTC)
X-FDA: 83836476906.25.55F519D
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9331540009
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:08:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PODlHi2Q;
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u88nEX4VhKEhfqfy6sgABj7KaLHVYd51Cg9xPrUQsPg=;
	b=w7z5WoIbRbfhvuI45JB9pCz2FWUwLBgaZ5hgAFpiIayqm62t1RIIu03Gtb94pZNev/eF2p
	OQMh4STclezAQMGjdWeVsTTYfn5gnJ8yV2IiN12OlDixYXux3dcbtmnknJbhX9vl5sLJHI
	2dpD53x76k40FAg1oENUHMhwXPYOAZk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PODlHi2Q;
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631311; a=rsa-sha256;
	cv=none;
	b=ERwrRrYe7Ty9e/kXuEnwBYi65abXXDesMtez3L/kdX0kXatEa7VB1GbIzYtpVRi7zvBMTl
	yPQ+1e3y4ZD9iWLpnBx2vTfmo6sLFxwOi3fxRTZsKW9JsDVEXPhMhiG+dazjuamewaCiOE
	bY9pmg5b5PykPXckSkePpl2AdSxkoKQ=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d6083cc69so29393527b3.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756631311; x=1757236111; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u88nEX4VhKEhfqfy6sgABj7KaLHVYd51Cg9xPrUQsPg=;
        b=PODlHi2Q+g2adXquh24JkknQ6cSDbsUkRYaCJ60lIXksBsvYpxzUDcEJFK7kZhDyXK
         rfoqyPnNarOZKf+0BqKUgPqC/n4+ejo+iii1YbhmOqBDlit6b+n9ImaXM5ZioURpJq+T
         DObjr27dun+q9iVlu2unmU8zZ1EXtfC4m3Y3BDu86VaRnOeQdDnhrvhd3P5xFiY8OJyF
         1COZKoakLdJAvZQElhQEBoeZGA+WaLh0lR20joHnayf38TQCp41lxAcqqe4sySMbfPIe
         jwObddRILlsHFiq4lH1vqj48hmyuUTFNJGydONwjdZ0ut0myy+1Zy2vHVih2+9Lq97zp
         cIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756631311; x=1757236111;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u88nEX4VhKEhfqfy6sgABj7KaLHVYd51Cg9xPrUQsPg=;
        b=kttEylHK5oxv9VNRtfGu6O84ycZmz/yKBLX0PYiRS/BTIvEN2uoh2H6VEIb+ZcNFH4
         6liOd+jylRWu76vv0YgMMYvMQ+CLxbhV9noEqlLqyZ+3Zq/X6fPOFZ9cuE0Y0V5h2gL7
         JiGpoxFRrr9Hpk33yIGKsoygo5FQc7TGRTfj47YlnIyndNrlr3vGKf9mKC9PRMEBnJMc
         NsoHEzVtYml4BRv6pCeSwuZxBau5lmzDgLqgyW2pJRAeENovUU7N6Mx62OZWOPaPNEfx
         jPHV0w87rH1D44/9Aji693kwxjw3x5tOvDbfEfoib+1gB78Ek9L6w2Ahepn7UJFIZHKw
         /g/A==
X-Forwarded-Encrypted: i=1; AJvYcCW/QPDlGusOqN0MEGfg+n6zDrF5uJCCVsVCZu+nTnIbgQ1Z6Yd7nT/nkrBicWeu95YY7XtRlubpMw==@kvack.org
X-Gm-Message-State: AOJu0Yw2jbwLKfu1Rm2Ni/J7iVHgI4wK24uAKVeQmXruINfftWJe8CQw
	SvWK/a6w0qCie4l8VrhzuBTdYVVD9hiwsYp5M0z4D4B/Hk5viUmhuAFzOwdrIlabng==
X-Gm-Gg: ASbGnctj+YgUCF9rIAOvrOZwcTAgi99M8L5y+7b5QN8jSlcFwX8hF3hahYhS8iph6im
	9rAgGrbDKBTMy7gfxzpjHSUdQNdId8kufHh3i/PHJfT+lZn4LuEaOVJluusNjxtqFQmn9qssnfy
	Jn9lvVDoEX8Sdl9fUGWCn+CtxQ0XgGKOim7x77bWJlIsxfd+wg1qETaw21zOpMG1Rjdg5YpK5tk
	B2Bmtgpt7GB34FLvRir5/961tlSOjwIPKhPHUWpczOgUICq0E6jYZuroI3M7yp7l1p1+MpaZAR6
	hQbMkfR2dz9sejSMNHqQvrmD3jbQWird5WD5zoTijeWPaBiG35LnlZuPIaouR4rXj5iH7S6mIL1
	i51ehJhPD2oBIfdgCaVKpoi0zdgynSg32WF8GEtBq0J/BfGPxV5NsWAQBGU9XogJCH/Oq/KUJLl
	ZrU3vSwmhm+cT8xA==
X-Google-Smtp-Source: AGHT+IF4uqF7l2E0FZ9hMKOQYbXmnG/oF/j3dZTuq2FVbemX/WEQ1z/BcNuLmVYRYcxAG32KEwnQnA==
X-Received: by 2002:a05:690c:490b:b0:721:6adc:4364 with SMTP id 00721157ae682-722764cb124mr44113587b3.33.1756631310488;
        Sun, 31 Aug 2025 02:08:30 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7227d8ccb38sm7148137b3.35.2025.08.31.02.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:08:29 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:08:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
    Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 3/7] mm/gup: local lru_add_drain() to avoid
 lru_add_drain_all()
In-Reply-To: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
Message-ID: <165ccfdb-16b5-ac11-0d66-2984293590c8@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9331540009
X-Stat-Signature: s1i94hc8gz4qbjxwzit11uttfwbiiw1y
X-Rspam-User: 
X-HE-Tag: 1756631311-846011
X-HE-Meta: U2FsdGVkX18FtWL776KNIkmlY/eDI/TWGJ8Zc94ovglfcqwOmZQkCsYbaknJq2IpjMX55wOxPrWHR4hDtXq14g3thnuhsTqPXoYZH4tvEhekxdegO4E+ruZMl7M0qvtOUuTF1K7a+R/nlHj8E7nfv0DkQpPFWi6Wp1Ue6SeXdiAV8Xo8xZ6lrtQTcZ2Xe2s8VhmcXtAXcDBqaYbVbCtHjUi6BPCbEDv1nqs67YGozOwQTjLRt6UMhIirNKd+2n0eUkNZEbE4WmaBOoCfi80/0FGgYYQiUnbekydVHb0qFqSMHRVvkqR/b7tXj8orsEadE3Wv0499bFHwPbcYsSQpV1SXt0sr+YYK8Q8UUg3rmKubO761yLD7i9BqYopDAwoHU6SVMTkfxQDcvQcL2c6rY9eTN3ULwEuVYn16v/GPnFSkmyJcOZfT3MQT2HBHv4UxH1yvDTM6tQll9boBN3r/YFeG6qCm7Xw6qxCXrhFCJl6ZsDWaeucTR6lEUMjvwKgvAB19R5m4SklgVnB/BqhZ3h+YXis7pHRrn/ETwf0fhiJqmpX/M28WgM2/l0loquatFURBCpG3+ECKisvUMwEELCimJTnvRJ7p1acXYzChvWh7iZOYL84i/ZI/xqsyBVkGnLRNoP691VaE09/GVcnA9GNt4fbb3TPK4F3CeHH3L9QiAYlJ1SpuFOSx/UQuDpNQLGdggMEKnvuXJt5qxT8xx1awylQO6m6h6haK8RxvtgucqiMGzD2nZUGgGpMG7a9A81z6EEqoxd7R7TTjLDpzGQNM7Lx+B1mxVbmtbKA8COz0cZO1cyU2gMMaxydX9EsN68/U5xs16ONpM09Qa09cOUFRfgFi45/5cPbwL4QHc/nzH62yFLUU73Kden4dBFPivuagPVqXlNhINh3Xz/CXCU+AfWnPjM7IoeLsjSSe0mKOP9k+YZEFE8Ld3SSGvFjt3ZOEaPwGpRn0ZVLLrxP
 iBxRtAYc
 /ZOjGFq1FzEeE0W5Q5+KDlEQSi9/HQ8XzeU+fFsEClljbpuIJmq1KMGnFNED9r0NK6Sh7sLC5skpQNRZkdTBp358bK/Yk6oYBz7VOKuoTpJQXqDmrWJ1STWAWDBACPvVhRIZGwOKf1WhfZKtOh0s811GPZP1bW4EMVIPlL8crvG8VRWvRLMs1YPJLV/UvMOnljU2KxrCZCszkEappkpikaYVe6kuKlj0OY491kJNPgiuD7si8SadUNtT1ndj8721Krj61o9BTlpUVe6KP8UTrx/p1SEfzDHwtC6e5qr47rWul4qEBqjkM2yJgp1MBZn7bFN2Doztnyd3MQUb5CHESMf7sbPIcYxFDVRjlCqUfrectb8/YUR950u2vF2PQYGrRkzI3W18i11ym4zH17Vr7fkC2YUijTtiO+oEXYp5D40jULZroX/W7scXVZf79gLNlZ7k4UQI0a28ooe8XzSj07N23IQFnVYVExN7pBnd61e7BLRTh1Na/t74H4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In many cases, if collect_longterm_unpinnable_folios() does need to
drain the LRU cache to release a reference, the cache in question is
on this same CPU, and much more efficiently drained by a preliminary
local lru_add_drain(), than the later cross-CPU lru_add_drain_all().

Marked for stable, to counter the increase in lru_add_drain_all()s
from "mm/gup: check ref_count instead of lru before migration".
Note for clean backports: can take 6.16 commit a03db236aebf ("gup:
optimize longterm pin_user_pages() for large folio") first.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/gup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 82aec6443c0a..9f7c87f504a9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2291,6 +2291,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 	struct folio *folio;
 	long i = 0;
 
+	lru_add_drain();
+
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
 
-- 
2.51.0


