Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0782FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4926B00DD; Mon,  6 Jul 2026 11:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCBF46B00E0; Mon,  6 Jul 2026 11:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB166B00E2; Mon,  6 Jul 2026 11:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A454F6B00DD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:45:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 361E0140135
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:34 +0000 (UTC)
X-FDA: 84958776588.30.C038325
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2EF2740003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bgM3Rx0M;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9/R9m8CliZKPXWKCxsJPwwuxejAeoC8BdbX1cAR2zc=;
	b=zOzxnHiBlaSmLbeALhyZVciEJ+/zhe/V1LPYh68Jps7hHU0ABgvQ4OMMOvoaZKCyzwDNL6
	mLI/cYpuAuOJGwEtQ4C9kIq4PA6nScbRkVhHkR5jhSs0n6SAPOomS3LZSM2H2uuqZ4gJNk
	eibpD6oj/+xu9go47Zn0YKL6Jl23xAw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bgM3Rx0M;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352732;
	b=fSfSEoaUzFiWIAK2YcHOnW79jA/uamizw6l02SC7e/BODOptogZJrBtiH/Py0wGkTqBocb
	x3z/1dx6XNUae+LRhzU+lJ+EHZEk1YFoCa75linEq1th4cFAKT8Wir/4w292WG6rG/ayDP
	23ww0rwDHtsyzKWlAL0ankYckwsEcLo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+9/R9m8CliZKPXWKCxsJPwwuxejAeoC8BdbX1cAR2zc=;
	b=bgM3Rx0MSrWlNf2hLb8aII/EU4TRN2TIi0M1aceAudcamX1zUDrAodeN65uAHFhMAxmmOk
	wn1yVPNjvdP6jI/8/m+XX8T5xzyWtLEk/6TP1XPk1k9kn+ECR1W5qc+4FDNpxDAc0TGou0
	qZx3Vae1Ry5c5VDSgX614Wd4tQjsU7o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-iHLT0QhtOVa6q7-HMCiueQ-1; Mon,
 06 Jul 2026 11:45:25 -0400
X-MC-Unique: iHLT0QhtOVa6q7-HMCiueQ-1
X-Mimecast-MFC-AGG-ID: iHLT0QhtOVa6q7-HMCiueQ_1783352722
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94FBF1955DBE;
	Mon,  6 Jul 2026 15:45:22 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A910195604B;
	Mon,  6 Jul 2026 15:45:14 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 8/8] mm: Documentation: clarify where the mTHP stats live
Date: Mon,  6 Jul 2026 09:44:55 -0600
Message-ID: <20260706154500.39178-9-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: bCGJlbgcZDqwYzLp6oTc7S3rEOrs-6c52taes1XA6jI_1783352722
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ece15s831dr7eurw6afm8dqsa3nwt6fh
X-Rspamd-Queue-Id: 2EF2740003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783352731-904512
X-HE-Meta: U2FsdGVkX18HZ25H69Y4piRAkfNvaFkuZVysCFlM+AwiwN9rPHHr181pVxIxx39pG+LxSCTsL0DrePE5ffEF+18ls+JTAJwPgwQww7Y2hcHOyxaI+d3lGLlamf2NECxAbpetQtVpgHQV1ha01laEnz/VPK+XxahfKOqpxu4ovlmejduAo8MxwTyQiZDSzI+V6jnYTEyppVkl8gLhpuAlu1N6jZshSvaY2WPYLVZZH36TF39ONc1eiXjApmtpF+M4qFpVpyVesQj1oJLo5iACVfwGIhLlQKpjJRpYrFXJujLxCUK/Ko6TGb29M4O7Kz5kAzJyqYGzUUoXZwgcKT53qSYxtEKj7Z9Nxr8RSSqEaOSdQ/9bFDE5FAB3adaBSJPhZM1TSnbpxvkFQt9Ah8lomDQJtqWJnaL2CJLJBdxvQcBOqIB+eM7KDh7a3kC3nLOqsX4iNwFXABkr25G3HYgcRKT40mzL1H0/H/WDCfgBeSuPwYWMUf4RAL2WuIFifxLRoVfcZAWCwbbE5yelfsMuFKbKiAeJM/SPzA9+sAdTH72tStaOKUHPwR+tC5UA6HAv/DE6rpDq8hk6pHUdE9uvb36RtDuibIHUTAWdhjQAzmuD9oV8/ThBm4LoqCnvxhBVC+VyGBU8RAxbl2FLRVYqtqmOBx0UUxTEgjl6Vgt1N0w3CLp+SMDbeDIQYdY5aKVEMnNj1M7lRJA6BnGJbbnS5eSuQRqUDcGHqwvxU3cRfGzTIav0q5JOK4EEk4K5tbAkAFGR4IxfytF79zT7JmXwNIA5uuTzAlK6gNuzKmA/6JjQzIX4bXgPMj84ooRomLac0wbJxuc5vpl1lf3fiQpoOLnWl5QMb5GsWxuIS72SDVLvkQfLSf/5pQkWK9O7dJnYrvfBCaCiqXDqzjNqbkqaeBGWbvVx9THkMNZ8QlRE2GUUM3h+11WGxpPQ39Vb5lvlHzYKl800EAx27CI3Yra
 StWMgW6T
 /v2maZdbtY4qVHElLNT8FQBGcRd4oO0wPu/Lr3ULzE1WbMZMkE2fyGd4FNFEJX3u1mpTlz2LGIoedbruy6/kfeeVnWlRKzBjefmGrL7m74qNputN2/73ulZ66QZaDqWkKeiQP4TYrjrGDLUZfTFcUJBV9OzxhHyWRc0YgQ72ba8YLhYX988qSBUJdTXV4rR8XSDJ37BFPh25F2+WCZObHs/cQGoH+EbvHVf3IRxzqglvKgAAYaO6dwpvKbR59/i/PnKSKc7mCXkOFg1NlopFpwmvgYhYCW5splaTt+1MeSF/FFzZwqceUmh6nGgrSkOFnLGYXpqcJca1sS9GTPiAGgAQPsFOpdpw2s+w4VU3KBFRccbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The note about khugepaged counters references /proc/vmstat for the PMD
case, but never mentions where the mTHPs stats can be found
(i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
Add a small addition to this section for clarity.

Also fix a missing period while we are at it.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 23f8d13c2629..123ea281082c 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -224,7 +224,7 @@ khugepaged will be automatically started when any THP size is enabled
 (either of the per-size anon control or the top-level control are set
 to "always" or "madvise"), and it'll be automatically shutdown when
 all THP sizes are disabled (when both the per-size anon control and the
-top-level control are "never")
+top-level control are "never").
 
 process THP controls
 --------------------
@@ -301,7 +301,9 @@ being replaced by a PMD mapping, or (2) physical pages replaced by one
 hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
 or together, depending on the type of memory and the failures that occur.
 As such, this value should be interpreted roughly as a sign of progress,
-and counters in /proc/vmstat consulted for more accurate accounting)::
+and counters in /proc/vmstat consulted for more accurate accounting.
+Per-order mTHP collapse statistics are also available under
+/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
 
-- 
2.54.0


