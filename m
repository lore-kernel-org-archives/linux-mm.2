Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1DEC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7AC6B008C; Thu, 30 Jul 2026 06:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0C96B0092; Thu, 30 Jul 2026 06:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5D26B0093; Thu, 30 Jul 2026 06:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 921196B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:21:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18A6D140959
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:21:57 +0000 (UTC)
X-FDA: 85045052274.06.5B03FFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 47C861A0007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:21:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpe6HTdY;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785406915;
	b=ji7BQISweuaPfyu0S/k3hLBJeHlP+Wa2wvqzLJXj+H9VfPmGEGTxJ79UPpSlJqLQzkFIZ8
	MmRUeOL43uHBRW8KdomjVo9XLgR3bQz6cq4kVsfpANAfaRWmwR7jVw2qh/t2XNYhDg/myl
	2d+uC0IRmjAEXxrnfZqWQOyO/PWIGho=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpe6HTdY;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785406915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGmEmde7MD/lWIzX2wq97sKKbT26z6cGRrn8j8z5Oh8=;
	b=B09yhcms57Bi/gh/JmM6V9QWHyJ8+8Y9vp7C8nmcva1RFpCbQy+EM2wg7MG+saepbzuaGs
	ETiPlka8Crf7BW3L4BaCuobdkZlTCjediF6WxDgFkk4HfnLylT2/wPSc95exJjCYJqQEm7
	xyZlyOo+QJENeLeqYVxql/0TQB/SkPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75F1141412;
	Thu, 30 Jul 2026 10:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FF51F000E9;
	Thu, 30 Jul 2026 10:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406914;
	bh=TGmEmde7MD/lWIzX2wq97sKKbT26z6cGRrn8j8z5Oh8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fpe6HTdYFr0KeH+LhNV7pIBaW3RmGyopHxQrgNpLi/PSI2EixHLupP7jGPJHl04UW
	 ETbOOYJ+adlumdUmUpDzRFOBoal/1hSg0Xq+yTO3VZ8EnTAQJzMKNoW0R3X8T52yxQ
	 WLOI2oTtjiqLMJIeo6X0vkYxXQXaN/kELQHa1Ln0/mgYuDde120JPWOURohCnLKY7q
	 XEmqMj/jlW4hue6EQdjSr/RnM5b51pLtf+ICpqKumAfdMu6MJMEphysXr1txy2o7aG
	 ZzDTDzhP+a/vbrBXhmxH4fi6zJvFgFwfSip09n6+eEpUkY8wuVrubJaUvyzyyLnIY1
	 Ybr0wSkk8bjXA==
