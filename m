Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F4B606A324
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=NOgCA+B6
Received: by kanga.kvack.org (Postfix)
	id BD8F46B05B9; Sun, 25 Oct 2026 13:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62766B05BA; Sun, 25 Oct 2026 13:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DBC36B05BB; Sun, 25 Oct 2026 13:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7C76B05B9
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA7D0A05FC
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:31 +0000 (UTC)
X-FDA: 85361863062.30.CF4EB62
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B3D7140006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NOgCA+B6;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dxq8eDBlDPCIVTBkGYSUFbRjgK/3rDeHdp3Ckw4nU4=;
	b=fi2eGSice/meXUpufPRBw1rSAVJJWb02VA30ObjHksl6tqxttMrhKaAAARBChcQVGW6fdQ
	0QOrxgwoTDznXYhunJW0KuXBzAJsiZSZAVLcycd3aHG95HZi1nqvMyAGsLQjk7ZSaq+BVn
	G2jkmCL0le6NLz8ob94bGKAi/1dix2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950030;
	b=qf4X7fuhAtJCP8brfAHNeqn0jfmKvp1nW6RQbGlFx03L25PzGqyJN8a0tZ6Q1Y3Zt/vgQm
	fX548g5T+yg41Ftw+gM0pMXOBuNbtzFIGIVW4L2QDvwk+yBertVHjBrhzppKs63lcICB1F
	CRLfroOQjA2PiYm5XpsmAliJ/ojzQg0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NOgCA+B6;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-98c78660542so1774195241.1
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950029; x=1793554829; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7dxq8eDBlDPCIVTBkGYSUFbRjgK/3rDeHdp3Ckw4nU4=;
        b=NOgCA+B6V04avqtiUm6yQIymP4EwJ+KjW/sfRL54j5CkOVzUb2rhY8BlnXcEOFauEA
         CDgpM8c4K/jnWJmTMsmEGpK8i99TSiDIERNOxzlCJXbjNHl8vksqSVtnUG1BVSftAWyZ
         BKxPRpEtkvkBu9f9GdpFEc8isrRmvZGQ8BDgwt8bhvVv/WPtLgVcCsdhUpgvJAEHb/ZX
         OpAWo4lbP8L0WXyQgtKim4gt7BP6CgIsZgGJHgjPI0a9M8tirXbXeeB+cH9M/3Q/sTNq
         deKNEnuGADodgf823Ljh+jbkUjpPGLwQxiEdfyfBJ0hwjGLhYYR6y5l6L5/pvS4FsC6D
         U8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950029; x=1793554829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7dxq8eDBlDPCIVTBkGYSUFbRjgK/3rDeHdp3Ckw4nU4=;
        b=anrwSzGVsfG/0utR6yxqVotppBwnYHI96G3KYjFZW8ZfHw/eHc/KrvD5u0/TB7Eog1
         fLkX4j+c3Lx+iy/DvUh1Hi90jo3B+Jj3W65D8wDvo1JDI1NBrw1r06ZQHPzRuZ3MN88N
         8RVeh5TjNrjb+LMxuLXFuNSX3W+GE4y1nSawzPmoPBbGxMVAMSYUJ2gSDPTHpa+XpaDZ
         D41vJOOL+ViyRTayo1o9EroHDr6MKwOku1J9vUPh1RZwZK71McFFeRYJ5+pBC/uPsdV6
         xLJvOJy8pvhGT7gAn2Wyv5TgGhjBxu5Wr8Bj2HDftxPOShssJmdsLWKEp6w9o/IOAVvE
         IJ9A==
X-Forwarded-Encrypted: i=1; AKwUvByUslIAqLt/T2GLacGqU5Z6lvEcGNLkpIX9mLKKGo12CfenwjM/TdpAMfjSf8cUeCTTvt3y7BeA7g==@kvack.org
X-Gm-Message-State: AFq9FYK1uaB9YLOJMTM1XS+O8FTCwKkkdgAMWu6DxGhWNqA9HtBc4xFn
	CvjeYAID4A35M70Cz4e885HW+EUG+Q2vaesqhH+RV2Wm51br/RrhKxWDRs4jnZVx74I=
