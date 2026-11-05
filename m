Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B01606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G3J9qgD/
Received: by kanga.kvack.org (Postfix)
	id C733E6B05BC; Thu,  5 Nov 2026 03:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BBC6B05BD; Thu,  5 Nov 2026 03:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC256B05BE; Thu,  5 Nov 2026 03:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED4E6B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F34480988
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:31 +0000 (UTC)
X-FDA: 85400429142.23.262359D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 797B1C0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G3J9qgD/";
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868269;
	b=r0+wRjLJR+xAT7wRgab8Dnrxu4hdbrrY1T4qmgkN62dFQ1MZ28BtGADtiSS6853PQ4J37v
	S3Y2d4KMl/loJxo6JtcrN14iTEBwuUDh1+Yf38GIurhksfRSnkZnRqsd10Yai1k3n6OctG
	8hHVyqJoAaJiVwswbrB2Fo5zOhy/3ng=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G3J9qgD/";
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3XoCtOhPykQ5s/3a1XBXzxar9RFvyhbzz4AX5meuUI=;
	b=7NOBz1WhCBHQkdNKgWa50TZLQBBbER8kIWFt3raZQ7z+pKS8SESvJnYiFI2KmVAKMzHw8z
	dGiTNl3pzs500ucnlrKU+Kx17e5zoPxbRUlT2eV3GlR9pTDGWzqpPW5bWyGScIgIHT+PIo
	KFnpyvA13VFF2TYvj7437E49ZMf1izI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDE6F4377B;
	Thu,  5 Nov 2026 08:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA1E1F00A16;
	Thu,  5 Nov 2026 08:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868268;
	bh=T3XoCtOhPykQ5s/3a1XBXzxar9RFvyhbzz4AX5meuUI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G3J9qgD/q6Nb8gT9uQ4hGqIATQnDmKeO1GicK97PH44AKaHN2/5MkUBukUL2BAsug
	 Ehy6EAk6pZGy2+1Zoz0uEE/HlDDoiTRPy3nYJK8reIBFkD1eV7MB6PbaMu1q/Uo4ob
	 U3WNATpcA+DZK2ZyWOfWX+vPt5GP80F7JfSvyKX4aXPtJrCASNE2gm5MjeRH4wriYO
	 76GeTT1NvHAm7H4iw1FEmSJFxsUYrxVA8YHeY88vJFzu0CDWZKondLw7Wu423PSshi
	 Zq1SfgnxkNsfh+zVFqxZ2KThVp4Y/1yvUZe3T91xKkrYWHEH+uwGQ2s0S3GU+rb2nG
	 5u41Wn6zq/FzQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:58 +0100
