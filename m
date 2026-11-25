Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81659606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GPHwmzop
Received: by kanga.kvack.org (Postfix)
	id 975796B0ACB; Wed, 25 Nov 2026 16:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D336B0ACD; Wed, 25 Nov 2026 16:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B196B0ACE; Wed, 25 Nov 2026 16:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 534E66B0ACB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:38:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D749D140131
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:02 +0000 (UTC)
X-FDA: 85474954404.28.347E447
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2FDA114000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GPHwmzop;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642681;
	b=KjuZSHCQDQgRKGRt+o3uLj/0s2D5CDJZEQo/70V0sbwiU9wgB7eHJN67MXLvnaTW4kbxfj
	EzByugJNmfBeVCAAvmFJY8u1vhDe3sH1pNPvwqxYcalnhYU5L6XsTGWf0KGILAllSJjjHD
	2H3nYrV5M3hxnvl7kEnfke7434YSnrI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34DVGqhbCWdbTco/ch/K2QbRyhURvTkp3w0GHRFcugU=;
	b=WXtAYFk4S9286yvszaNtCwy56tZXzot4bNJqtG/Do/2Ogpzf/n8dTNJuME+toq17ub/38+
	9MtKbJIYwi5rXTvAkDRuIOjYmLFSNITAFltKeMJT72xJP/Y/3KHLtMO0hIdzyHpmhPh1qR
	6Sk+JgSN+BxrI/OOLsbEviLn8T11ezU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GPHwmzop;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCA1961422;
	Wed, 25 Nov 2026 21:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4891F000E0;
	Wed, 25 Nov 2026 21:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642679;
	bh=34DVGqhbCWdbTco/ch/K2QbRyhURvTkp3w0GHRFcugU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GPHwmzoptOfHcsfOBCzWYlA+dXQ4FzP+DifsTdZNNeM9tO37bfo7DwJ4MrO70pC/b
	 ScxQEUwXhpTiVsTw7fDU7uq6wYjNloSj/2MgD8KG4bOHoLmpRAP5nFMtK8EJ+fSTlE
	 qFThrk26Q3EOvDwlRVat/d3MK+GdX7wHKiVOnUOExm7Gly9NHkUXz+XPiVIJ80nSIZ
	 +kUhu+yrLROZM3iXB8VWk1xWARjFk/ifzDEU+hSndCJnA3zCGjLl8H30isTqdXqwOL
	 G9pDbJ0qVNoCklp2hZ6kynKhgsF5CaXvBOVqtjn/rsh0gkEi4f+a0vtmKvUWcrAl3S
	 6gMZeK9xSU9cg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:02 +0000
Subject: [PATCH slab/for-next v2 01/14] mm/slab: allow passing
 SLAB_MAY_ACCOUNT to kmem_cache_create()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-1-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2FDA114000E
