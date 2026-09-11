Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA73C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C0E6B008A; Fri, 11 Sep 2026 01:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E226B008C; Fri, 11 Sep 2026 01:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E956B0092; Fri, 11 Sep 2026 01:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6C46B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:38:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3A51806E1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:38:15 +0000 (UTC)
X-FDA: 85200375750.18.7F30EA1
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf12.hostedemail.com (Postfix) with ESMTP id F291840009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:38:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Nn6d7M07;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789105094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqqJPfwVD9qfgrw5ni2b4uR4Rq24ucUxHntuj8sDFZk=;
	b=OVP8WKsb3/PXF6qkhZ7CyDXMAnEywIuYcWZYbrO1w2dsXb01XmiRysjvfESk6pFlAWgTzK
	64DfQDk15YbzdnAGDTXiyA2Hm3SeGxM79Keo4Qu9Rd0XCzx4zHgWSlIZogKeX8iBs10C3J
	W+It4z31qIimGVAnKFpnLm/iyeakZ3s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Nn6d7M07;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789105094;
	b=77rJ40+70oyhxrNnXQ7pnlryHAqdc847yQ7NiMrr/bnqVBwyVfWDsER665BgJ/CfVyHyig
	/cba047ZxOFT00uUquEu8jWiOBiQijlxesaPxABj41PJFoWM+a7CpGR8gvFR/T3mLVQjiG
	ZAoKKsVI0sB9xFH1LriptxpIvBTKjr4=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109fafd6so53182385a.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789105093; x=1789709893; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oqqJPfwVD9qfgrw5ni2b4uR4Rq24ucUxHntuj8sDFZk=;
        b=Nn6d7M07j/SPCMm5+OsQt1ZGrQq9FNydftE3dsyQ5gQ0i07/IenUPsKrgqOUlJWu/N
         3QZ0oPeKAY4mbm7GZO3nvrTRMYBaOnDC78nVvQT2MXfshLKy92+BCMbv+wd13yvWAfUm
         A5vpQNnuJZAxtdSzqQ+5+YiT6VVFuPSmcCRoPVdOTWPm99GjiX6kcOaRzXbu4QWlzA8q
         8xKqGNGmjj/TVHcUOlXBa7Z5HY/3caQ0AZunIbYOfaC5pXKxyzjzUyu2/TlZSM4IJcg0
         pmHHjs8qNMRlBIUOFs3usFgBRRCEmZaq+CX2vQiz19TjZEFOulyLo6jj9ku11J6imVYN
         OSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789105093; x=1789709893;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oqqJPfwVD9qfgrw5ni2b4uR4Rq24ucUxHntuj8sDFZk=;
        b=YcNemN17PYyl+S55MCXNtgLkx9S7sOQp2xfiZdXQetvJHD084T2faWWCU7+xjViOnM
         wygTZCIXwfNRtAhzuwwKuIWXz1iGmNQTBz2ZGYCnKXxeO5akMlp1NQnGcGtXzobrKtNc
         nfBJWyaLGFuLS6CC0723TyPcsBQdd3KKb/b3ksVU2E4rvQYmplWznv+RrG83jRDEu3jy
         C7FV4c5a2NaZe5OgLXUX30LXH61e415qtYcO0u6PZOWtHsD6fSqhsYucSgmxUYX9TwQ5
         EUaahU7v4EAxoE8+UyNhjTxlWEYNYAoo1ARn0Hq059m8X7v/oNdez6wS361r4DFLqy/u
         60yw==
X-Gm-Message-State: AFuF++n8Xiwl8EgRB7ObUH/9MD2DOAQpNQqyeXFK2JhkzJl0RuQccUDk
	1YO6LP8YBbOLVCo20WzeUQbKPzG3NJYWgZ9SF/xUClNbbYjtgmmULXqm80TYluhQ6YvMpzvWNWc
	UrWLw
X-Gm-Gg: AYBFou2df4nU53d1l+AJupi7RlZBofe8oTQCR+zIcTG0dn+/Us4sw+WetuUMAg0MLu4
	Zex5SVQs2HJaE0pKrrgmpfYBC+wNWvGoX70zAKipDpvPjeplaVeCHgG/PiXIhYZfQLLLvrXyDOi
	rJZw5+2gzqumfoatQvXV6hd/yD3EMTRuyYV16mcu7yb0QfqSZUIbobhoJUBsr/af3xxEm4e/omk
	9Q60b9hscCvPrT414spxWi8An0j0/yZf1iiVG5sAi0HE8ozlJdrY1nu51TqH9oG6VDPgaLtWG6E
	wy6iGiraAvsbBeyNrx2t7KJDg/BIXUx9jDa3KF5C17GtqvfAktokjgpnH7WjtRFEL2w/XA2tGRN
	KiS5G2rtD3U9beaGHAY/0osOU2dY4X7kBqCuufSU8dkYeKJBJci5XqRU1CjweeXdQrQoc6HkVnj
	mp8bXIoC4CRRtMDFqB0MITrsc5o4nalNsDKwE6LHvDSTJR/tmudfRk4SgIC8VPxzHF8dB2iu9Rn
	1vPaLqa7FRSppWFkWGKOrXy7TCz0TdsDpbwq77Mp0bb7yqbMFsnwBhd
