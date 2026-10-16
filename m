Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A98CCA490
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 22:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0799E6B0088; Fri, 16 Oct 2026 18:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C906B008A; Fri, 16 Oct 2026 18:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E636B008C; Fri, 16 Oct 2026 18:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B83666B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:35:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20357160110
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:35:06 +0000 (UTC)
X-FDA: 85329946212.17.6553199
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5EA6BC0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:35:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iLDg2g6P;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792190104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfiAlLwpckXLSSoGlBblxykTWKXYXbwMTB7pRP0Lj2U=;
	b=gNGS0JNLA9+oeZnw34814pfe9OqYRkThLoxrf9nGuxrCWuonUeBTWTC4L7FE6f7uQB5x+F
	F/PIVG/4TRBjGNRhxfz5L1mQLWkuEeSq+1Co4Xsa4X9t5ROZZFGsOIsPfJf5QoTR5fiDf9
	6gXbVlG8X+M7FtcK9JP9HUO6AvaIavI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792190104;
	b=SRIn5ojp+5WqqGS8wPg/WOKpT40qLxsNk4XmeortjgJqbjvcI/x55DLCSBiow35pYxAaNJ
	BPEFftJmgaBONhwFTEarE6bTw3Dwsr/PAA6iShQHhiHg1SaQGb5awyv/lziu94V3BmLZph
	g/gg2teIH1jatjqCjUR6uge8axt6E/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iLDg2g6P;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so7745ad.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792190103; x=1792794903; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UfiAlLwpckXLSSoGlBblxykTWKXYXbwMTB7pRP0Lj2U=;
        b=iLDg2g6PaePAxOI5XLcGZZCD9u/3Ld/nhTQJbClOJM0D/oIy3NXT8QqP6SIosbBwHd
         ao4VbD4DgppIaPDrU1W/D2Ygnu3v6deaLm3L66cc1Y8HAtE7xtNVW7svYALwdKdMm747
         HDsJgDy2JQBdwbb1v6O0WxJMVtqhJl6krKaPRtSIW0q2PtmxUkHJIq4pOc6SsYpaC/6N
         Dr6YYtOLQ5n6uG05a3d7qySSBONWjotrcStT1XNRnikRnuZ4QEjhv6A6s6SNMyWopJ4f
         lf2dmsaq60rXltx+38D2pSYqfoIHSl9m4rq1lUrXB8LVyEzNSBWBbf/U4CTMPUdz6zwe
         MJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792190103; x=1792794903;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UfiAlLwpckXLSSoGlBblxykTWKXYXbwMTB7pRP0Lj2U=;
        b=fm6kno0X9g91qRSgQLkT+VNnPJh43VkBRw1A65fwspOLh+jGEMq2syQ6zr+cArnlMM
         HHVe8eOLkldoEELPs+mdwYceMd150cvfU6ScXg5fHuu18ETu37sp5MgcC9kcOcq8vCfJ
         3PwV6Odtg5LhCeiklqpJepJ7q/EV19/m0d83QKFue3tbA1pgbwllzPS+dOOyXRKmi9qT
         K/12nAMro0NGuh3cmBAHcWJMF867PkATh5tIfpwKrtSCx81V5bmjIy2ulP/AGsX/56gf
         z8DxmC5He4boe/ivi5bCkEkYy2xR80DPK3dWhb0NHCZJu6bclErFZEeAcPP9GcMkbctW
         a5DQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2GDBp0PtKs/oqMGg5x8bYzF7dQbpxPReedHoR+nvDk9flwc5aMJNK3a/v9VkXQKhG5tkFT3z63g==@kvack.org
X-Gm-Message-State: AFq9FYLT0RugX27RLfunBPkCd7kv2EPK4rIqYiv45NAvbYo1lciQQnmq
	8gF2jzGBulCRBI5TGDxKd6kicZLXm5GEUVdSjzyXH9i9hNCtZa426SLDyapgO2ZQHg==