Message-ID: <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
Date: Thu, 30 Jul 2026 12:21:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 "hughd@google.com" <hughd@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3czukekn8imqb1pihwgtmk91jzw9r9xs
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 47C861A0007
X-Rspam-User: 
X-HE-Tag: 1785406915-781632
X-HE-Meta: U2FsdGVkX18nqvoyvVRdO6hgmR1ZbIIYWM3SsGZmTEnfjZtwn7ogUWwIVHfdxMHxwDlLZMBRi4hdwRF3VIrRaIQlE8+aXDOvFUtTualo5gkb98H/20hkAPvrhb77PbbSpxS7sdOK9H9BA8tHfUT9hG06GNsd/XTqcR66DXSMOk+PNAVL7Wz1b4a6p8JwsIuK1WOpgu6qOrvIbVaFqBA63MPqD/6dTi+V3ppq5Q51/PeyoWZXocPOo33SKyLxNQ1ngQMQtQld2SB4aOyyPK8b20f4SwrwbDwZ2dbsEpAOR0hAXgER3yYJOfWxpg7QtcKrtLOV4miwadv6W4infP5T+RijzCJLSuPPA7LeAZg1ba8oyxQegPLw9k3UjY6e5HzL8tqdsguCTn3ddXobEdi2i19d8XTccB3zt+sUGsFG82ktePZILsESOyLNZ7QGz43rzcOZ9kC6Nb65R3A801WNi4eCxKmYsdtjuG+eJ8s5xdQ8IjaDOifj8R2zpp9bFXSZvqP+Ha5olT95zT3V1+kTHnUSXt4+exyRQXK3TaGDbK6U6WLSTr7liBVOsdDvK2cq6akRDZsCECUDnnsJ7dPeLl40ZqqdYJ8KJ/5fJjQOtNbunI6HUO44Z9u2XgAEXTLWAa+HBX+TlztjHPA5k7VXvX/ZGaU2xDzV0aoeEGi/X/G2rNoj2rSD1NcTzAl/y9Il/vQZt7nt0AAppRFXUFAfLcRVDe5kBd6eBJBRc/ZISERp+otXrK2WruPGA4SJHaeetFun6vEibgC0iGHHzXOM/xoxHB1Sp9/CVgW2HBoHGVIK2AtZIs8CRFUmXIc07e9j5ISEp02/xpTZJh8v1oHLY79+XHZEYDWjWA4I4JCTuyYpxfUbrGmWZNTxEhTfYT5215BnyK58DmgQzON3op9N6fHmNs4YhdS6tVXpQSfM07tBiDwlCflUeyP2qPvIj8TByIhihl5ps+yL5LSSlmh
 CoKgDPb5
 OfEO96FAQXmKUTbNmDJoKou5/WDisqKpPpYUU2N85pJ1/Y4cHVVRylXtgEcIl3BZywtKpX40zI5bXY7LK2rBzyu83dZ7w7hqNPEqHzORJiQ7oLRw0ScCMDRrS7WDpxf+ygpWC84SHWoTG+m/vG3aQG2jlmR0zxK+g5UlswCr+9+raf+YlKjNexR7UNibr+ZaCDhp3X0wONSSBVhkNe7mhmW4TDJk2p9Jb/zPxCTRz8jGCyin2EidweRp3v9KrFvwVSONd6Cdsx1JGA/1oKKNnkaGpEscH+98xu36bCbMjZ8BFSzQFBktBj5BWBapzGJyA0/VpJQ1Ah7rZySqAeLv7BpTP5RglSHvIe7hsJZ9gfLQHrGBuL74VshcAZBreIjdbSp4NrVfwYLJzt1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 02:35, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Extract the progressive LRU drain retry logic from
