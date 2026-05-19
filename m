Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12EBCD5BA4
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3DB46B0005; Tue, 19 May 2026 09:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE9F6B0088; Tue, 19 May 2026 09:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04136B008C; Tue, 19 May 2026 09:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0E0B6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:23:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69D0C1A0305
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:23:43 +0000 (UTC)
X-FDA: 84784236726.17.A3524C8
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD039C0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:23:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="cV6/e930";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3W2QMagkKCKwfMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3W2QMagkKCKwfMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779197021; a=rsa-sha256;
	cv=none;
	b=Y9GnUOsJ6+AGqsoouF6di39i5aj93ntrevPK9kENDJSTAA9zfv4f8hDG5CPVUd1EwJXBdK
	uECoaqxz4uggqX6tA2kMJj6Q1S6ZXYzXWeduvlKF6TrsBkytfctzOlKupFeDWRiCh5ZzuI
	LI6Ft7GAoRF+BGdQpjOARqeJ+6PjBrg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="cV6/e930";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3W2QMagkKCKwfMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3W2QMagkKCKwfMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779197021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nXtYmq7sgbDVzYqMJ+NbrcF6LTVSVOYs3ODjXCkjmg=;
	b=4lWNmqup51OTr6B7xuSn+YFyWZx/YYFzaalpZIj3AXBc647eiX5Gv5LP5J5UKvBI1O4czf
	lyNPC2ZxpeyDioJ4CO6Zpl+PQd0phQjT1X168OXNBqS33dd9ndgmgjo5evqAWUzIyB1QW/
	Zgx8MmjwIbIftyUT0/LY8PGzZt6QUg8=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6794b459297so2252300a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 06:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779197020; x=1779801820; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nXtYmq7sgbDVzYqMJ+NbrcF6LTVSVOYs3ODjXCkjmg=;
        b=cV6/e930tRzl3eiEWUqyi/VBps9o+lXCXyKOAGAVq6y1IGp4XSTYvGIjhpANC1eqET
         zx3E6t+ItGUO4fHUO2Wj4TVV5TkNmfRRzJAYwZ7awxTvZbaYi1yVkUm/I00H3uJrcHg3
         x/0MSgvWM/+luOhrWBw2NthQkdpOWCaPntJFiGKr6S7uDrzyOw005+9HHudjpP+2xrpe
         FWBw1Z8QEbDAlzmGSEvn+gKbyftDYDxbXLQQxW+8YZLWGD3SpJXQcgSkmv9JuN5o3Fm8
         gBRrXYYCBKaTdRcnlgvE++Z9Nplp4N/tiCOAPLys/r29Ww/mxcycjAc+faO+6dmuHkbO
         miOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779197020; x=1779801820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8nXtYmq7sgbDVzYqMJ+NbrcF6LTVSVOYs3ODjXCkjmg=;
        b=JfAAiLMvoGgS6LIGknjuTMQvEjVp5Ys4I1mbggi8hXdHobZxQCFptwB7B09A0A3ItU
         hF6MVe6TLcFuHpKxu25Fxn6qbw9Q1Oi3LMH/b1gonWt54X5HcJH7AjeB4lyFrszoVzd/
         vRyUak9VcX0jYGoaxRd8eSeNZJHtepQE1usJjVkV4H1Yx/vwV95OLwrxVvwNShsijUW+
         Azjqx2ZN/TVVZZQ8sLn/+inoaFSN1/RbASVusdxcNt3m5nLpBHt4cp1UF9tID4l8BhzY
         5ZdG5o+eUnEKXdQG5ukVwvMXG6gxUY1dM0CHv2UqjVC2nLOjK71SQ1FBe63OSScYDnKK
         fL1A==
X-Gm-Message-State: AOJu0YyY+zG/X4pDqMarIY34jbTq+NhYu9TbfdTb6vFabITdrQ79wWr8
	kvz+Z8q/2uT3A4Yl90NJf3JM36THACBM9sP5EDIa24d3IjNrJZkKZGoSgdjA1ZS+WZiWe+EEzPx
	r/T/VWM7R2pES8X2SVg==
X-Received: from ejcqa42.prod.google.com ([2002:a17:907:86aa:b0:bd9:6099:79bd])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:a18d:b0:bd4:a839:9065 with SMTP id a640c23a62f3a-bd517976444mr756668166b.37.1779197019808;
 Tue, 19 May 2026 06:23:39 -0700 (PDT)
