Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A25C9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1AA56B00A2; Wed, 23 Sep 2026 11:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC2B6B00A4; Wed, 23 Sep 2026 11:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA486B00A5; Wed, 23 Sep 2026 11:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74C796B00A2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F34D9C03F5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:38 +0000 (UTC)
X-FDA: 85245451956.23.8E41308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3E7CF10000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWrqf1sz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZH/DiEqRWfRpDNmn9lxvEBbuNmwbYZYpFCH81u3DETY=;
	b=lhJl8VeQTGaWSqQaZKArHLcGYmGMomoAu4DzKWcExc77EHqCAmYMYKo8q5L4ToN6i0KiX7
	BwNsp2GAxqo9ZVbZ9Nu0AoYNRhs3t3sCbia7BAl1cQR3CjXldkTVBms1P4o0vQz7+wjA0J
	gVAZTqdvVliFCaU4GrvFVN+Eh8qM9NA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWrqf1sz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178337;
	b=Id7I0EC7loqqBTFPt9rY8ZmlFEqUXysAnDL7/8axSEqn2FgYOOpbO85+xdqO4Tf75ekE0s
	bsVhSvtg9OISlC9fV1k7jKmhC0vIat3bR99DJUic2ZSiCaoVf28RKqQ6a2i4JpyKXBCX3C
	4jgUjzjsbc15m/cWzzv1CJjUOV4958o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 753B843AA1;
	Wed, 23 Sep 2026 15:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB611F00893;
	Wed, 23 Sep 2026 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178336;
	bh=ZH/DiEqRWfRpDNmn9lxvEBbuNmwbYZYpFCH81u3DETY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MWrqf1szrP2VTEzbeFhP8yt/m4eHDnd56LMUoI0iQ8NSaD7hoNlznfPH6hGXRwTyC
	 Gmt1XvqQYWyzVpG1evAdvVrx74St4RGjVdHaMRIl35J+oQyRPqc98znaEzqIZJwyBV
	 fJ2K9jJE4R2QxfScBPgnl/Te0Kl484+s2rn48mU/z1A+is6OLmzZARx4Zh6gjT3j3r
	 C3H0Ime1n+jNMwiJy4UNkpVYZxiPPlOZymqaE6MLiro58CLw0OOabHARBQs19ehr5H
	 ydQqa04m1yr9FkphxYMbl68OXnWw78uDT3St/AUf68njsX6IGriQBp4H9AhPjpWfSQ
	 lipCntGlXeAMg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:12 +0200