X-Gm-Gg: AYBFou31RMBOfBISgUShnY7M0hmtxl4HcC6wHL/ugqtboWComEXeFXgWhBu/iNrvs/V
	9wP1QuC54zDPjDaI1rmuK9WVu1E/T6+YJwnIYt/a2EpuD+gPB4UDjJxTd9XoEOAVZEfYdzybPGy
	Za3nTE/OeDUw4f37dbeN5blrd9LvyOuNP/JQXaQefz+UrTCzug5f3H9PDIJ2vPj1oOo6xPz2IIF
	GcWhNbpLqmWJJDLrfiv1EtY9aVv1mQkOwooKuscG44vNhqpN4O75Ory7pkvDBgYMcfIF2hQBzAR
	bCYFVa6+ObhKHGOLULkSYIwDZbZW1EICmYEL5fHnzqAdomjRjmg6cO54vmD2/iIt09uKvsAePZz
	7IaE7FbgBj/GeUrBO+Mkl8BavE1I0ZbLrQLtoXovTxWjpErBfvMRJRjgEQMWOuEMgo8fG8kCrHU
	tEkrwWo2nvGSPi51HMTnVZZl/AdWUAKmdtBHn+XjR8GetvBf3gqISGs0Aq6EtVH6O/HNvXJU5ls
	gc/ANe8FjtL1Ic7sFrwBtTtJVaWezzH2mVjfif145SFQvJsvG0uTMC6ue3d1rgYLHwd21JX1v61
	UMkDU1Yj8YcjQeLA+U7gRnIwVgjfXPqDbSbPnLBEwfmnm8d/hrvZnZcqx0wT9q4/2qwTpihp3al
	y/EyqEVU=
