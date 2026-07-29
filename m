Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 105F6C54FCD
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 22:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54AF6B0088; Wed, 29 Jul 2026 18:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05696B008A; Wed, 29 Jul 2026 18:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4676B008C; Wed, 29 Jul 2026 18:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 730986B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:26:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F11A14021F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:26:58 +0000 (UTC)
X-FDA: 85043250516.15.A7188DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5195BC000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:26:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzIeNJxS;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785364017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MIIT9QahtjXyg3K5yJSBOlaChmM2DGjfHykMVmRrdU=;
	b=quOLDx0OZcv4zsnj4XfPPzf94MyrAsJ1gLKWyd2GrHPTZrj0e4Ol+qpgr18EmS2vXEqvBM
	pxIWTv3fY61bj4bMfsEW96abVgPMefNerjnv5b2/RHEDXFLWT9mb5No3S4eDUBu/ICxe5o
	8Df5fBcj295DYJL3kLRoydfCPSnmWvg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzIeNJxS;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785364017;
	b=zRCiPFwQMqwcuH8PRQkhfrhHSh0elKwui1z7YTaTVP5q8gGXVgRfV57U/Mvua+5frUuTxU
	4K0YlpWatkkDGq7p3dQGROMnumTcNtsHAUTQ2t3qUY3Rhrc5Mt4YfMrhJ1TRpMWReWKYkP
	DPfHbfvb5bYX9iNqQx+AZAMGqLmOLZ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46B66600AB;
	Wed, 29 Jul 2026 22:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FD41F000E9;
	Wed, 29 Jul 2026 22:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785364016;
	bh=5MIIT9QahtjXyg3K5yJSBOlaChmM2DGjfHykMVmRrdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzIeNJxSiYMJZi5moMkBeoDikkPefLAKWRKIkswjs/I3BM7cwAFB6skBxN+HC/Afe
	 ww9zIxS9LLQ4YpRutQRIbWdmRH2iCX90ic/T8EtxtRfB8wv9RYtIAlXFutZC2J1of/
	 XAbVMf1eRe4lHa6uGBxa8bnqcvb2G5Z9AIViuU/XoJC6kIO74m/K/hMqP6WEzl+jVx
	 fb5PLnrjUl4+NuOMPa2f+JG8U1wrnRYIlsBmixgm9pt/t7PBNMM08TjkVaUhc3K4eW
	 XJGCwgC8+gTZXX/krkbZQZsHzFUoRFPSh1ZKY9/i5EeVSHJqexlv0teH2C809KeYSJ
	 21AzrBDn1ONbg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com