X-Received: by 2002:a05:620a:4688:b0:939:a9d4:50b7 with SMTP id af79cd13be357-939ea177661mr311177385a.26.1789105093018;
        Thu, 10 Sep 2026 22:38:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f184f5sm163816985a.15.2026.09.10.22.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 22:38:12 -0700 (PDT)
Date: Fri, 11 Sep 2026 01:38:10 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, 
	hannes@cmpxchg.org, raghavendra.kt@amd.com
Subject: Re: [PATCH v2 0/4] sched/numa: stop VMA scan filters from gating
 promotion
Message-ID: <aqOR7TY5YtIadMAK@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911001826.2109390-1-gourry@gourry.net>
X-Rspam-User: 
X-Stat-Signature: 5qywmiwk6wuhx9okdaiif1rg1sksgp3k
X-Rspamd-Queue-Id: F291840009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789105093-20206
X-HE-Meta: U2FsdGVkX1+ivy1zuMI056rfNqDTyBnuRHVglkS9DnTfPdYyRMU6GMke83Vd6ltE8fvcZzf0nq0ZI5Q3EILHvglb7yv0x5EavgFvD8R2A+hmrJiP25a04BedPUmWJN66GpF3LxkE9Pe6Ed8IpvX4mkNi1XErdV5Ws+fG9N6qpvI2Qh7HuSYvXlM19n5jRkMbAX8nfulwAWmH+v6eZI2W5zv8a6jZFfU9TugYj2fmwwHnAeio7r6yzP4COdYpqssK5ks8j7oWq4WzaIawt+ApCsAhl8tCDPMQCwkByeqKQrkPoGEMyAZlaOs/F/jF9cTTbOgqNqnIMrT0rFykfeNjt7gu2w7fE4dP3TKUZD7Vq8NBbo2WgxO0V+nqifzBpCP9zFakrllF9qAoDaeAeFEpVEcylCKvUPjoa8pjAxVLHRyCL8M+QrhKPLppz9SiRSy6cnLy9SEG1rgLHxkkU/olS6L6jdG8vYb90DKax/qPzL6s2R5t4llUkGFmaLH8mMchQS+5t2QMmyUNsc9N59WMt6pbai4Go1/XH11GREx2V6oN+VBuE/monjD2qtbu7n7NnqGCPGzJeQn4JrEUaf10OHZKasrUbwyDujzFeHJ9JcVwwrsFLZnjrGgtUFnVo3BskFRJTKK/GWLkGJUO+pE/rRx9Sl21Hl0lX4EqbCCuqeKsIU+1BWKX8UyBLbAoYnE3yHnkQO19a8ls1ZVH6vd5Ay7I1aGw1TxIJaA6fMKphDNzCSliQi6RxQB5PRTdxvuT9mnebwumXZcgePHOLhTTYIuP0KcdwFHJtQOyreCDWfx1Sdvgb45coIER26bkeAIjpsQjyxjQWf3clXEkmP/R4OBS34hfNrhMMme3TG12H01+0DZaQnjKbtJSeGusOPiA/RXo3eAetVRFDdKlYfDn6RpSNqPLpxyjCHtrHnh5nm0WBOUMP7dfPxp21XWYoZByKKynhZ1q7z7TGim9Ask
 9n7y1jjO
 aEysU/GEdcQ3MqxQPACIEJx69ZNGhQWGuLTt/EQDk/T3jjLTwbd9Wrm70H39ELWZnfRJ96OeOatqM73WXd9A7RO73eNr71F3WYFWSuWFzTnRHHhNpY0PUv4ZAO9v5JA5vg/8a9copP3ZVBFVGuXjnaTebZof45+F0BJznPcay2SgnGtIxqnla5TrKRd73zOkXwkQhFGvhiC42HPAemFdo3+G8NQv0dg76dFLsXv5BPAfiBs0NBv2j4m4QcqVREVTV/pBsaePgiSx7lW0/54UQK4NgVN2eWgFGUIrQ0qXRfbtzwWoKwzq8mXn3JKMKNtOmDY/pdns94duELA9fa7kD5wkwB0d9oao4Y3kUahUe53e20GjJMxvlz5B7OA7PrPtVMQgXIQy6e9ljCYGjbwOA0WoSeOMj+7m3A7U0AWWflUBW2r8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 08:18:22PM -0400, Gregory Price wrote:
> NUMA balancing uses hinting faults for both task placement and memory-tier
> promotion. Several filters designed to avoid unproductive socket-placement
> faults can also prevent promotion.
> 

sashiko notes - remaining notes appear to be false positives.

patch 2: "... bounce horizontally between slow tiers" <- nonsense
patch 3 and 4: it's existing code extracted into a helper, using the
               same checks we're already using.  If we want it updated,
               that can come in a separate patch.

note: this work has some backport conflicts, but tiered numa balancing
has effectively been broken multiple times since 2022 and 2023 due to
these filtering mechanisms.

~Gregory

