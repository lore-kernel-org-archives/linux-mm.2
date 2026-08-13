Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38383C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30886B0515; Thu, 13 Aug 2026 11:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE50A6B0516; Thu, 13 Aug 2026 11:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA176B0517; Thu, 13 Aug 2026 11:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF536B0515
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:03:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 175A216018F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:46 +0000 (UTC)
X-FDA: 85096565652.26.AD03F97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62B1F14000E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPsbo6tI;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9mjz28DJjf5IdgDz36zYYN/GhLK0GgAYHY7eTWpXMQ=;
	b=OlKzKCwShPjrliO+/ANhZ1ucp46IGGQ2BjFX8IoZw4Cp5a1AdUQaiT0aElUh6D5viGDpZ9
	4XIH/mBGgyqVDkFgpVSRnL8r3oT4Korvm8MmYgRS1GiyMiz9gIEP9u3jMGicN0TVU+BMcN
	076ag7gAO6oJLAsqTbUlZU4a0XlJ2gc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPsbo6tI;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633424;
	b=KwsbVKR1TRozzFQ1pGv7isb8ey0nrFm9g8O54qXNuCFc1Mj2Tiwf1DAUai4kIb48G68wa5
	PKNQZmnmPrisN9Gl1ZpdM4j3EJvwWKwS57qETRC35Blw1ReiB4MBdxdA2sgpVTpPAw54z3
	AHslaG+wKAQuRSdejsBibCaoSRwR/1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C800061882;
	Thu, 13 Aug 2026 15:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD661F00A3A;
	Thu, 13 Aug 2026 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633423;
	bh=B9mjz28DJjf5IdgDz36zYYN/GhLK0GgAYHY7eTWpXMQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=EPsbo6tIF7dBPYwKkM2aXPv+v+2K4/ex5ijZ50LyFQVUvEPJWbIpmCFBoMJ7CLgh5
	 klf/sTHwBL95we9BVDtWR5/KhuoerfAjIH745M1jtC1HrdLiIoTehrEzZW2Ix0isdy
	 o0Z1My6PhRrocoJWBOg8NnoJnSqThYMQHPL8KaUK+SHNrSVHef6yJiEZ0b7aFgFUR/
	 ruk09dkfzrNQi0wErGmvVZRg9tWxsglt8VZ+/lmS4zBMxkV76t6AZO4ljC1LDfiyKy
	 RAoh2ax6KbWnl1wcs1jQiYJ8AgXW3Nsj4caH+BtDsrgqC920XjSWjYOo9JZfnG+LTT
	 bL9C0Yk14tO7A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 01/18] selftests/mm: raise the khugepaged test-case
 cap
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260812132304.199287-2-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-2-kirill@shutemov.name>
Date: Thu, 13 Aug 2026 18:03:34 +0300
Message-Id: <178663341429.2230969.5576178581449703816.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62B1F14000E
X-Stat-Signature: 3ea6ct9w1hfqhoexu49iumcdt8jfxb8a
X-Rspam-User: 
X-HE-Tag: 1786633424-246479
X-HE-Meta: U2FsdGVkX1+IXvbzjYzBVIxHbqjFh+Qk+eNGym60890ej+pZyly/nruSw1nI7wRsGX2ABtyr9XOqeXAv3rShLYRj5On7wjfEVzWggBe7nl0qlgNlczWPl6K/sQwLwqRWcrYqqKZHxAQR53mkfTZ7ATkDQXAIjl1tJ+OTyG0EunWFMl3fJjdi8TCZcMM5JBpOmxhjIVYlivlTHtHYDB0iYy9gJ4HIWruOspjgqGNgCa4/CGG8L6GJKxgFNNdaM9KydtrR1Zg0qxa42rXPpNEhUvgq1FniF0ovGzDd+ZWZ/XczwMgpXJGTbx9Nf7YTZVqJVcjKkh6PAWyuE0RP0RdDGokBrbP8yam17ZG8ZqGjmz/4fvwCiienjMM40TLfg+5JSDe4BfzvfzuhPuM1uncBnZcEFjkJtCd8tv5NTiL/C4D/yTIzGYl5LWTK54BKvDKWM1WgaDPVwhH++yRqQB+/iVCfKmt6rGftTNyBg74yq/EOpJnsVgonvEKUh7udquTwGARKZ+QuweK2ymuG/DLRkHn3AlIaz8DkJmMLhtMD4Nue/hw+MJ/H87A5VuZMNHwUW+J9Q6xbhmJm/R3PCV+rC6Y6sfqaaxpLBvCYUDsIsGb8ESererlwPImkhFdTEvfEs/aRain8m9s1bCxTDqpKbaAKlM77xUvsqvRWFVF6wfTReTSldtfvT2hZFq2pD1+2294or9NHEPo/B/O+iULs2BsiSiodxLHe0Z+kKo4SUobhpZ1LkfHEcj12sCDHGLtPRZiZPUEUXyvRs1Yji5UYtZRqB6dezPClqkoWxtfOG8XYUc4S/+DDD9dbPceqwLGiwRqj2EfVqc40LB77bn6DIFwr60fR8GJA8Xv3q5SP0peNJn8Y4U34MHrLlGjEo10F949tKnnQLHtRrlJTJpRBu2cg8ehzqUzfSUuJmQ3z0qw5lnGvNW/SPf2YQW3q0y8xlpcylt6fqDi5E2rhW/Y
 7mF4Vvzh
 4cs/hb+rE8t+cSHrNWxt8G3QtvbqtUqQeDVTgqKC7Ljn47u7xuC787JF/Mrdd1THfVLleJ/C7PKIfZqQl/ETAsyXZaiZestzKVgNy1Ems1p9H+y/aMQyrNDcxM+K3PH1yWdak5RK4TjFIFEqkwdH31DpDR1u/1l4TkbU4zWfKbxCn+I5cvzDdSSr61T2aZvx88cA8pKBBrtOonWSCEHe4OBauEPNnUlItJtmGq3eL8W8rgyARrbHquUvdoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 14:22:47 +0100, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> TEST() ends the run with "MAX_TEST_CASES is too small" when the table
> fills, and the table holds 64.  A full invocation -- every context crossed
> with every memory type, which needs a directory for the file and shmem ones
> -- already registers 63, so the next case added anywhere aborts the whole
> suite before a single test runs.
> 
> Raise it to 256.  The table is a static array of small structs, so the room
> costs nothing worth counting, and the cases added after this have somewhere
> to go.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


