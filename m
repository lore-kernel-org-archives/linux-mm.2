Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F75B10AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9DE16B009B; Thu, 26 Mar 2026 18:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E576B009D; Thu, 26 Mar 2026 18:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65776B009E; Thu, 26 Mar 2026 18:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5BF56B009B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 706978D1F9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:46 +0000 (UTC)
X-FDA: 84589644972.10.4A06EA8
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92423180007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MzfhNYGD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3K7LFaQsKCPocemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3K7LFaQsKCPocemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563884; a=rsa-sha256;
	cv=none;
	b=FezHz6Mb6Sp8o2aeAT+2DTYTwgzWvbCWkcdSbVReAFXJMiyfCVhnd9T7OuB7fNQ5N2Trtz
	NZ9eQgQ9WrcGjb6T8GuU+jMTyge5v3A12O0cKcWWfVs3UKN7ejG0CLXkGu7zNFab0jebkB
	8KYZ2F2ZEHLrbqqJ5K63TBYHME+fKis=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MzfhNYGD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3K7LFaQsKCPocemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3K7LFaQsKCPocemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmnO4hb2PIIA1EWduI9O/UbYa6yJaVxG6FOYNP/OZJo=;
	b=lnwgzp9lWgipGHBy+6QcFnULRq9mCRCSe40tQtV9rDikVkos6W6JopQLz3hl4G9QLZdOGP
	6xl9Pn8pq4Bl/aLsOhjDANGzwlYDOXD6RFnzT8FVUW9psDre0Z0HdX8aInoO8goVWCnzTG
	5o8omqo48TNst3PeXrCeNBZ4YxcraTc=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82c714cb65eso1209843b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563883; x=1775168683; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tmnO4hb2PIIA1EWduI9O/UbYa6yJaVxG6FOYNP/OZJo=;
        b=MzfhNYGD3hFP6eGVBP8e8CjWsNd0r7Ah3AKTxbg9vvnmfciZg/nnNBambTioR9HGz+
         PQaEgQaY2y2um4Q2axbmJUkQU4EMZqZLETgebn6mwJk2PMjuvzJNAlnJwvcy+viGmh8h
         pQNjQ7sGtDuAok5xQtZjK1KulikCBvuBpZNjw5rKXqVRbM6FYu9q4nclIqpdAanp0wDF
         kBvFaszu4Ol1mwh0AXZdqnNmsWN8oBkFPbt3taEEff0WHeGMz7wW35fmFtWkLOWrZsSU
         x/bodAK1grLf1ggN7kIsIvRhjrASNIKNgpoZcgnvur7IYQycwuEnghh5+Lo76i/bVUKn
         1WVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563883; x=1775168683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmnO4hb2PIIA1EWduI9O/UbYa6yJaVxG6FOYNP/OZJo=;
        b=T/5I+K7XV3fE6F4LvjyXJT/8F22ukVTZBoCOa14/e9dQgzS3nK8U4xGpBr/6DVPode
         OAlCBXTz4C6gVTtDMhyPEvbCB4JF3PT7lyJdLPBwr4BY2GKc3UtvR28+7cXx2UIXFYSS
         c7yF4UfEvT4g5qvgEv69R3Wd6kzYCiSgsKHHBj8gH6qWM1kG1+ePidPOLVwKmd+TYvgf
         tNltNA37I4PvwmCs/KtSg9IheNDRek+DqFpUskYxU87i5904SBFFGFULDJZsG014nKEK
         PrNT++A5KZik7/VUue+P0YAqMql2T1rCQRjPlMYwIDlLg8DD78vK3Sx8q4SgtaiLGbRX
         1u/w==
X-Forwarded-Encrypted: i=1; AJvYcCWrPyg7041ia/Wdnpi55KxcRadc7NII6jQSphfNxd3pKxUPmlfNe1H9cdyQ8ON30EsMfMTt2ueqaw==@kvack.org
X-Gm-Message-State: AOJu0YzLvDEkkxAMLNp/mey3LhtsiLwUAETTVBznRk+pMt3L9Bvqgobb
	eWN+aRQYdDaKCncoo/cXNJs71WVStiYcqO7kQaID83uEW4WIsA295JOlHwEJ/+68J90oc3qmFDJ
	gF17jR9wmBCiGveEMm3rOh9A73g==
