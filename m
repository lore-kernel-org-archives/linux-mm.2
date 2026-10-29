Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E72360A2608
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGZKVN5c
Received: by kanga.kvack.org (Postfix)
	id 42B046B05B2; Thu, 29 Oct 2026 06:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3AE6B05B3; Thu, 29 Oct 2026 06:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2548F6B05B4; Thu, 29 Oct 2026 06:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03CB76B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:18:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F947A035F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:18:45 +0000 (UTC)
X-FDA: 85375265010.03.C219922
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DEB79A0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:18:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGZKVN5c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793269124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XpQcrguvfG92mrR/1zjrsuKSPP3ZCLK4NMxFB/iVLxE=;
	b=xrqq1UxEnKNtkZ3IcEmde8yVFs5L4oW4ewS0PYp3GhhcCPr0eQIpThxrWdBDJfCQwe5HJG
	Y43KA/OBWgQadfDKYsEOvsr2AgTT+ioYn5bOAof9egSaebkitwjopEHk66gOJP7MictKgF
	HY0On7Sc/AFHqU+VXwte3v7iQVOVQ4Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGZKVN5c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793269124;
	b=oK9LjmbrauChzstVnAHFJ7QpRRv+Z1waLxHdpaHRqdCR2wobcVV/a+wCqCyATDHyIVXXAj
	/Ua6H9Smwa/FGwSTF2zCj2SwK7h95fTWUBK5ZLjCd8gVMPNIJPvGx9AtlZHb+AKAHadW0V
	GEVocx2wIlM3aYw+i/AtjE9yyfDtlSo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F06DD418E2;
	Thu, 29 Oct 2026 10:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B0E1F031E9;
	Thu, 29 Oct 2026 10:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793269122;
	bh=XpQcrguvfG92mrR/1zjrsuKSPP3ZCLK4NMxFB/iVLxE=;
	h=From:Subject:Date:To:Cc;
	b=UGZKVN5cSz2uXvbrzke3kpSyVoCYXXylm+V8uh5iNqo7vR+jXc4fct3C/1z9hoytj
	 q7fgajy4PetaKS1N/uz0mIPjLjzWiA93XYt1lfamyEW3KRvt1xcTrsEkEipoRVT+uN
	 jMzpxuq0ux6ZhRpBEvgLxRv8tLrQjoB1wt8mfX9PAr7a28GT1/QyJHK0NMULn0iDXg
	 fB6kydmZoGzukHD/2kdwdB6Bma16AK+8UNB6gmk/8ThrgP8sdKuesF/OUWOPNIDbAB
	 5d/cCx9Xu8fbkmHVjNO7lMFZpCvcJftvxjXgRuZF8qtUbYUJMwq8G9b12gTpWrFCGJ
	 +1AUYXgsnEk+w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/2] mm/cma: accept memory of CMA areas reserved with
 memblock_reserve()
Date: Thu, 29 Oct 2026 12:18:36 +0200
Message-Id: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMyw6CMBAAf4Xs2cbS+AB/xXhYygJrbCG7xZgQ/
 t1WjzOZzAZKwqRwqzYQerPyHDPUhwr8hHEkw31mcNZdauta4wOasL4Sm/Y69Cc6N4i2gdwvQgN
 /fq/748+6dk/yqQxK0aGS6QSjn4qahUeOx4CaSGDfv/x3LhWNAAAA
X-Change-ID: 20261029-cma-multi-97fd4e58aa08
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DEB79A0006
X-Stat-Signature: f8aan8exj99g3c83rrahu6sfy9u7gpcx
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793269123-388419
X-HE-Meta: U2FsdGVkX18qFpTiURRw1XylnSiz37uz+vcFhM6WVk5BoFb6dfANg+MNAqYekQCVg1KTUjArYanBkPjZbY72x/fuak9e7RrrrTmaU648cpUAHyeM1negYn29dW00hwX2QmbdkkUFKPs/iGSuaPJVEN/B0Bx80RtQaagoHIulpzDxYf5IpYaH1HaJ5hcr+YxxcpZdGEqd4ZpSfaS78U1Jig+Ko32hNjbOcvAwhKo7N1zftzL70MNHT8fk11XIxD0SMZwc+ImCAmVTl2pvqt8QaOHBWOqXBtx/9atqbUvrBKkTPNIMcgbd4VqJLbkjUmRQMDQ9Mzp8Zn83l6mgeNsmV/AvcDdqdMyZTco9zDNNx1RiK44kcHv56IYnfIafHTyOtWE6ZnYamsVwtz0/vDrGYwCbC+3pjDoMAcc/4DfJoxolXECfNTkk2QvXzwo6ziTJ23UrovXIzjZptLZGT/ps2y0G+GIRYrpIiwN1x0tKnjJFPDg17D+1mUNdTtKGZ+KFOlTufMD7rk52jEawZlpET7DiVIvGHOI1Oz1N5sjRs7JMb6l3uaYQCj7NkQNUupftCbVKly5sqIb9aPToyVfkA2d8Y0IW7Yy8uWz5dzHfCX3aWql/eyLlbmpG5i2MIWkp6QRy+89TNCvciftp35vkS/wpxa6rWMFWB46B3XRtPkoDZT6Z0VuWzBe6j4zSg2++CTiuc5AXX3BIC7/eI7qYFFudNAViBVTYWTeokl7NWadocwOdCsrk8CJ68FNcfZz+ubu8lLzG5h3idp9CtBwp8T5hLjDZaB0+Ehck4dFTQQaCZlHrtTpzNKnDAOxc99RCt1piCWj9RHu+ZSIvlzemg8hQBOTsxUBct/t2IAudOLbS7jTwTC76qJb/J+aQjk4Lp07LoLLIW1iV/X+SFxUt/5jb1yMsA/5fCKS4UTeJglkoTAj0wQAZUZWsuyGPFojT7kKMTsfzBYY8scT3vRL
 oD7VFLDr
 3Q23F43RAW98PR/2vmin6mYg17Zwl3WOvGPbQMXpvBkfmJTf0y6Qs9qaMLdJm+AyEXD24up1mB8e1ca5fdEKEDqJbnhStM/XZ8Hvqi+LgGqJ7PhP7wnvAinULO7lM/mWkRok8/xaVkXPxQ7t5mC081U0Hc6C55jHbFYiKDLRYiVVHGdkVjuNHu8o2V6szabNsmjwJmfHa3feVZzK/ZlMzdnDCzD4DOEsKql5dw9CFdM9R+tUTylvlZybPfdBRNhfuHlQ8/TGmZ09skRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pages of allocated CMA areas are released to the buddy allocator with
__free_pages(), which does not check for unaccepted memory.

This usually works because memblock accepts the memory it allocates.

However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
requested with cma=<size>@<base> are reserved with memblock_reserve() and
their memory is never accepted.

On TDX and SEV-SNP guests the first access to such a page is fatal.

To ease the backporting, each case is addressed by a separate patch:
- patch 1 accepts the memory of multi-range CMA areas
- patch 2 does the same for the fixed CMA areas

The second patch won't apply cleanly to 6.6 and 6.12, but I believe the
stable team LLMs will take care of that :)

---
Mike Rapoport (Microsoft) (2):
      mm/cma: accept memory of multi-range CMA areas
      mm/cma: accept memory of CMA areas reserved at a fixed address

 mm/cma.c | 4 ++++
 1 file changed, 4 insertions(+)
---
base-commit: 5b0764a53235d3c77e1ed674e836e1b3fe1a4b1f
change-id: 20261029-cma-multi-97fd4e58aa08

--
Sincerely yours,
Mike.