Date: Tue, 19 May 2026 13:23:38 +0000
In-Reply-To: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
Mime-Version: 1.0
References: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
Message-ID: <9huzse7nfs85.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH RFC 0/5] Test readback from fd on hugetlbfs mount
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zb4gsbkkknebunte581y6d3n7ri48n75
X-Rspam-User: 
X-Rspamd-Queue-Id: AD039C0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1779197021-654529
X-HE-Meta: U2FsdGVkX19XUQ02zgUMiz+7gm2r9qI+Z5uEzj8B3TOZcpTkOAv/+MQzhgI7DPeU/OCZMEmh+GEVMYn4DoTuhZZ+Wq5nwr49ZyFlXtKVcU8U+gIJZDvFipVb8Q1nq0t7Y7F/aFfPUBbaRd5UM6Dso5nHGCbu+IFhjCRgy8AU7uDBYBtqyfKRTVhR8qD8ulB4A/3cP2HPDvQsG4FTzWM2AiwlCfQ03GL5rCL+5U0RrvEcOE+4v6KNTjHJw31LZHr+ocB+3tgtitMLN6LG+Sa7vg7SCxrxLDBBsL+N0G915FiaKGRfDuOAYvniCBYA9FoO7RqMa5gOL9kZVpPwiAMoC0oQ2WJUMTzX5cSf4due/Pgfe1M2s/6Fb//cosyXU3vui29oxZr2AGP7Zp0fKiy7XUPdONl2+mN5uhEdrIxdXDNaDej0hIIZb5u02GqTL2ffoBYOqVoL/3bki/2fWFzyPprdeKqA15kl31h03keocQ/JeNJVL07q9u5je5RLFWZcTBUmRp3XFBcOhvs+4WJuOuNDxVRWmqVZbMndS9JaHvBj9N1PtT65VtJXQbHP07hWyP0q+Das3uTTH5uZ5pHAqQWIkJWeRszh2mwj60ycbT2TsEmuHX5nRWYaKznlkGWXDqPAbzsnaqLbi4R3ICyWoMCajf0G8zTSA+k0UeNIhrZMwT+s/4zw8u64+NIc4EBPG8Bq2AYAgPcsI8QtwmooNOaqsgnpeupOsuI2sALK5FHSYEbDMUsByDj4kTYxbPGxRQh9sGMvhiHOxIqjbZFIAUyYvWMOfsooNFDgFRpuZJS/tq775rgh+HFkMfUTXKraBzFlRcffW05z8E3fdepq6HgTSruRIzsyA5+48QSMjjFLDN0o/ISOr7ORgA97GmsLxAxZxqO11SzXwkc5CPNSu9eluduXKH+mtXWPyBQgxhVMO9YPQeqfh74u8hg4giCCykVe3JhSZzGub2pKyVU
 f5gQntVG
 EUercBVfSsD+/yD/j499dWaYStrmhQliQZ/d7tsjCtGo7p2ekt+8bvu7j5pdETTygP/uAlt5CYwk9yQeDUpfVHmZHaqQQyWbpMdUL4+lbR1rObSVBwefCiDFl0hyvNMubZaM/WDOxcCzKU3t8rjPfmNUEavNLr5MBPwIRQc8E1enFe/twBpaWcGP+mf2B+lxCVU0bImyRFqq6PyW1MKGApMVYCwVJSZ37UFtptyFgnXJuSeON7qg9M3RP5TIMYB68ae5hvToDo/901SRt4bEsTZbJps9QLgdzhoPoRTPNCgOIEG/DJCNd1t/W7xqeMvJIYP1duxh2q4jjGfnuitrfwT9WDPHHnhQZmgAmnAT61+ecdzjoVUe1Rx6HUo1dW63sAFSACl3jhiCIWgTkMAdbJolXx7tde6d18wARDFXnBWJhbDvpAypmUMpqAU9FE7zzi7cSUhchbOviKu3e0fTM3jrbeZPu8luWNWoyRoNLnr46AQGLTr06zJ/AKYFKDg3fy1pxNwdDFRR3DU5zY2fPW84F+DNAVJLsx+lgzkfXSEHwyyx/Jt/mdoDP2cHvvDy/jmRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


If you are planning to port all the libhugetlbfs tests to kselftests
I had similar efforts done in past for LTP here:
https://github.com/linux-test-project/ltp/commits/master/?author=tar-unix

These tests were migrated to LTP from libhugetlbfs.

Just want to make sure if we completely want to itegrate in kselftests
or LTP fulfil that purpose.

OR Only tests that are not part of LTP should be ported to kselftests.

Thanks

Ackerley Tng <ackerleytng@google.com> writes:

> Hi,
>
> I'm thinking of consolidating the tests for libhugetlbfs as kernel
> selftests, and to start that off, I picked the simplest test:
> tests/readback.c
>
> I refactored hugepage-mmap.c to use the kselftest harness, and then used
> FIXTURE_VARIANT from the harness to port in testing readback from an fd on
> a hugetlbfs mount.
>
> This output shows that the original test behavior was retained for the
> memfd part:
>
>   # ./hugepage-mmap
>   TAP version 13
>   1..1
>   # Returned address is 0x7f312f200000
>   # First hex is 0
>   # First hex is 3020100
>   ok 1 Read same data
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>
>   # ./hugepage-mmap
>   TAP version 13
>   1..1
>   # Starting 1 tests from 1 test cases.
>   #  RUN           hugepage_mmap.read_write ...
>   # hugepage-mmap.c:41:read_write:Returned address is 0x7f19f3a00000
>   # hugepage-mmap.c:54:read_write:First hex is 0
>   # hugepage-mmap.c:59:read_write:First hex is 3020100
>   #            OK  hugepage_mmap.read_write
>   ok 1 hugepage_mmap.read_write
>   # PASSED: 1 / 1 tests passed.
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> Let me know what you think before I genericize the 2M hugepage size to
> other sizes!
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
> Ackerley Tng (5):
>       mm: selftests: Inline check_bytes() function into caller
>       mm: selftests: Inline {read,write}_bytes functions
>       mm: selftests: Refactor hugepage-mmap to use kselftest harness
>       mm: selftests: Update hugepage-mmap to support hugetlbfs mount
>       mm: selftests: Port readback test logic from libhugetlbfs
>
>  tools/testing/selftests/mm/hugepage-mmap.c | 143 +++++++++++++++++++++--------
>  1 file changed, 105 insertions(+), 38 deletions(-)
> ---
> base-commit: 66edb901bf874d9e0787326ba12d3548b2da8700
> change-id: 20260503-port-hugetlb-selftests-9bc63bde5116
>
> Best regards,
> --
> Ackerley Tng <ackerleytng@google.com>

