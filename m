Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB6A0E98DF0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15EAE6B008A; Mon, 23 Feb 2026 02:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1EF6B008C; Mon, 23 Feb 2026 02:04:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F033F6B0092; Mon, 23 Feb 2026 02:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8D2D6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:04:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A5C61CA29
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:56 +0000 (UTC)
X-FDA: 84474834192.16.C4AEE43
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB085140004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1wThoQwU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3FfybaQsKCNAwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3FfybaQsKCNAwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830294; a=rsa-sha256;
	cv=none;
	b=1Nji5jMd+v9Rax0pZWvRLUlQFwIXtT9EDQu+9DMsKT40WOYWfL2T4dFk5DTBW85Zemi2Zs
	+qNuVQY8w/oDOxcAAamirhQ/DGM/zB+ej5w1hBp2RFVIU7vqKZ2U08MmQK3yre2VImvuWm
	dYQ+Kll3bCueG8U8c0vY4666N3D7794=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1wThoQwU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3FfybaQsKCNAwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3FfybaQsKCNAwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlhRSEkvP3hGcg7973jpELqHCKZWjzo4VY3xzNikZZA=;
	b=Ehl4TsVO+sD1gGUslbpG3jbfaN3gIyf5OumuaAmyNOjT/w4/jy3XTSBhF0Jcx1rLQvxXq3
	bpjkFKsUWW5l5/TNOSIKUx3i9uFXBjagdlw6rWIvRO/+zSR7x43rQRV75dm54Nlx78rfCa
	Gy3AN69syhSDqwczW7RFaJpYardNXDw=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35301003062so32996734a91.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830293; x=1772435093; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MlhRSEkvP3hGcg7973jpELqHCKZWjzo4VY3xzNikZZA=;
        b=1wThoQwUO+cyDRI0ifFyyqRA1rMYzX13D5vHoENG1DrRAK4aTJjMLzQYjqjd1+lqzJ
         Tt081N56iFjZEKoHnF4Y1on9t9r8nWDHlD8YtMOWkKoR/iB+jh3KAMUUsfbWDzJx4v8W
         sYmjDIJ1JbpwCwmbd94lyXoxv2WgRjXXmPphQmusWJ/fj3BRlWL4295f9G8EAWDyqVZP
         fjKIlcUb2xXzHqF4hdEevjcgkZlvsvKQ/cYoWkpj2rIVWCBzIb0Ex8j+zQKRc5yx6NP+
         5W/c3x7DNU7H7rDfCgqVhSszRgnLCapFr2qQv2Pad0QaA32TJdH2dnkpwau9pZJKDjCp
         9koA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830293; x=1772435093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MlhRSEkvP3hGcg7973jpELqHCKZWjzo4VY3xzNikZZA=;
        b=WvWnxU+B9P4Gn3iF4uR36aGaCIuZuNcdlc/JGXtMpS74JpjjOb4Qvd5T/IBYvHZnlY
         PPbhXVl1M+ru9BBV1LWxqgMUQRvoyCUfiUCXxJFC6RBj/Vo7ymZ9O2TSvYcgfmZ0OXD0
         /2eARyl/ekpA4cvAa5ZYRk4CFDEI1OJ2zxxGNvOr1TIGg1u53g8jzQDv5he5TMz+Qxty
         lJhNpTpp3GkpChwkIwt6oJunnGk/2gH70o+fEvDdKXlUGuIo2RMhPOp8XkwRM30srFIl
         fmjEK7hxZyooAK82lrFGV0C6QDjOGwf1VA4G/e+MfBPQH7JXoQiJPpCC8pZqj/75Fo0R
         foBQ==
X-Gm-Message-State: AOJu0YxJT7qM9JyaNuvyl7O7FXeqbWAqTCPKi/JT8J4tVoxYJYX+Qx8z
	rthNPCLinhRMPQ5N4/bShycNuX7T7WArMCifOls0dv4hFGZsaZyGQt3DxsDb8jQA7FArF35T/j8
	N3cs1fJgEVnwei7n3fAiti5Lto6icLWLgAS1MLfGHavzMlMh/E2eWLmUSvmEx7VO0v8L4Q9lClJ
	QH+mg97SYYNzx/lsK524rqE2jIBElXYwc0tEwxesRf8YN/as8TqXAxek2Lew==
X-Received: from pjbjz17.prod.google.com ([2002:a17:90b:14d1:b0:354:7c70:1a9])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e0a4:b0:393:f002:ff59 with SMTP id adf61e73a8af0-39545e91cd1mr6474154637.19.1771830293252;
 Sun, 22 Feb 2026 23:04:53 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:35 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <3e363901b177d8c2ae5088cfaeb3862621bbce9b.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 02/10] KVM: guest_memfd: Directly allocate folios with filemap_alloc_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB085140004
