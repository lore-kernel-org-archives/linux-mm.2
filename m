Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FBB606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mL+W0iwj
Received: by kanga.kvack.org (Postfix)
	id 087B36B05B6; Sun,  1 Nov 2026 12:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0120D6B05B9; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57436B05B6; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA496B05B8
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 632811209F5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:58 +0000 (UTC)
X-FDA: 85387175076.12.4387A1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 39F21180009
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mL+W0iwj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/x/wiZazHW4/ffi1+IFEOVxN+Fc8NZQPK12ktyLeSjw=;
	b=ErRdxbAatDNL1vhcP/cFEXYvUHudmbsrRKZZd2j6C4n7GYOE6XqNjj7yw2H27FBvtbDjet
	whk9YRCA3gqZCOTlxOWFWylK7S5oBN/qgD3ubtV3Lhd3otYmInXQmatz6Ac2rd97mw1BAC
	O7KTZFpEFmh/vi3Xq9ctIqQ+YMRf/ns=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mL+W0iwj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793552696;
	b=ceWI1y0AKm0HDFOoUGKWroSMjf4dhYcvZegMhpeJBNuuN5j6vouysTKzzX5Dw/sFR+beGp
	AmW290cQZ1CyEGL1EEuIXYao/bzSEpzGQtkA3y08g/6bRBQM/KyNn2b+XB69jnAUlZ0cJq
	kfrLCN6sSMZqgqygAhD6ka/EK0Ez1bE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1613C43F66;
	Sun,  1 Nov 2026 17:04:55 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793552694;
	b=jblMK7gODO78ltyl6FMSpxc8gVFT+AESY7FQCrA8+/bKj78QK+wI2GcXGKCgkrAI4GuF
	 +TNh6uvg93ULqUu7OalPoWzUD63BNofd30bhasCUVXx/xpxeIVOxzGZW56JTep2ajnZCI
	 lwWoEz+M2YICvucDmxWJHmnSEXb5gtBPfhoFuLbYQqHOOZYhRy3uZJeedwAoGDVaJ+WO8
	 GXXmgX9QWlUHycu5y9W0kP3VzY2Xq6uZsPzk8Cq95WtbsqhbiySL40oHNiSucE6RFQWwH
	 Wf0y9gy1vrJKvDvgs8UQYcj/69Zy4++kB7lMLYPL5OEzoTQ+jFFnncOFj9CMVKtAGeQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793552694;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/x/wiZazHW4/ffi1+IFEOVxN+Fc8NZQPK12ktyLeSjw=;
	b=eMQNcjvPAfaW1xbzVnYERHCbHSWOMmRJvRRDCe8j5eXE9LF9Kam12Gd/AZ6+6dxFumik
	 UhSQC1ji+fVdRXLCWERNfkViQ9clAWkBCvxC5LAx6qkZ61p55/8nZeNhi4v+2rhdSbLYL
	 EIYjPuhxxBKPVk6RGX5dg3nQoEangLyMnYznCR3S2NDuAIdf5wuG1ZHCsRIBLz5fnAp6n
	 32spjuJavigP0X2cwyv9VTwSZvp6yNwsaJZwW0RJXwljDCKgj1oRv828DxNcy1wg0OFUk
	 tJ/BSwhivTC8t0cLC/nBCohEeVmbxSt3+gxo0njIHyoTiI2AU9Deb/Rs7NVEhT+Baew==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AE16F1F00A02;
	Sun,  1 Nov 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793552694;
	bh=/x/wiZazHW4/ffi1+IFEOVxN+Fc8NZQPK12ktyLeSjw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mL+W0iwj7lkIQNQPBWZJQsIWGywKDFKyQjpS8bh6tvatlMSRkeMTXW4IyQ83n2JMA
	 Il/zHMg0gEnBv7M4DNP9XoljuBYxNMqJyloI2kCiwfxl6C8b5dLzMTiKKYSD3F+aMB
	 B3JPVlcIPkNm6QLC310Izf1WMA2jKZtr0hMF5cMlec6Pbtuymn27zsbz0ia6tXfnVl
	 aiCLC36+YfkgIPKvAWRr9gcjFFQ1gty10nqZwtdq+8qTtK6tVPc6D2+o4dOxz6Bj6s
	 yXtf94zlb0WxbPD+oNpp/qJUuIPiMm1JpPALHeeLRRHuIHzboFCJsZmx+sJRRsKS8N
	 Wac39gbjinHQg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 30AEE4620B;
	Sun,  1 Nov 2026 17:04:53 +0000 (UTC)
