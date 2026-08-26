Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D112C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B72C6B00AC; Wed, 26 Aug 2026 05:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668D16B00AD; Wed, 26 Aug 2026 05:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556EE6B00AE; Wed, 26 Aug 2026 05:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37EE06B00AC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5D2312018F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:39 +0000 (UTC)
X-FDA: 85142870358.01.41C974B
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 05BF04000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SknVIbGm;
	spf=pass (imf27.hostedemail.com: domain of 3bK-OagsKCGE9BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3bK-OagsKCGE9BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735918;
	b=yUHKanfKVN/nhCvyZJkOtHwdZQw/iWJkcHx/81xcnLKz1+6dJw2EcNRCU/5mzc5W0nf5Ip
	URPim7U1VRpNG9jiDT2jX7kKEyPEOY+QwPuHHXl6LQc6eRgt0QOmpocGJXhYME7xw/jxkn
	JCaT/xcNOZL5P71taPGYtOH+06F198U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SknVIbGm;
	spf=pass (imf27.hostedemail.com: domain of 3bK-OagsKCGE9BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3bK-OagsKCGE9BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wc3a2+OEtllLGwqS/G4AFzAVkgMCaAbj12kGjFWNwhs=;
	b=ujlM6hjtUnl3ozNpinpQxhs/P4IIdJqHItiTdvqSpK2+uDSHrlMHBkF1WjXfjwSkVkQo8d
	I+crS0tJlxmz7i8IqSj00aKN05iFoiXRWROM9i8UPrL9+r5IHjE3JNtRbu7oVPO4EkeUlK
	whCBqSwwes8hlv7j65K8GLmx/32GITw=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce8a76df2dso16623905ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735917; x=1788340717; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wc3a2+OEtllLGwqS/G4AFzAVkgMCaAbj12kGjFWNwhs=;
        b=SknVIbGm+7RWUaBuJ6CriGZsHpzPlHVpFf26HiAB7WcwHoN1jKlGvkW2zUjdYqsvRD
         4wac/AZeCSSKDbuVFtzQoTCeOuFdzU/+2iViDNwhuekSYx54No82vpCKAvmcxshaXmlP
         QfxpfCSB1YAtGvBoM0HeFYg2hBbxDv57AiZSXB3DzF8GYyuDKvnyKu9Fb18w9jMihirY
         fQ+NDUMBDRjCjx6mpfXlwyLHDHO1r5v7JK4j2ovKPkHiTIq4L+H5Vk+WvPgZ/AAUrmMG
         CwSKvAHGtbo86wTyjxdSEq7Fq8/5xeFqi/6n5r3pXhV0F71Qqx7aREbE0rB8m4MfnwOx
         W4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735917; x=1788340717;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wc3a2+OEtllLGwqS/G4AFzAVkgMCaAbj12kGjFWNwhs=;
        b=kjH4YEATsv1D8AawQ7pQBV51dIvjIxAnNJYndwgFOWtMwUU25e6jzb6I02xeW9G8r0
         SFDVOhQo1PMV7gcAq752ycHdsNz3ayZ1U3q4MBN2Ld86tiEuC8RVRoQ8Edl+DQTpcLUg
         DLUO2SPvnLLDSGoG3ckdoF8ZLfQ67qjQfI4T+4wOrHQeDOG+8ubwrtCIcpkEdv+MVA18
         +LHVBXq5XzH7Gz/r0pnL2za8tGCSJijEo0Ib7hL3pnjZCSoCfVk3iHW0XCkH+xuFpba7
         LurvI2aWcpBSMQtxLH+YMUP1oxChh5WtDaUmiB/nqCfuA/6Yx8gu83MhiJa1BjydFT/O
         1vWA==
X-Forwarded-Encrypted: i=1; AHgh+RooY4jgoVO0ypat8cxweqypUXWCedbk1PawM1PuvAU2VrGYq6ESimRCzHKkjsQNiWqqU6yKQO7rlA==@kvack.org
X-Gm-Message-State: AFuF++mNPjW5SjcX2WFGD8ACaac5XvQHf+z+AgZbRtVTE23NE5P6DGj7
	7VMQLOALNptdGVX7UJlYM8g/gf/MKlnSFRgwXkMnr+ZZRJV1JXrKtrFdH7bmZ3HHvAWVHhgniIO
	RdF6V2oz7vyE2M6SIrDxT6w4+AQ==
X-Received: from plbcp5.prod.google.com ([2002:a17:902:e785:b0:2ca:b48c:5a92])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:324f:b0:2cc:f5b8:4c2e with SMTP id d9443c01a7336-2d707b45a87mr94906615ad.9.1787735916498;
 Wed, 26 Aug 2026 02:18:36 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:15 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5838;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=GtZbHtkgKKmD1ykIZ1T+aJT4kkhlUaxT1aZ4xCvFTqw=; b=31p44BxawoGJ9r8IPJTTeLYxIv5u9shr6L2B0Osy/+Cr+0UKzzsl7/FoRJOIg3vjXE6Tkm2yX
 UgwpvmnCSctDh5OfgPRHQt5miKkx2TMsXdZLvmxNKBAoutH51xOD2oC
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-17-0a15d8a799aa@google.com>
Subject: [PATCH v11 17/46] mm/gup: factor out LRU cache draining for folio
 into lru_cache_drain_for_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 05BF04000C
X-Stat-Signature: 4xcom6mtgwcmppuj4srn8tufhntwa66u
X-Rspam-User: 
X-HE-Tag: 1787735917-340281
X-HE-Meta: U2FsdGVkX18apcCgKOigz8MFg1UJ1KlNRgmwXxQqsvqKIoK+29VQe6GbkzMQM52t27IEfrXrKTJmH7LvGOgJQ6+ZMjR5GEGPxpOozQhniM2mn5keAZCh8NtkUTwjYrvWxnP8BnFuXuisRBiiLj7prAMv7d2hSm4fMmYPweblAEA/M5s3CBIzDE+QY5xFGRcX3sgLN7Cgw55PHG6kqIxt/YVOvdrA4PHRSbRHWnpV0JuccUeOxGfNEaRlWZ8YR1hqrnXROGFFm0mfNKclcv97np9ymNVib7DnPJd4eAzdj+/wI1PifL4DI/8OrRVebs9FjW3sM1Bes85fVNM6f92VAc/ohJ3DvdkdUisit5AoYg/ANOr0/TAjrmkPp5LQBnHJyfNCa5MhyA70OZflk0Jq08gBqW5y76l0zkTh0b82CXPIVVNaHwMF/riYO1Jxj+eaV1p+v0NJKZVwGwZWg+WNBgSGljEpv0ScTQY718iSXANFze0kG75GqQq2Igefh8ajUTfTlq2axTZq/iLQGKvylWD0dv2FOCHbJdRsxS7v+BtSAXTtKfXP9lakEfm6rrrAhW/dSa5HuEwQfP1NqN8fPTcdY+OR+Ng3x0FRrlS6H0Ilqt85de5Wms2YKFwiwnAB/d0Um+EROLIrlDmhcJqJCcl0wwq/TkO6bwg8XMrNnqvPkt7D7lmQkyb316XVQhQ/EaACWdQo4gjSXRNlYWZBtyMAcKsUbB/kwcZsqJzdMmyOSfhjn71JSR+n4ypk4hToiHVFaGbL2c2vpHOVe9WNmHspjUCq7bSMLJmjfXOFAUfvJr1MdC6yIJPJ6N4/6gwdJAeOjP0EUcv4IelWTG7QAwu04seHkC4SZBvqCQ/YKL4btLBd30r7HH8qCOH2EE+t/33CK6hMMTkr+qEQgHhHVKMXv63n06oIZrzcHW8E5/20gUIoTsJ1EKdShjIFcm6sOWntWUZ75WdTrI3pBJY
 v9mAKkak
 pmcJ3e8v5te+ujlGlVFo1k3yAXw278bUq7fFXpCa/UHO1GS69g3m89WnNQrssvX4HMD3Oltn4Fnb/xo78FsrnSrg3N2zj7Cx7sQkfwrPMXRu8/fF2ifnu7FPyCw+yD+lY1fWOdKJgJ8+9IUH4N1jikKX8+FixlN8Tx+sxrQXeS+c/U7PhskcPoqrRHAr0dLBYO7xqWDh44ncE5ISDPinfzdWbOQtZz6fuXcllfs3iRdcs0oicSxdjaByL4AxcAxEWQokiNPNDcuIyKrn7+BBRxoojkowqelweGRgTazhraU0iZ9GbgWk+8H75RgqUH33D14URVj/m6F5OioAG3so20e6A22nQkXRGeQ8AtFrEiP3LIIr2juVCw6ZgZAmf5kvD/0x7dx8JzhvrFPyHG1zxoCeUwE0anD55DTz3//+r+DxRT8y/UP73Pwen2h8kJGNboazJvjIjJ5m75i/OTLpg4iqL/xAPhnfv9YrgNaKGDBM/LGNXnlcOOY4k0n+D4wMEGI1CKlm6YJQ7LYxoy/MUQVTMrfXh7acZv91dAQswxeBCSBDWlZpThUMqSOkJQa2Ni57GBXGjcgjNeQ9wASQBSvGiHQLnlbARd2dEnT+qI0WLrH0iVlODmWjcphDlUEmsk9NsBl90nyO5LVJ9ZOXJLLHTdPCn22N+4/pZpi3iiHBDq0jv9uZYnlM0Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

KVM with guest_memfd wants to remove any folio references due to LRU
caches, as it really must only allow to convert folios from shared to
private when there are no unexpected folio references (e.g., from GUP
references).

So, to drive the refcount down, it needs a way to flush the LRU caches.
Let's factor out what we have in lru_cache_drain_for_folio(). Document
it, and also mention that concurrent folio (un)mapping might, in theory,
miss detecting LRU cache references. Keep obtaining the expected refcount
twice to minimize the possibility. For the current and future user that
should work, and we don't really have a better alternative: we could
detect if the mapcount changed, but it would still be racy and add more
complexity with questionable benefit.

Maybe there is a chance to avoid the draining entirely in the future,
by avoiding extra references from the LRU cache: Hugh thinks there might
be a way. But for the time being, this handling is unfortunately
required.

Make folio_may_be_lru_cached() accept a const pointer so
lru_cache_drain_for_folio() can accept a const pointer as well.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/swap.h | 11 ++++++++++-
 mm/gup.c             | 20 +++++++-------------
 mm/swap.c            | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245baa..e625d64c9e13d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -317,7 +317,7 @@ void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
-static inline bool folio_may_be_lru_cached(struct folio *folio)
+static inline bool folio_may_be_lru_cached(const struct folio *folio)
 {
 	/*
 	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
@@ -344,6 +344,15 @@ extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
+
+enum lru_cache_drained {
+	LRU_CACHE_NOT_DRAINED,
+	LRU_CACHE_DRAINED,
+	LRU_CACHE_DRAINED_ALL,
+};
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained);
+
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
diff --git a/mm/gup.c b/mm/gup.c
index 0692119b79043..fb0995dc495fc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2266,9 +2266,9 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2287,18 +2287,12 @@ static unsigned long collect_longterm_unpinnable_folios(
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
+		/*
+		 * We drain not only to make the folio_isolate_lru() succeed,
+		 * but also to remove any other folio references from LRU
+		 * caches.
+		 */
+		lru_cache_drain_for_folio(folio, 1, &drained);
 
 		if (!folio_isolate_lru(folio))
 			continue;
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8c..8e965c8ce9aa9 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -950,6 +950,52 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
+/**
+ * lru_cache_drain_for_folio() - drain LRU caches if the caches might hold
+ *				 folio references
+ * @folio: The folio.
+ * @extra_refs: Extra folio references held by the caller.
+ * @drained: Drain status for batch folio processing.
+ *
+ * Drain LRU caches if the caches might hold folio references. Start
+ * with a local LRU cache drain, to then drain LRU caches on all CPUs if
+ * local draining was insufficient.
+ *
+ * This function detects LRU cache references by comparing the folio refcount
+ * with the sum of the expected folio refcount + extra references held by the
+ * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
+ * cache references, and there are rare scenarios (concurrent folio (un)mapping)
+ * where this function might miss detecting LRU cache references.
+ *
+ * If @drained is not NULL, the function will avoid re-draining LRU caches
+ * when processing multiple folios in a row. In that case, the variable
+ * @drained points at must be initialized to LRU_CACHE_NOT_DRAINED before
+ * the first invocation by the caller.
+ */
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained)
+{
+	if (!folio_may_be_lru_cached(folio))
+		return;
+
+	if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED;
+	}
+	if (!drained || *drained == LRU_CACHE_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain_all();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED_ALL;
+	}
+}
+
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
 /*

-- 
2.55.0.887.g758fc8c411-goog