X-Stat-Signature: cteygu1wembm1w7odafm4g5478h97sm6
X-HE-Tag: 1771830294-678477
X-HE-Meta: U2FsdGVkX19slZ4gD9SMQAz+1rXZhChUhtqN9oWUKcSl07vjpK5xyFLeVIGlhNsFc3XCWL5SxHSwd/KoXXWrZNBaKXqEHdaxWUDSIVbY/RFpoJyD8H7sGBaBEuSTozLjyijojRmjbsL+0Kzxjm+Ye4u22dnKcDQCtdBu7t0X8TV5MXEvscAaoBHVNQaxIjXHy106HIfGYiLdEESlH30SfgTiI+YUJgWYgZ1GZSp81PkjHWWdWBREY8bSoxLQ7iScsOVJQ8oQlAWERn+9I02w1FTXf/3CJKO3bJa26RSucKXK+68QEmLM2aIHPS7Lui7sg8ZSb7uTZprBGPkGvQAhAVhvnQLc17Azw6axyogksf2MzjCyF87ZR+UyKHTmPX3LlFXMeRkGgpb3uZXkpQKz5Fg//jkTqhYU9Nx/LwWKijTtwPh2Pn/vh2j8JwOVA6ARCDJiR3tkMWWyoJp1erGzQwvOIJ7gO4g6+61VHI//YC9np0B0086/8LV3iZFrGYh3VfvhQsya0dwq9usq+0vb3S2Ff/xgOKZ2BMz04SvQ0oqC5fZDGMaFHpTRsvouKIeVJLYmadmW64GqOoBltDOgxNQ/fC42xnVHXBLOesGp/PPQWv23Nd+MoEBoB360GBQssxBwxxZ+OlxaPNTg+V8+R7yBPKnqFOaOv+ypq15Xquzy8mkxf9Jrg/L9/Ki/0O/oUa315so4+r50oKsq1KT2AMjEEISrghptarksUU4oZF+95L2h2r8+tKeoRps+QsGW1k6306KcYA6dozwNxaaLKgbnw82P9zD7QeGDaIOSi5mU6ykPG7F1cz5RH1IALAIL86CRQ9Hb1Lwqhz4ZY4Xx9qAS4YfcZm7zaskzVor/vfm7qCEBymG+Qa7XRPS55v6a8DRiRejqdM3T3Fv1iaiJ8Qf05/EhVENnALFCUXNllrqzdJ5x2XNUbwy8U4tJvMCW6U+8c0PEyJWm5eLjrgQ
 IhtBlRKO
 QRIdMwlI8BuVTL3obV5DljjWSLhieAsUubY2N2srGwwCD8M+Gd36veAOCxoeai18AD3eoIwtnvY+2mSqHNLQtnw6CCxWInVxyanTEPDKl+lZVVpGj7aePqjzBuW5KY8A4MzQNUcdWo3jBMB/ed9bcc1fRPkXgkyJ+0oBMgn7ulTlniRbvSwnLmjNKZeFpaFP0YMCc8NTVPhemCUKa+idd7CLyAnV546iiq0GBODHNee1ao4afaGdPNUAFW6Zdm48ZxGSnBnyKOHYvtwrsPbgbjaA5JwUj0ZBUxPQMRz8cr/OmsMVB6ypwp6GqhSC5GrsftjDXr7j07Y48zI+gGIqVX5tUlYQq0QSNxc7DSDz6fdgfWoQuUynK2QdZ0T2fOJ6mB6KNsWQU8TjC1IzlFXHzt2jJ+JeDe9Uml3NpQar/l6sD6N9FS7QAfq/prFUXKzIAal0qATtkVEOY19l4czBsZk5ABa0KNPSm00qhn66RJC4E971NbR23BE4JEm9jRHxXksz5Sw0uK4W1me+57XNjKa/ZhzyBk1re1AE9P2xA9vtURvr4ma5sXqKpE4QT0jEg87I4E7ocUGQ2FhM0hntq+sqEjZzichuskqjefh6RG25W3ixv3jLKdJe9RvjYkuvjXuKk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which
adds complexity for the reader. Since guest_memfd doesn't meaningfully use
any of the other FGP flags, undo that complexity by directly calling
filemap_alloc_folio().

Directly calling filemap_alloc_folio() also allows the order of 0 to be
explicitly specified, which is the only order guest_memfd supports. This is
easier to understand, and removes the chance of anything else being able to
unintentionally influence allocated folio size.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 51 +++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2df27b6443115..2488d7b8f2b0d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -107,6 +107,39 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
+static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+{
+	/* TODO: Support huge pages. */
+	struct mempolicy *policy;
+	struct folio *folio;
+	gfp_t gfp;
+	int ret;
+
+	/*
+	 * Fast-path: See if folio is already present in mapping to avoid
+	 * policy_lookup.
+	 */
+	folio = filemap_lock_folio(inode->i_mapping, index);
+	if (!IS_ERR(folio))
+		return folio;
+
+	gfp = mapping_gfp_mask(inode->i_mapping);
+
+	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
+	folio = filemap_alloc_folio(gfp, 0, policy);
+	mpol_cond_put(policy);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	ret = filemap_add_folio(inode->i_mapping, folio, index, gfp);
+	if (ret) {
+		folio_put(folio);
+		return ERR_PTR(ret);
+	}
+
+	return folio;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -118,23 +151,11 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
  */
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
-	/* TODO: Support huge pages. */
-	struct mempolicy *policy;
 	struct folio *folio;
 
-	/*
-	 * Fast-path: See if folio is already present in mapping to avoid
-	 * policy_lookup.
-	 */
-	folio = filemap_lock_folio(inode->i_mapping, index);
-	if (!IS_ERR(folio))
-		return folio;
-
-	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
-	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_CREAT,
-					 mapping_gfp_mask(inode->i_mapping), policy);
-	mpol_cond_put(policy);
+	do {
+		folio = __kvm_gmem_get_folio(inode, index);
+	} while (PTR_ERR(folio) == -EEXIST);
 
 	/*
 	 * External interfaces like kvm_gmem_get_pfn() support dealing
-- 
2.53.0.345.g96ddfc5eaa-goog


