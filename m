Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CE0606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIWA7sdr
Received: by kanga.kvack.org (Postfix)
	id D76FD6B05C2; Mon, 16 Nov 2026 01:47:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E276B05C3; Mon, 16 Nov 2026 01:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C643F6B05C4; Mon, 16 Nov 2026 01:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A459D6B05C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C54FF40916
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:53 +0000 (UTC)
X-FDA: 85440052026.27.75BFED4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B758C0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIWA7sdr;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ntul/T2kCyH32O/TJbDV9NKlwqGCbG2f4hnJS/bPqVs=;
	b=Qtudl9lRjEfHH80lNskoj63n3hl6dNK02bnouNei4expCxJHpdbIbjfEPIZL4h6smyFQf7
	z68K298nT0oxW7t6JMgM7ei8RBB1pHs7l3P5eurAss6+pW2zhkpeqlvhzbdALcGCrLDsfd
	TOrzy2JA0BRE/ENtSBCYnNhaexg4KCg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811672;
	b=8XoP1+BYrOnBf6NpyngZw3Lw/uCTGc2fCLQbJS8t1gZ+3ngEAOrJSXxcPBRM7cBVsABCo8
	x7PV8ICyv9alhoYa9Sh8Nbw7jdRZa2H5yVH2A6tN8yYrYd+1CmLdGhmfM2CY4sMtmpXF7x
	yuZrCMC3ihYPl+ewnwgqe+n6e56eN+Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIWA7sdr;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFFA9623B5;
	Mon, 16 Nov 2026 06:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F20A1F000C6;
	Mon, 16 Nov 2026 06:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811671;
	bh=Ntul/T2kCyH32O/TJbDV9NKlwqGCbG2f4hnJS/bPqVs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oIWA7sdrZBwr8SKt63K8jyPLxfsidEFNgKslqwLhdw0TOqd0rB2pqPXSj3RL1zqYz
	 +U862IMlN8z7Nq9bslXRnLiFhYsvI6Mt57Y79MLM8cWWOKf4PkTXXy/3PkB0znH/1G
	 qsfqZ2B4BmJKwXy3lDFTshtePlWxfmJMMBlemzTzkQ9KZTPIAJfLNDpX1tsCv7hpkm
	 HywtoMmCv3iMKksLghZUpQUZ9n9K+HzX+OJA999/W0hYOwMiF3Q1rdScjo+JUi/SoI
	 KejzQmJyEmR4bZ+mY8o7r6VV5UclT8Nw7h2xzEslpMrkd/Tr5pu+cDUxtQauoOmcBN
	 49g2aWsw0BaSQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:17 +0100
Subject: [PATCH v4 09/10] mm, slab: add slab_tiny boot param
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-9-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
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
X-Stat-Signature: xmnuymnfxny34jppxy6r6umgxqrz9adh
X-Rspamd-Queue-Id: 2B758C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811672-804089
X-HE-Meta: U2FsdGVkX186ValrmtecR7jsAYvUMMzl2gSUSLrAylTB2miEeGQP1LEXu4Xh91B5iWr0V5wupftjHSPtAL7uD4G7Pe+0PrKEOf11LLXACw9nzjtQSXXt9SWQJfUqEA/QbKPRaBzAg2+Xn1JNRKB+b4+4WyLTi7AyRR/PdFW2CBybXWsMr4GHu4jZN1ltbQUVXkCK8Esm05UUAo/U6kIxwfTWljXRP+EHktqZLmfoEFF/JNsSBqJhHHpYYRycjWnTK4+HFn7DnkLAHsK8vYDTEd+3JY9rn81tYshOwhepqJJ9ynj09qkJx9DE14bEeJ5zwDNsEBeHqQlLJIRnv8Hjt0JXriPyjPuWjU+Ig7vfkD8237Tf7b8Ah1vKcEjBLLtdwTth/vyR1IVw/u+u7q7jxgCCs8agy95q8y7VStQqin28hNaEOQvfoYNtnEHZRPg+TkgI92CkhSZPUAOZL9D6KgW6PfDvBNZUlO0WSFgcznx4Jb0nszwuMbzZugEVNdE622KWo1DAFvb4JIZ/1Xj+6VW43+vj7+5TU/JZHxp7pxRqhix3+SmJuv3JJz6LjhUNqPNRb/iIG30IWQw/g05E09lAVpv0zR9fNheoOc4g+dVvhhvu6ngCbb/Lnt+w63IAHWuiqlDWlfTsLQnL6C6qQoE6lL8eWDvAA8JoOXVKARxKvmSa49U90Zn3JB6KXszMYdyimhSlwYCfsRM+dtF7pUEzc1e/EbvtDnWJoLdxod1qe0vVGdylpJdBHFPFwpN9km1Y4bEZ0LNU55FWjRJdidtc7U+mzQ2akHCKAVAUUBxueAlem3T7FSVmK0lJQnwI85yXvTqINzvAqZ/SwW+vKW4AdhYfpUGszmdJvPJrk2IegYeUm2ZM4Kr342aYXA+u4DuaFbppeIZr/enZkJ5XWIpetfmjmZtPi/wwFxihtkEEWwFTC1qsU0uVUSJuCXLaJrosqImYFBw8qH9cBsE
 GLtsTy55
 DxF5QybA1T8dM4YaGGURPvEcg3JLU+xLMeFXBS10MmCzgyLVxvit3Ypj7nhUzpGY7hkk/DWTunUpeOL4jyyK3E6FptlDWSqA8/FJ3B007S6tAr5BD3U4w2JsJ1RQndvpDJGDAp48sckYudnelv0c87bxPoFiJ49FS4oCLUBWdOIPedB9Nm2Djbh57t5eoT4ItkE5XOtLz5BYVqhhqgx4hY+omyV0ZYdpLv8MrwqAyXsQxy7b+s+KMNHCNl2/6Enna093uTf2FjzWtQ89C9SuFFVA8pNn/WuAE8dzuphRY1GFTlw4BTLQXQEf/yvQG6PhIuZNdpRdrnmzFTzv9oedhaUAHiSKLA+8zmahl+TX68pC0fGg3KKEC/v2Vzw==
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

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
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
index bb57728962c2..5edd38ba70ba 100644
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