X-Received: from pfbgi8.prod.google.com ([2002:a05:6a00:63c8:b0:82a:1997:96c2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3388:b0:82a:e3de:27c2 with SMTP id d2e1a72fcca58-82c95ff78dfmr127743b3a.41.1774563883057;
 Thu, 26 Mar 2026 15:24:43 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:18 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1337;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=FPot4968BrrzY7lVw+wCqRSRqFOGaqVnuLbaco54t84=; b=pT1cKE5qo45twbYLFoifTHiRtxOTgBfSw8h/PmpQsnlghxeqA74ByQ0l7/JmSNZsH3jS0kwEA
 FZDy0ff5dwLBbaIcg7YIVPXmB7vme9WkWcqdC7GLxJMEVGO2PA4rqXh
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-9-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 09/44] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: szqr8nubr78bgf75crxqerkmthna6ums
X-Rspamd-Queue-Id: 92423180007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774563884-968567
X-HE-Meta: U2FsdGVkX19qR0KesnuykCrVP3UaCuEGn6t55qT1L68lJ2UnRmf3Mr0WJRVvbI/29aKT/Q3D26Lmpb5E5TZonDpti+WERhAce2Yna+PbC7Y8Z1s9bDqDKd5tLohpgWz8CG1XBlMTF0NpUpvAQgX/K8LiRzpQpGA3HuOxAHOBmL8xjJrjohmOsvIftY486KQ4n5cXtDkMTfPHk4DAjR7i7h1LD8F6o4JHkL36RZJzhdQYE3kvi29zyq7Dk4U8Wage3Eo1PuInkW/FjBD5XI2CKmoXpzfo0JkTDLIbNaweB9KNCUwwryq8PKa6GoKAMbowBkku24Z73pyycdk71KOvAotRGqKYRoToDCHrXFrDtCyj82/pS5DXnHDmvpoealX0g1N9zGZn1frTnvWMrE7wNCq5pzvYQn3yfR5cKJr9ypDkCREACn6IhqADa4dUVud8mBnaMQOTx4XQMGxQcPEEJvEQKNBntrcSy4+FD8U2PIYJdiV2HHyyN9QxBTySgPRUJzh8GQXWthvGF59A6z72NYu0e5AciAMsOyCB9s05DQq+D8UsupE8ED+d1xl1kiJCRYCij04bre+YyV+QxIYbloFyrX559HaOSMWEmHv681ZhvMxEdY07Ta1n0KXiNIMzrxmbQAWv4zH1+LQsEFL/ELin1Jde3d4fnJCY4jd89Btx1r26qioqfQ4wd8uCwmWygI99ot9+xP2K4BfgUcbm6u1uFRiSw4uGh3ywCCEtyWNi7Gebelu+Mm8UeNBiuhD/QRJuWX+nd41YY5xzFRnIq8akt/z+SMUABKrsi9qaMnBTXjsBIPu3R5qEmm4QZN0FI8hyrcXrNtRNE6wRkcuEl2MS1H0gOQvUSgDeLk78HUsGAO1HBX3qBPIFjhTBx0Oxdyow9TYygBWsRYjBSD0ofuql7STPiFR6Jhn3TkhH2IBcc6sWhhWhF6QRxbZbSmfl6qxQkF0RuaJf9XOrQU3
 9J4pTgqZ
 /4DfkZA0gxt1wCDrBpmxDu6HiwV1EHlHqyahXbT9sWliVIY2tsBbz9dFgfY6seDEC2h5eBCCN/iLGW0HXMT3fml1zeFDKQNhUJ39JEtlu2ECOtPjOGupjUV1M693M7sqqaMnbn26n+PqHyWrQw+h50A8fFqCuDxNCxxHrR0daJQOw9ckKs8mYv8a3v064AKaGqgLe8n9yWvqlECOJbj/24C+BdADyQc592YL1mYre4lP7oNpqvNE5bOAtEkizScYnsuZV/xroar3oJTDa8ZbRy+FnOMnuQfFbw6ciu7Cx5ofFz1VtI5LnR/9K1JyG42Nx5iXgGjtZEP8AN1L6lSrpXr54l1rwZoz7rfO2S9Pd3VQ1kzKDKO9xOI99AExL/1mUZh1S5Ff45gqajrvSJ4GrvkfijDiNm4dg+eGfTcGfF/JlIpOCd8TyAP7Kk8f6SAW6P56x4huTj7clhv3mEWN2PpFzYYMKYYCuW2im9G13h+5GPTxIsEJWKiD7Hsw2KiSZokMcfQwyNPLRIq+Vji+uwWdpFn9jKPj2P5gNBCEFFcNSr192iW8E+63SftIIk6H1eaujx/dijT1xFSkYfcrC4p5iPtCvtdv9tNMf52sb6/BgcjpldITAf0yTxD8AUXpeuYpidbQoiycmysmASEwkS2OAPwmVWY9E+ooraMMffG7LIC2lORIVC9HCdtrvdGi6/4bBZ+QTNAfcfj29FficLwi5Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as per-VM attributes
are disabled, i.e. when it's actually possible for a guest_memfd instance
to contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e133a9da11f0..9c29407712580 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14056,14 +14056,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED isn't supported if the memory attributes are per-VM,
+	 * in which case guest_memfd can _only_ be used for private memory.
+	 */
+	return !vm_memory_attributes || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE

-- 
2.53.0.1018.g2bb0e51243-goog