X-Rspam-User:
X-Stat-Signature: y9c65u3fi4y5im3neneu79a9fd7fagsj
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642681-318024
X-HE-Meta: U2FsdGVkX18E6EMprdxxB8qAL5J22r3qvmVj+pWX2Z2eAzPO+YExZbUFY26zosGpSMcaSx8E2nY7nU7I5RN0kzkjNEoqO+iBsvq4qqLKlR4RVnryhMr0EAFisDMXMPWCbCR6/RpJa6HO3kQABLY0VfwqXt1A5HrGRJkGcbBB9Iqc6debOFDLwL9cMSFdGy8R+C39bQrFB3ATBIWaI6gTMrmp+jy5BdnrW2VYi55bbrkQbPJ6UUBxPjhmWFS3D9zkOryi4zrawE9Ni+y9HjN/vGmVEyH80qEEohmEqBkrnMLsvsF/DoDeoItAXlaQ0j+VwKZvNi9LXvg84jxxQqLgBoJWedXlVlbucry/os+++ZV6RD58u6/0w58N4HUtzn1HnOtJXFAp9W+KY5N65c5UCmti3WJie4MYP+tn5kGxvYb/2AP2Fw9k8NZc76KH4/1dcoifKjbGdz262yGHvZPSnwtaVlIbLEr6TayMSKE24IAGCt4CZnVMn6K9G6tdae7lODGHuD49GKkERIgQLmXHGwoJD0jrCDg8cl9v1WkZ1Ow+Qf6cpaG3zrKDAS0RsdT1gvLnop1DaKyK1r1bo6I3A72UGaMhguSpHfN1WNLy9hLiheQ7UxLpsVIb56cVyyqs/2zqR5PlOAwbLzdImXV9q684p4mvwyfCF1AhMV5sro5fKcwz8i+dcD6iVmGQSwpVPETZCRqAfbbixMN7fKPsQ/u2qr+ckpHFJZIYYwn3Eza+4PCPKjbbjCtilJlVATSxvGg7vox2oaF118iWCbPp7FGoW785juvAgy+0mVEjyBtPdN/DRrRAzKkjpiXcR373bwzKyLCQQFp+V+B71kAGnVza9fKZoh0e4VCiwjD2xhcNFXwRdPfE55dlCdigJbTnrsH1rCdHkjZ1kQ8xjd9dpaMEJfzoacE9nJDz+wpLdwIolkLaCZdx2qriXQLa3wHD8PqZsCiz0TKPfWpccjL
 JtngXJQi
 TK4OZizk2cjos7T2x9QMQMKRE9C5aCFRt+db9tKuAFsdN3Q/DmEWpKPMoOB/qDSXEE0AGbtTOKMMg4C+t6S+DitTI3A8tcAHE6mQSsK99zvILxAneagxSS2tBY+wKE8lFlPb42eF5uiqcWlkwdqRy52c7q4AU3wpWvEDc8aHV8uVD7HuxIQHv694DxWz3ZXSBLZc7eMOu39d9rLDxBfhL3OGNBFHTmPl7fOZU2GTN/sdXBeTInwnGSnWK3rXZvssW8MtbTzomF6q9cevJZYOJhGEmCE7F75PK4TH1Yv7BetVI6NA1mUQOT34GnHjjmEkbbNqzs4ZBGH2C9QhsW7fNGXIv9Rf9Is3ShxlfafalbPRWGtewYGndy8v89TPR4Zlj8iMllj47bsS8amYaBHS3MvfBgp8QrMX1JjGqt8GTQnE92tWVTKz6LftwLTf8P5ufInUWMLHOAixh5f8hA6iDdmN1dzGMiGjfBJndIH3uSpaGefifU2/fYQ92Z37A6d+BJKxPY+nrmKm0Gr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Callers will specify SLAB_MAY_ACCOUNT for caches whose objects may be
allocated with __GFP_ACCOUNT. Accept the flag in SLAB_CORE_FLAGS.

SLAB_MAY_ACCOUNT prevents merging but is not part of the sysfs ID. This
was fine while all mergeable caches had the flag. Now that callers may
specify it, encode it in create_unique_id() to keep the ID unique.

Define the flag in tools/ as well to avoid breaking the userspace tests.

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab.h                  | 2 +-
 mm/slub.c                  | 2 ++
 tools/include/linux/slab.h | 3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 47a6cc8b22ff..168c394ac73f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -484,7 +484,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
 			 SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
-			 SLAB_TEMPORARY | SLAB_ACCOUNT | \
+			 SLAB_TEMPORARY | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT | \
 			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
diff --git a/mm/slub.c b/mm/slub.c
index 47a664427c50..3187e78e2e09 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9833,6 +9833,8 @@ static char *create_unique_id(struct kmem_cache *s)
 		*p++ = 'a';
 	if (s->flags & SLAB_ACCOUNT)
 		*p++ = 'A';
+	if (s->flags & SLAB_MAY_ACCOUNT)
+		*p++ = 'M';
 	if (s->flags & SLAB_DEBUG_NOOP)
 		*p++ = 'N';
 	if (p != name + 1)
diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index 2e63c2e726aa..104f962ae6f2 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -15,6 +15,7 @@ enum _slab_flag_bits {
 	_SLAB_PANIC,
 	_SLAB_TYPESAFE_BY_RCU,
 	_SLAB_ACCOUNT,
+	_SLAB_MAY_ACCOUNT,
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -26,8 +27,10 @@ enum _slab_flag_bits {
 #define SLAB_TYPESAFE_BY_RCU	__SLAB_FLAG_BIT(_SLAB_TYPESAFE_BY_RCU)
 #ifdef CONFIG_MEMCG
 # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
+# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
 #else
 # define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
+# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_UNUSED
 #endif
 
 void *kmalloc(size_t size, gfp_t gfp);

-- 
2.54.0