X-Gm-Gg: AYBFou1qorADwh6zor4zSA0wEX1+FKqDjdpd2fr1dDjFlZrM4U/KkvUIuUsfhXSJEOj
	goDghEt2kv+7B5kqxZSMGL+CFNvjTYPreCcsZ0HFjSWa92SnR9FNmB0SpA1i555/Zgw5jo0pjcz
	l0318l1ApnORHtZwP7OKMy5VkpHzc48wSKBlWXEtI+4dP0gWhJPIKTaOGm/mzXWf+W4K3EkC5JZ
	ZMvmgaPydZsB9KJghjiQtk8r/gHoHqJvtaJ/sZxMVbFcjLNErue2RBM8ZVoBgCSrS/j1XcIJsqL
	SapI8iHyoIphl5TymeCTxpn/qaq9qGUiglI6y+wfCiYFeowRreoSnbfL0yqmeUoFcTMq/aYGrzg
	eIAHVV4gw2PA1cuuGEDUOShK14C92ZP272eIYIvlQihxG81mfLSSAXylkNZnqcaWYWxBj6Um7Yk
	EJOVvyuV6xLG/c7Y4LIZFBWrgu7uYYgecJXZoiGcZUziXowldehJvnwqfGrzRY0olhaL+4ogwqX
	CSa+B5Ye7Ubb/QFZec2fk55IEnBSVsxoA5qI0Le2IrwAJTOaGx2WC0TebmDfdM0dKtmxtywDeg0
	iuXSIlUqSAJZom/wUGP8V6xJFH0h33REiV3jHCSW/m/ynFgL1+P5ylzjwlLcDvqFCSOTBw8y09N
	e
X-Received: by 2002:a05:6102:41a3:b0:7cc:2f04:a078 with SMTP id ada2fe7eead31-7ce5ce4cc06mr1588692137.37.1792950029106;
        Sun, 25 Oct 2026 10:40:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:28 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 7/9] kho: support read-only KHO mode in kho_block
Date: Sun, 25 Oct 2026 13:40:14 -0400
Message-ID: <20261025174017.3870481-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1B3D7140006
X-Stat-Signature: whugkf6xfqbut3k7yg7hk1diby5yai1g
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792950029-432781
X-HE-Meta: U2FsdGVkX19sNj2JfwplwWIifFIVOpvNkpVVP5AY97E7tVoTwoa8m5mXM905LexNLpi/5VijTYQH/gJJns3t4I4ZCvFa6n8goyqtcHHsVhDI7ccqaCHoefxMcyBfUo+l4acn71DJVfZHq/h+VFgE1ks/ki/qwYXowCYrGIK+5yTrXbo2wWgCtV32DC1+KKodZP/koqTmLghAgkTwqSIbLD62hTikFsUXEu6b47fhjwRprVk405rLx0x2Ec+RNrQnejwH3x6tZDQ/P1xA168QUNxAGicxm/imKbKNL3SLNxd22ytKgtkuHvD/FxIxe4b8cY9by5x20ghVraWTKIJVykohVtK6ksut+mKh1ltN2aoDIfrd40de6RRpMa/VsZeDebVACxgGt3FWiQCIX4pelAfPcCqcQe4HmNHVpwqrZyf92I05KJncoNrxGQ7i6DSxkxBt5jPPEfmawx+pkgbv78+V6gf82+BzapeLXysgAn/AJ+LDo7PT1LKWFyIggRUUQGZLTCEI8/EXRXWzSNv9lBRAyjLDPAfmhRuL8g6Bdk91PqT4zLwBuzbYqkPNCqnq1R1LUsjRal84EJ024HNJXanAPUhJBXvo9GSayPpMXEJCkAv+2MPO+VlOLop8aOvp8CV5/XOsf7l+Q0swf37l9uC4rbSxOY0WLsY/68GHHuxq+ayCnmepxAc31BTnnvSR/05DfLf7z5KAJJJVjZz0FbGUIW03781JdhyC+U3qJBFtYqFO2gxtO13BvIKCcJ8xmU/1uYF+sVSiJAsdIqyOYHEtWxan4+oi2CfT7XzKPBNBmMTYg/9cwB/nPJKZOW63DJY7xaMS+6VE4MoO766m5eU3hwzAKlMEkHofL2fiuD8WtVoEPnQXeLUiIFZMzDbrtIsMGBGK1BqhSbFGAXh9et6OIugPmeh412EDgQt1JYDGX+jWDvMw4YjmpbeEsh8ZcTBtoz+y9ffF01aNTYZ
 V9KwVFwj
 hsE7Q7HnI527HsRaqKDKKyPOWMihKGTJvoEh/gODr5p/uaWrjxA+AQ39hLud8BcVQ7Yg99ziLTje0x2+gUAl5pP+v+15BJBCHGDrWCnvIuqXX2gR7EUyEN6jSbXGK0ZmH0qvEgG6myku5qB7WE7iQeyyACaUFHXJKeJJkTSKmh1kQEB0wzW2EUxXzFMA5rA+4TGpZlhcyUdB2cSqDYpcio0yZinuYXlrxpeUXq4+daLS74sEqk8GajZaxLFA6S+58bd3OTIgXT0dm9ejn5Pki7sMmmCPCCedQYmLt5fgNDaUsaE3ba48vmi+KEHU+WUWb5iq7f0Bu21Id5tTuW2dsve6OvfBdoqMtsneepli76a3ovlyCRYN5PBVV4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In read-only KHO mode, incoming serialized kho_block chains lie outside