From: Viorel Cernateanu via B4 Relay <devnull+vrilutza.gmail.com@kernel.org>
Date: Sun, 01 Nov 2026 19:04:38 +0200
Subject: [PATCH v2 3/4] mm: Factor __pfn_valid() out of pfn_valid()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-kmsan-serie-v2-3-f97f66dc57ef@gmail.com>
References: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
In-Reply-To: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Alexander Potapenko <glider@google.com>, 
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Ilya Leoshkevich <iii@linux.ibm.com>, 
 Viorel Cernateanu <vrilutza@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793552692; l=3241;
 i=vrilutza@gmail.com; s=lenovo-20261005; h=from:subject:message-id;
 bh=dsg65O1UX/YgTMqtnmluSfWLq95yf8DD327IK6k7U4k=;
 b=TEbLB8WV9dS41IpUSxXS+cmQiZqUbRgRqNwMEIswcGyuuFjl7gBgh/jU/GoafzgI93HvfF4qB
 ZRiBLb6tGcFCgF7stfJjEwxtZdf3wGeWLfE2On3O5wDgjsAMVjkGMp4
X-Developer-Key: i=vrilutza@gmail.com; a=ed25519;
 pk=HttZd2ffphVYTK/pvlflateaij8E4SdPd6Y+xDQMqDU=
X-Endpoint-Received: by B4 Relay for vrilutza@gmail.com/lenovo-20261005
 with auth_id=1115
X-Original-From: Viorel Cernateanu <vrilutza@gmail.com>
Reply-To: vrilutza@gmail.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 39F21180009
X-Stat-Signature: ydgp9irtsse8k4pye7jr4gps16pgmswk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793552696-586721
X-HE-Meta: U2FsdGVkX18E8Zj4R175/10zRtwWjat2kmcErWFk1K6IVnmfDtB5fGdZ9Ln1XY+3j+TO/rKVQuN2DpzC/kNglffu3U97QnKltBQYJkMkZ+Wv271Q3uw5Co9M522E2PDJX8RyHHBCXFFVPgBKEJaHlK/IQ/2y0AxEUzsHaaPE75zJxiU99XrqjswXC7wEVUG/KiM6RIUQC2hycgBEK9HGHqn8Oxj7Ranvcais0VaI3M8D612dmuoY+342VAow2EdEpegxZikz/rMemhKk9TlVO2XnXuPyd+OrF4bj3i411AxDGiRMNU9V7FACDMbipirKrsf23Kc7nys4ZyEPvZiqGmqOx7o3tWAGg0yDozIHwGlUyro+/sxGYjDLTbpWWu9F5p/AKYu7SfmjFb430IpiaziNNKULJAfwegf9nLTjl8JohNJll2+r7vLVEKaSrUCM0bobo7qHw2xPezkZbVLsMFJInPHyk7OOlVB5wXrdH5El8SVI8tjCUl9PCEuvRSp3ATG2Go61GvH00T1Lovf9wcpB+T5WuP3wGMdnWtyb+vyZZSh+D14ZX/dG/NDGwdts7VK11HURxRGAvDTLPrOV1mHZriw1IYugfjYfUIezszsa+329kQas+Jy87Eu6r/EF/Hb2OQalMkaCF9V1+JsC0dSsjFU8hNk1V8YARH/d0+F/GGjs9inrqZSYRvbo0hzrDhVHCfYwtCQalSNOtonNrHWLRfZzvb8G+DXBFTe4FKJh4w/AuSOgYRUh2PNl2/OoeDIxdITPatCGBIYGvL7NjxWR/bJS0/V7IxrfxkUar7yau0pGA1z+f6/fhC1es/2VqBGB+ynjiDwKwZW/Ycal8v5mE/hOBpkqSrbksmfeg7VRM51E8S+PHJh4dN/l7gU/Rsy1mLO9ZMMFYPkALDg9wJ8flN8CiitRyWDB10wvnYibX3aoC+oHF+2jhFX57BiW5d2uDi5bDLdYP4CNKV2
 pKDNWiKg
 lFUwltKnSww4IGB2r5VVYdPeh+oxFedkABZt8znI5KPoXZIgVIxNe8wVC+S3syci/e+tSgHOvo/wlgzHQZ2qertWPtS68eeuZlZsUgdEiNppSr1U9O6IUScUPagseos3YJXBxN+BD1qLBA4YKZ9sf1yDxXBteYL0U7ntD/RwvFYVoyP2TJnxGPSLlnv5mCP3C5Qe40z6iiOfYD8KLTWh4oFx0ykFdcqrJxj9qwBOGXU/K7Sjhjv5yQRqn4Dy+TZa2U1E3kRS6ePFp9oipNx1ycGbbx8xN9Tfr9CmcV0yEcAiiKHL/WqT3L0FZvKzqz+HH89L2evD0KzoPSGSMGzL0TYvU0w7sswhR/Sz83Bb3mbnPu574s9w4149dMjF00mJsK2wjthYiKXRaWMWq1m/7m5SvRGIgj7btIy4qTFkOp8dpTKre9cfsQw6qNgIVwfVP624CyDCfn624IeMNo8SJpqUMz016WCkAgycDnIzexxNYuSqdEWQN2XbmYeDALwZs0qKywqUmoEK3t6lO1zlHDKqrxmIvFUkB9UoK7ZLOKEt4GK2BRhG4hhatDXu44SQmI3miZCmETOF7U7ls9pw7Kl9Js6iAfhJOwHQBkrLbTUjH+MIsCkKb6lQfyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Viorel Cernateanu <vrilutza@gmail.com>