X-Received: by 2002:a17:902:d48c:b0:2cf:9ec1:ea6e with SMTP id d9443c01a7336-2e9b31afe12mr1007515ad.8.1792190102405;
        Fri, 16 Oct 2026 15:35:02 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:17ee:cb47:3ad4:ee3c] ([2a00:79e0:2eb4:9:17ee:cb47:3ad4:ee3c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c87e66sm1698081b3a.13.2026.10.16.15.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 15:35:01 -0700 (PDT)
Date: Fri, 16 Oct 2026 15:35:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch v5] mm: vmstat_kunit: add synthetic benchmark for mm
 stats
In-Reply-To: <920ba123-077e-c42d-ebdf-a5effccf2073@google.com>
Message-ID: <8b077a83-3f79-cbfa-0273-e086b0e51ae4@google.com>
References: <920ba123-077e-c42d-ebdf-a5effccf2073@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: ygp4wh44i5p4iby7hmcrfamm3xtrs879
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EA6BC0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1792190104-31953
X-HE-Meta: U2FsdGVkX18Ke0lEvl/RFAAvxvPKAYcCWM+5NuLDEjbpuNcX9JJvqRCrLMG3UBLVZl7xN9/ZGIAnJdvEBO+FasloVseGLrSo+0QL+oM64S7SH3zd0AZ4O3pBe2Kn8E2SlQhVLppEWRFqNGpMAGij2FJca1Bo+j32SJ6+7y8KPXe+LVAalhdVqztbwkldsUhB1e65Hx99jc9bl1XV662s6TF8Cw9AFrFGby3WLp1AItjdwVeEgE0bVZDMDJvZsKkEzx3KUYxjkw/8S7THfi8Nfg8yA5FStP9bmpG4iZK8x/XKXDX4jeT29adU9A5/QtGHLSFql/qLFkrlBXOPGz9pGb3CsHyrRycwrz8A5jqugrxHIlk3fbvJPCnY14zWJCsCcQ7cEUMxDci3sQ/T1x8TGyfN74rkkSOYd4xbiPDb4XDYjjOfZO+YDU5MqUgM0L2ZcQJXG51VGiCJ04oqflbdYlez/7S4g0wmSElpOS4n6qm70OYATU5n1U6zSRQ1RgBBlUczmFEJjyD12sc6R5GC4CDzm3gSoBNYPjJ7jM4Ai15PjiUq+KOjnUzi4Zgr7ftQFuejpFg96bzMWkmMqRwcGA6vJI6PG2vK6GSJP9iR1uuji9sRPRcPHbjFkE53zCJ6m0tiFWfSLkf51Q2l1PCX4RtIYkrHbfI5LozFQbSkdGAgeTqMTGf/8pGBULnUpFHaJSfUQyv51ogR382T1W6WE4Fun1EYLg/3M4f5nmf40ZssNP2/edRKIniUFjKBdt1+3McxlhWEuXx7I8IodtXAsNMaLxsgwsg2bAxBZMXLEJrVYUyBF+H/ouRWjoO7uCUUze/eMOcXDOE0JtyRASqJDWE+vBSL1oA0ADygH8mTjzibo8xkqqtRm1sW4CXf0QRKEcPBcBphfeyfHKRaUlnNvGvmrsOj6CjMbjv9l9+RE1fJhYgbY6iaGaTai0s6ZC40usONq6+x1krmGwXtJ0s
 XZ8UQ5kQ
 TcGr2aQGiPk9uOo3fuPtdehuTu0m+qwBKlzTqOxjB1ukJ+Tzi7+Hs+N/47r3O50fLkTmLzLbCnMKjMWmOoZDpgMx/jrAR4pA5O7NM8xzbjSFG5sLLRDBk/hWOaBrqs4OJL/s9VFqSXmDVF24Kk8aO+mYHAtDslRfrwnhw4+PgcrOYsLuJj6Ap8GJcu30MMVVBp+WLYkWLDK/y2j8s+vofBCvYirpPN2izkF5F//Fxsw7CKZhoAlo0s9C11eYCzTdlPi6w0SSUKhlsvAhsVWb8xwNpu4kuEUG8rP9fP+e0DwMyGz1B/bFFYXuXIbvKgZpWwqyEf0dv21Q0vkG2wdK0zk89/IUXPmLsfB/mZSbZx3qwcKArLlKJzlNhV6WyDLlZOCvHBlqha4GoV7YMLArLxAqhUdFOZc0bunNFhbEQkAYD2BOB3HFQX//wkGc4SfHJAGuh+isZRMxGaAiAC8b0WRstLsUzFAG9PCHk/xj/sXaI045X0LX7E6Ghtfx8hFxAQomvmEnzfHmGpU0ZngfNkkxHYyG+8gxrKfYOwbxQkBRpLTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Oct 2026, David Rientjes wrote:

> From: Christoph Lameter <cl@gentwo.org>
> 
> Add a synthetic benchmark that can be used to measure performance of MM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> This is the first of three tests that measure the execution times of
> critical MM functions anticipated to be used by developers to measure the
> impact of any core changes that would end up causing workload performance
> issues.  Vmstats are embedded into MM hotpaths, so any regression can
> cause performance and scalability impact for users.  Google has carried
> these tests internally and kept them updated since Christoph posted them
> back in 2009 for this purpose.
> 
> This can also be used to detect regressions over time, from kernel
> version to kernel version, independent of development use cases.
> 
> The test is run by KUnit or doing modprobe vmstat_kunit directly.
> 
> Sample output:
>  KTAP version 1
>  1..1
>  KTAP version 1
>  # Subtest: vmstat
>  # module: vmstat_kunit
>       1..3
>       # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
>       ok 1 vmstat_test_inc_dec_zone_page_state
>       # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
>       ok 2 vmstat_test_interleaved_zone_page_state
>       # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
>       ok 3 vmstat_test_count_vm_event
>  # vmstat: pass:3 fail:0 skip:0 total:3
>  # Totals: pass:3 fail:0 skip:0 total:3
>  ok 1 vmstat
> 
> Assisted-by: Gemini:gemini-3.8-flash
> Signed-off-by: Christoph Lameter <cl@gentwo.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> v5:
>  - added dependency on CONFIG_VM_EVENT_COUNTERS
>  - expanded commit description
> 
> Once we're happy with this change, I'll apply the same treatment to the
> proposed pgalloc and slab tests.
> 

I've added the rationale for the change to the commit description as 
primairly being used by developers to benchmark and monitor any 
regressions in functions that are known to be super hot and impact 
workload performance.

This is the simplest of the three tests that Christoph provided back in 
2009, the others are pgalloc and slab tests, see 
https://marc.info/?l=linux-mm&m=178547194364290 and 
https://marc.info/?l=linux-mm&m=178547193264283 for those.  Based on the 
feedback to move to kunit, I forked this one off independently because it 
was the simplest to address all the feedback and pave the way for the 
other two to be upstreamed afterwards.

Is this acceptable for merge?  If we're happy with this, I'll move onto 
the pgalloc and slab variants.