Subject: [PATCH RFC 7/8] mm, slab: add slab_tiny boot param
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-7-a0e66d536eb5@kernel.org>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
In-Reply-To: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: iwibq1c8ebitq1cm4cqp7nce119fz7n5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E7CF10000E
X-HE-Tag: 1790178337-273013
X-HE-Meta: U2FsdGVkX18/C56AnZhPZAcvzpqoI6npxEGCzfu8ECy5MqueV9vN6r52WFHQTnhdNpziM4D6LVpfPaQTgASKSG79rVQ/d6M+HdkAFRt9ZJO8j3vwSQ/j6nJ4ha5xjtu8Zls3vVP5/e9ygD9dHFpLcL6pBUtdARUMpDLHx+lnzTwgN6POy/wslQMD1SUmoaaWwlUtXIFkoxmjA89AXAM4AaAVhme08Arp8/NunOcFM9lhBhsAIQJSqf5sC4s5fQjf5PVdbr9BvHpAV6YSEyIIREq6vWomETMw3y9kyiEPb0KSeXQIPTYV1JAoA9AuBeVaeI7MlKzmyB43JgIV2hKOuM27JdHEKojc4r+q2sIAhvyrKJe1tg1ZQH2qnbuBOSxqhBF/xPmTAevjQ9mfLvOVOwbitXFqZzAbhsVz8SCbLQQjNKI6Ea0P7+VfrsUe0epM5yMDLIH7rZ4V0OIh3lC3mCL/aA1r7Ztm0vJAaeV/8GAmMXsJum/5QFKhJ2ymb5ZK7O9mZvMDKPUGBizcXZms2qg+/haic7clbl1QFF5axa6LKionrPkT2DP1UZDKe2IlzyKwTnnjY3bUPzpeEWfnn6bWVgEA7xStHx0CAbWnn7/uDpOd2s5PvVhywkujt3yJfgcVno40HDERydAEPNQJ8LiPXTnk1KGLPhVNfAanwm5nmImg5NNo4luItZNwoQvYa+VJ/UHsBR52teJmw1Y+3a+aU3+KCkS82PWL5VYUHy6dcDfGyakxZKNtnmoAZ8fzoNCl/HPvqCsY2fp/AEDh8jLCmdhWBvgS64ANPERn7P8uEOBrb0BbkXrVcLcv9aNhqPKydSd3/rZZ8x/OJgtS6ZwgYOfDfhBGaUFDcDPWoZPiJKSqUWONk2HhovtcrB4X2zHQ3hfldnKgBaetqONhUE6HFx1i0kR9+/MvVzPsd3zylVdLKhUzYZXVjOtH32XC6j+Gr/eadpPIaueuIzl
 KI+ogiwd
 aMQt8EHo1Yt5AKRHIXIARsAMFawyMa96L2kryRwkj/IDYfLBGCLomZTzDWujF1L0wuJIaf1XD7l9nduWYw4suRTU2VTR9WgDDdbVq45BPo6fKVKql1YCZJY1RbgsuAUi6s0r37XwgXDxuI77AuMD/2fJoamw1WPWHHJMukKXUEd3QqNlNKGOQoDQB5fyap45Q3gd5jFtWbe4DVS1OxFBRw+3I0H43JlMvw2w26xSVhikMyb/0RwCsftGfwJsHpWsq/Skw6c4RtuLXfAPxIWA7zcp2ZaLWFEiaqwB1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to deprecate the CONFIG_SLUB_TINY option, introduce an early
boot param slab_tiny to control the value of slab_tiny_enabled.

As long as CONFIG_SLUB_TINY is still around and enabled, this boot param
can also override it to be disabled.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 Documentation/admin-guide/mm/slab.rst           | 5 +++++
 mm/slub.c                                       | 7 +++++++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 33cd30996e47..0100ab00388a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7031,6 +7031,10 @@ Kernel parameters
 			NUMA kernel object placement which helps with slow
 			interconnects in NUMA systems.
 
+	slab_tiny=	[MM, EARLY]
+			Minimize the slab allocator memory footprint at the
+			expense of SMP scalability.
+
 	slram=		[HW,MTD]
 
 	smart2=		[HW]
diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
index 0beeae71d472..6c005d3de0b2 100644
--- a/Documentation/admin-guide/mm/slab.rst
+++ b/Documentation/admin-guide/mm/slab.rst
@@ -94,6 +94,11 @@ kdump kernels where scalability is not a concern, but memory has to be
 
 	slab_debug=N
 
+Note that for this purpose you can instead use an option that can achieve
+slightly better memory savings (by not creating separate kmalloc-rcl caches)::
+
+        slab_tiny=1
+
 You can apply different options to different list of slab names, using blocks
 of options. This will enable red zoning for dentry and user tracking for
 kmalloc. All other slabs will not get any debugging enabled::
diff --git a/mm/slub.c b/mm/slub.c
index 4814f025fde5..d672809fa2f6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8726,6 +8726,13 @@ void __init kmem_cache_init_late(void)
 #endif
 }
 
+static int __init early_slab_tiny(char *buf)
+{
+	return kstrtobool(buf, &slub_tiny_enabled);
+}
+
+early_param("slab_tiny", early_slab_tiny);
+
 int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 			 unsigned int size, struct kmem_cache_args *args,
 			 slab_flags_t flags)

-- 
2.55.0