KMSAN needs to validate a PFN during metadata lookup without entering
instrumented code. Calling pfn_valid() also calls
rcu_read_lock_sched(), which can enter instrumented code and recurse
into the metadata lookup.

Extract the PFN checks into __pfn_valid(), whose caller must already
be in an RCU-sched read-side critical section. Keep pfn_valid() as
the wrapper that acquires and releases that protection.

This lets KMSAN reuse the existing PFN validation while providing
the required protection without instrumented helpers.

The wrapper now also holds the RCU-sched read lock during the
initial range checks, which previously ran before acquiring it.

Suggested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Viorel Cernateanu <vrilutza@gmail.com>
---
 include/linux/mmzone.h | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ecd1ebd49756..819042264088 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2266,21 +2266,13 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 #endif
 
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
-/**
- * pfn_valid - check if there is a valid memory map entry for a PFN
- * @pfn: the page frame number to check
- *
- * Check if there is a valid memory map entry aka struct page for the @pfn.
- * Note, that availability of the memory map entry does not imply that
- * there is actual usable memory at that @pfn. The struct page may
- * represent a hole or an unusable page frame.
- *
- * Return: 1 for PFNs that have memory map entries and 0 otherwise
+/*
+ * Like pfn_valid(), but the caller must be in an RCU-sched read-side critical
+ * section, for example by disabling preemption.
  */
-static inline int pfn_valid(unsigned long pfn)
+static inline int __pfn_valid(unsigned long pfn)
 {
 	struct mem_section *ms;
-	int ret;
 
 	/*
 	 * Ensure the upper PAGE_SHIFT bits are clear in the
@@ -2294,16 +2286,32 @@ static inline int pfn_valid(unsigned long pfn)
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
 	ms = __pfn_to_section(pfn);
-	rcu_read_lock_sched();
-	if (!valid_section(ms)) {
-		rcu_read_unlock_sched();
+	if (!valid_section(ms))
 		return 0;
-	}
 	/*
 	 * Traditionally early sections always returned pfn_valid() for
 	 * the entire section-sized span.
 	 */
-	ret = early_section(ms) || pfn_section_valid(ms, pfn);
+	return early_section(ms) || pfn_section_valid(ms, pfn);
+}
+
+/**
+ * pfn_valid - check if there is a valid memory map entry for a PFN
+ * @pfn: the page frame number to check
+ *
+ * Check if there is a valid memory map entry aka struct page for the @pfn.
+ * Note, that availability of the memory map entry does not imply that
+ * there is actual usable memory at that @pfn. The struct page may
+ * represent a hole or an unusable page frame.
+ *
+ * Return: 1 for PFNs that have memory map entries and 0 otherwise
+ */
+static inline int pfn_valid(unsigned long pfn)
+{
+	int ret;
+
+	rcu_read_lock_sched();
+	ret = __pfn_valid(pfn);
 	rcu_read_unlock_sched();
 
 	return ret;

-- 
2.53.0