the kernel's direct map and must not be modified or freed back into the
page allocator.

Map incoming serialized blocks read-only via kho_ro_map_folio(...,
PAGE_KERNEL_RO) during cycle detection and restoration, and skip calling
kho_restore_free() when destroying or shrinking a block set in read-only
mode.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kho_block.c | 62 ++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index a4e945f28fad..5b08bd8a9623 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -60,10 +60,24 @@ static void *kho_block_entry(struct kho_block_set_it *it, u64 index)
 	return kho_block_entries(it->block) + (index * it->bs->entry_size);
 }
 
+static struct kho_block_header_ser *kho_block_map_ser(phys_addr_t pa)
+{
+	if (!pa)
+		return NULL;
+
+	if (kho_is_ro())
+		return kho_ro_map_folio(pa, PAGE_KERNEL_RO);
+
+	return phys_to_virt(pa);
+}
+
 /* Free serialized data */
 static void kho_block_free_ser(struct kho_block_set *bs,
 			       struct kho_block_header_ser *ser)
 {
+	if (kho_is_ro())
+		return;
+
 	if (bs->incoming)
 		kho_restore_free(ser);
 	else
@@ -197,6 +211,19 @@ void kho_block_set_shrink(struct kho_block_set *bs, u64 count)
 		kho_block_set_shrink_one(bs);
 }
 
+static bool kho_block_step_pa(phys_addr_t pa, phys_addr_t *next_pa)
+{
+	struct kho_block_header_ser *ser;
+
+	ser = kho_block_map_ser(pa);
+	if (!ser)
+		return false;
+
+	*next_pa = ser->next;
+
+	return true;
+}
+
 /*
  * kho_block_set_is_cyclic - Check for cycles in a linked list of blocks.
  * Uses Floyd's cycle-finding algorithm to ensure sanity of the incoming list.
@@ -205,30 +232,26 @@ void kho_block_set_shrink(struct kho_block_set *bs, u64 count)
  */
 static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
 {
-	struct kho_block_header_ser *fast;
-	struct kho_block_header_ser *slow;
+	phys_addr_t fast_pa = bs->head_pa;
+	phys_addr_t slow_pa = bs->head_pa;
 	int count = 0;
 
-	fast = phys_to_virt(bs->head_pa);
-	slow = fast;
-
-	while (fast) {
+	while (fast_pa) {
 		if (count++ >= KHO_MAX_BLOCKS) {
 			pr_err("Block set is corrupted\n");
 			return true;
 		}
 
-		if (!fast->next)
-			break;
-
-		fast = phys_to_virt(fast->next);
-		if (!fast->next)
+		if (!kho_block_step_pa(fast_pa, &fast_pa))
+			return true;
+		if (!fast_pa)
 			break;
 
-		fast = phys_to_virt(fast->next);
-		slow = phys_to_virt(slow->next);
+		if (!kho_block_step_pa(fast_pa, &fast_pa) ||
+		    !kho_block_step_pa(slow_pa, &slow_pa))
+			return true;
 
-		if (slow == fast) {
+		if (slow_pa == fast_pa) {
 			pr_err("Block set is corrupted\n");
 			return true;
 		}
@@ -266,7 +289,11 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 	}
 
 	while (next_pa) {
-		ser = phys_to_virt(next_pa);
+		ser = kho_block_map_ser(next_pa);
+		if (!ser) {
+			err = -EINVAL;
+			goto err_destroy;
+		}
 		if (!ser->count || ser->count > bs->count_per_block) {
 			pr_warn("Block contains invalid entry count: %llu\n",
 				ser->count);
@@ -283,11 +310,14 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 
 err_destroy:
 	kho_block_set_destroy(bs);
+	if (kho_is_ro())
+		return err;
 
 	/* Free the remaining un-restored blocks in the physical chain */
 	while (next_pa) {
-		struct kho_block_header_ser *next_ser = phys_to_virt(next_pa);
+		struct kho_block_header_ser *next_ser;
 
+		next_ser = phys_to_virt(next_pa);
 		next_pa = next_ser->next;
 		kho_block_free_ser(bs, next_ser);
 	}
-- 
2.56.0.307.g5fe7bd680c-goog