Subject: Re: [RFC PATCH v2 1/2] mm: allow smaller large folios to use lru_cache
Date: Thu, 30 Jul 2026 06:26:51 +0800
Message-Id: <20260729222651.31321-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <229c3079-8fde-41b4-9d6c-f0e34f780555@kernel.org>
References: <229c3079-8fde-41b4-9d6c-f0e34f780555@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5195BC000B
X-Rspamd-Server: rspam01
X-Stat-Signature: ned1wornjngxb5b7gqwbf3srpmwue6zh
X-HE-Tag: 1785364017-371707
X-HE-Meta: U2FsdGVkX19MI+oKBBl4hYcHyO7F2QkJMgINy3tyUczcYIqFXqtcn9L43jow65UFgwruZ0L33cDtNNU4xrWpzqErOEmx9Qw+Ow4ihWlCYAJSDt/r2l8pbhlIXYMFWwCaw4Uy1boeZjq94VRu9jhQQGoMqgCR+WeePtAx5VwZPfyKfHDvwEzzZS2gTmHYXDnATVegf9wqBTzQMwL8hinz2hLR6TGtJ3jVnObgiQSsZS698+0JFWtswzNkNWevrdyeeMfIcnLkoKGcV9iDm9WhLOQVhhTqgKPkrVFc7zJOn0e01zBQxxlqV8uLC0Eer6x4liWObzQlIxl+820zyFR3VEW1FkG/I/e715u3T3PD90MfkP0GBGr6zTFly8R3DHu994q2FbsXKFtRsu7+m0qbmrgm5vyKb78Ikn9UCaCFib0Ft4mpI0EMpqPemVlfKf9JIbVBpm03BQG7V1Prihnkc7jkLbEe3RBr5F2eU1OuwEAIhTBpk1fW1YZo9o8uBzDZ1KK9FjN4rJdwg5hDUjBdWyI1faKNzrgdyWSDAZVAnTxWkwTNuvR76Wg9loK70338AZMkVmXYNIYBcqDkc409B9hHJBYIpBPiclwneLHVCuATnwZkj6PHWJSrPajDWGn+LJZJvVEHs9qpHF6itZOG7l2CJtKb3I5BYZMmPTGZVDTe9plZQszWly/tAw6dzWHUjFg+SdY8PP64HmoNneJmxQoZ9XC47S2Fn9RcCl0ZusnLKqq2y0R2g+n0c8PnrNsoku6bNsAHaVQPPZKvxx4bFD6yUQTRZc05y1UzHkXJCDAStu6Ow58hJoxnoZPBMh+wX2x+H9JWB2ey6ZjkNmsKmuDdP7Cs9c3eFIVdQK10ovU7JAX9gavyqFjxlhjOeXSLyJJRKPUiVjcafK8WnkFoJBlvEUEmmrXt/Lk5gsIfvw96oI1m7kGlLyjTMhx+s+PlX9JuIiADvEPlfGpBLOg
 S3BJQtRW
 RxHDbhkJs5+tvwP0javPzoxcxyEXjM1eSdzXuqggMzscThRtxWKhN7Je3wji+OFT4JGf/7liJ2hkiP7vWUqaYkzz4ZrBO/U0gITqHCq3dv+Kbzz1L6QZPOQYTz2qbxXxt9t1WhDlEFG+ZmE8SdyEjL9+GjPRmdRlQBqM1WFRp4pN5vAWSgSL7lGhadXPLPC0MDcBqC0W1m0/oiRVL9/ZCU6efuDfyBfmfbEFcMHJItwqyn3mTf8TfbPF3FhWsbzn2lMrw5mLc4lwQTFTIkD4mqPcOuEucai2dZQS77VeP3aipbjyXLEyoK0Dqfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 8:13 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
[...]
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 8d19be675baf..9c5f7a11c7b0 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -316,9 +316,9 @@ static inline bool folio_may_be_lru_cached(struct folio *folio)
> >       /*
> >        * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
> >        * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
> > -      * will be sensible, but nobody has implemented and tested that yet.
> > +      * will be sensible.
> >        */
> > -     return !folio_test_large(folio);
> > +     return folio_order(folio) < PAGE_ALLOC_COSTLY_ORDER;
> >  }
> >
> >  extern atomic_t lru_disable_count;
>
> Sashiko rightfully raises that split_folio() can now fail more easily.
>
> So we might want to proactively drain (earlier?) on some more of the split paths.

Yes, this is a pain. I haven't tested it, but perhaps a
conceptual model could be something like this?

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 04e8a6b55343..fcd449dec96b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4069,6 +4069,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
+	bool maybe_in_lru_cache;
+	int expected_ref_count;
 	int ret;
 	pgoff_t end = 0;
 
@@ -4154,7 +4156,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
+	maybe_in_lru_cache = folio_may_be_lru_cached(folio) && !folio_test_lru(folio);
+	expected_ref_count = folio_expected_ref_count(folio);
+	if (expected_ref_count + maybe_in_lru_cache < folio_ref_count(folio) - 1) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+	if (maybe_in_lru_cache)
+		lru_add_drain_all();
+	if (expected_ref_count != folio_ref_count(folio) - 1) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}

Best Regards
Barry