> collect_longterm_unpinnable_folios() into a reusable helper,
> lru_add_drain_progressive().
> 
> When attempting to isolate folios that may still reside in per-CPU folio
> batches, draining is escalated progressively:
> 
> 1. State 0: Call lru_add_drain() to flush local CPU batches.
> 2. State 1: Call lru_add_drain_all() to flush all CPU batches.
> 3. State >= 2: Return false to stop retrying.
> 
> Refactor collect_longterm_unpinnable_folios() to use this new helper.
> 
> The helper will be used by KVM's guest_memfd in a later patch.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  include/linux/swap.h |  2 ++
>  mm/gup.c             | 19 ++++++-------------
>  mm/swap.c            | 15 +++++++++++++++
>  3 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 8f0f68e245baa..cd54f73f34f39 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -344,6 +344,8 @@ extern void lru_add_drain(void);
>  extern void lru_add_drain_cpu(int cpu);
>  extern void lru_add_drain_cpu_zone(struct zone *zone);
>  extern void lru_add_drain_all(void);
> +bool lru_add_drain_progressive(int *drain_state);
> +
>  void folio_deactivate(struct folio *folio);
>  void folio_mark_lazyfree(struct folio *folio);
>  extern void swap_setup(void);
> diff --git a/mm/gup.c b/mm/gup.c
> index 0692119b79043..5f00435e2c635 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2268,7 +2268,7 @@ static unsigned long collect_longterm_unpinnable_folios(
>  {
>  	unsigned long collected = 0;
>  	struct folio *folio;
> -	int drained = 0;
> +	int drain_state = 0;
>  	long i = 0;
>  
>  	for (folio = pofs_get_folio(pofs, i); folio;
> @@ -2287,18 +2287,11 @@ static unsigned long collect_longterm_unpinnable_folios(
>  			continue;
>  		}
>  
> -		if (drained == 0 && folio_may_be_lru_cached(folio) &&
> -				folio_ref_count(folio) !=
> -				folio_expected_ref_count(folio) + 1) {
> -			lru_add_drain();
> -			drained = 1;
> -		}
> -		if (drained == 1 && folio_may_be_lru_cached(folio) &&
> -				folio_ref_count(folio) !=
> -				folio_expected_ref_count(folio) + 1) {
> -			lru_add_drain_all();
> -			drained = 2;
> -		}
> +		while (folio_may_be_lru_cached(folio) &&
> +		       folio_ref_count(folio) !=
> +		       folio_expected_ref_count(folio) + 1 &&
> +		       lru_add_drain_progressive(&drain_state))
> +			;

That's rather nasty.

I was hoping that we could embed more logic in a helper. The history [1] of the
refcount check is rather sad:

https://lore.kernel.org/all/c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com/

... primarily because of mlock() handling.

For guest_memfd(), would mlock() ever apply on a path where you need that check?

Conceptually, I wonder whether we can do the following, and rely on the refcount
check only on the mlock path.


From ae30f7594692b0c47b44922c26b6480dd9584872 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 30 Jul 2026 12:20:14 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 66 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 14 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 99902c15703b0..ec43071bd035a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2259,6 +2259,56 @@ static struct folio *pofs_next_folio(struct folio *folio,
 	return pofs_get_folio(pofs, i);
 }

+enum lru_cache_drained {
+	LRU_CACHE_NOT_DRAINED,
+	LRU_CACHE_DRAINED,
+	LRU_CACHE_DRAINED_ALL,
+};
+
+static inline void folio_likely_lru_cached(const struct folio *folio)
+{
+	if (!folio_may_be_lru_cached(folio))
+		return false;
+	/*
+	 * Having the LRU flag clear either indicates LRU cache references
+	 * or LRU isolation.
+	 */
+	if (!folio_test_lru(folio))
+		return true;
+	/*
+	 * For mlocked folios, we don't have a real indication: we can only
+	 * take a guess based on the refcount.
+	 */
+	if (!folio_test_mlock(folio))
+		return false;
+	return folio_expected_ref_count(folio) == folio_ref_count(folio) = 1;
+}
+
+/**
+ * lru_cache_drain_for_folio() - progressively try draining the lru cache
+ * @folio: The folio.
+ * @drained: Status initialized to LRU_CACHE_NOT_DRAINED by the caller.
+ *
+ * TODO
+ */
+static void lru_cache_drain_for_folio(const struct folio *folio,
+		enum lru_cache_drained *drained)
+{
+	if (!folio_likely_lru_cached(folio))
+		return false;
+
+	/* Try local draining first, if not already done previously. */
+	if (*drained == LRU_CACHE_NOT_DRAINED) {
+		lru_add_drain();
+		*drained = LRU_CACHE_DRAINED;
+	}
+	/* Try draining all CPUs next if still not an LRU folio. */
+	if (folio_likely_lru_cached(folio) && *drained == LRU_CACHE_DRAINED) {
+		lru_add_drain_all();
+		*drained = LRU_CACHE_DRAINED_ALL;
+	}
+}
+
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
@@ -2266,9 +2316,9 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
 	long i = 0;

 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2287,19 +2337,7 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}

-		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
-			lru_add_drain();
-			drained = 1;
-		}
-		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
-			lru_add_drain_all();
-			drained = 2;
-		}
-
+		lru_cache_drain_for_folio(folio, &drained);
 		if (!folio_isolate_lru(folio))
 			continue;

-- 
2.43.0


-- 
Cheers,

David