Subject: [PATCH v3 09/10] mm, slab: add slab_tiny boot param
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-9-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: 4ebn7z6gjin7zkhwkg1jsfq8tu7rxn47
X-Rspamd-Queue-Id: 797B1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793868269-937585
X-HE-Meta: U2FsdGVkX190fJCuGEeD3RT31SoDzXcQ5S+4XNgj8apKeuKpYyzTHPL7qqV66YvFmWn/HS2gDnQOKlFggDHkw5jnK4ptQYj3t8NxGBqnwBO3YEgjDw1xbqXyLV65Oo30KRoaCsXZnXJJ4994qaFuJYcdNceemyMx7nWHUOtB6AhRlCNHpgZmPLCyoICyMv8RzwVIskboheRB/LHM7lALTn9JGnmhh+BOJhgOfXxrLa7TFIq52Zze9ZBoQHFCLJn1+tRlrY8EeN41sNEWglGfNFIB7wfgv7qs6HUe6pFL52IzN30UJiOUtbx6ghr85NPxIxJMxanFfsV/zo6cP9c6d6COoMf4mKyz+OAkOTt8qO5y1yPiuVm8cgCazUYsYvCKS+wG0JDNcjIw9bNo8xlkhugp9ehOQCc4BVKQ69QbdmateZN/pD1sI1jVHc87RystHHtBzM/5faE+nXvV2WODawbueCPwSsW4bR8GodSLJPjatln3Z9njWnw+RqVjHz5GSVDjUhBIQEYn6waMWDD2mAYvVeaSAjAZ7Pj4cztxrAOfgF48neh9t5oEZGPF5GpK3YdZFwAtsfYYuI3+6XEDoqb2j//iX+6QZg1rmLBVTu7chzFXEcdhdyjIqdiy12q31kmDk02q3fpfMmRtpfgHhkcEB4oiRCrmn1CDXGC8I3tuQNPpcDfKzY9ETwV8qcdNzjiFeX4PJxV7TtiX3WOEdGAQnzhjDYyLVi3PYuy6sbkNGLAaecGnjO3XqMPz1kEW6tLWIWY7cb/begBu7L8a32Tfm5l1YwSf1UwdxoyH3BqtFVjbHEBLOs7bK8iT/0BKn6/S0nidUckoXXU80EEoUTecJBJYFjSFRTVpitDvoZ3ZCnUxRmykXm+96jvKZGbdqpHAh/lRFgIIJa+81vWkuFWFXDIu8fw+D3dm2TDRFqJxXWvVS0+kLA/4bfqqM8pjE87ag3TF8GOt3u7Rt8u
 EZe+ZOUs
 l10cat4Lprkm47MZkJmb6FccqHvXMPOVCwi5DYX+OraMewWCGsCe1dJTYIACoHnvWYs6+JwShtBMwqrxWKNO7UNP3mhZhLCooopZjK+hHRL9EjU7j2N511CRS6UNzUwDeJ6CgCVS5ZFouSvUg8xnoioR4AAGDuj0Tqf3q6MnhQJEtoGjr6P9fknE3jn9b72GH1Un7EU1M46t5V5rZ8kZw3v8TlvXrDKr6Z15KyoUQzY/ABuFiiNmVLAiALhfUR9oesFq4SuwGTUa00l0nrMCGM3JZE8B94eeVwujtUbDaLpFifMqPlnMI1Ff7XUztwCywqh0USQ/+RwExt5zxhLZCr5r4jybC84/8QBXMk3GfKNmCJIwB1saFGyJz0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In order to deprecate the CONFIG_SLUB_TINY option, introduce an early
boot param slab_tiny to control the value of slab_tiny_enabled.

As long as CONFIG_SLUB_TINY is still around and enabled, this boot param
can also override it to be disabled. That could be also useful if we
later add some auto-enabling conditions such as detecting the system has
only a small amount of memory, or being a kdump kernel.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 Documentation/admin-guide/mm/slab.rst           | 5 +++++
 mm/slub.c                                       | 7 +++++++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..e286195369a7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7057,6 +7057,10 @@ Kernel parameters
 			NUMA kernel object placement which helps with slow
 			interconnects in NUMA systems.
 
+	slab_tiny=	[MM, EARLY]
+			Minimize the slab allocator memory footprint at the
+			expense of SMP scalability.
+
 	slram=		[HW,MTD]
 
 	smart2=		[HW]
diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
index 0beeae71d472..350384908631 100644
--- a/Documentation/admin-guide/mm/slab.rst
+++ b/Documentation/admin-guide/mm/slab.rst
@@ -94,6 +94,11 @@ kdump kernels where scalability is not a concern, but memory has to be
 
 	slab_debug=N
 
+Note that for this purpose you can instead use an option that can achieve
+slightly better memory savings (by not creating separate kmalloc-rcl caches)::
+
+	slab_tiny=1
+
 You can apply different options to different list of slab names, using blocks
 of options. This will enable red zoning for dentry and user tracking for
 kmalloc. All other slabs will not get any debugging enabled::
diff --git a/mm/slub.c b/mm/slub.c
index 3b1491de5be7..3b7ba4fdeada 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8829,6 +8829,13 @@ void __init kmem_cache_init_late(void)
 #endif
 }
 
+static int __init early_slab_tiny(char *buf)
+{
+	return kstrtobool(buf, &slab_tiny_enabled);
+}
+
+early_param("slab_tiny", early_slab_tiny);
+
 int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 			 unsigned int size, struct kmem_cache_args *args,
 			 slab_flags_t flags)

-- 
2.56.0


