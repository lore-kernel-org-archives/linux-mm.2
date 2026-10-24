Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB9D606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jYWBq6IX
Received: by kanga.kvack.org (Postfix)
	id 1245D6B05B9; Sat, 24 Oct 2026 15:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD906B05BA; Sat, 24 Oct 2026 15:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013816B05BB; Sat, 24 Oct 2026 15:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A82BF6B05B9
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 800B4C03EB
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:56 +0000 (UTC)
X-FDA: 85358454552.23.F07E027
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 62E8420002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYWBq6IX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xS1eidmCgw0TtGME8hMj9/K2ujfNnd//amtw6mOPrqE=;
	b=oUUbqvD/LPXIqOYopUXsOqG1gIKIGdInK0b0iRYlqdjPuCuwC54xdYytIb1J4j+0WxGujx
	VbC4Sgyoy7nSr0i1BtbK2Nvi7JCv2bp2TUDK+G6z7GfOIvgdcxMYaTNKKJ9GP93Rjh/gIy
	9JjiWUGV4fHatrycpkG8iZ6JtTatXbk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYWBq6IX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868874;
	b=uU5po50G6fyH7VmF8Rd6BPP9/GdtMxAJaHriOQNIsvSL8OIRuUDHs36Mwh6CG+cvI7pNnA
	ECHqd2YaeULZdASFdcvXR5Z7WLrGd0u/t/3mhzG2k8IXCRHjLW6B2tLwXlC08JFdCZWm7C
	/LmxefwrOX2MODl6EndyusSO5d7Qgks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3413E43632;
	Sat, 24 Oct 2026 19:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB88A1F031E6;
	Sat, 24 Oct 2026 19:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868874;
	bh=xS1eidmCgw0TtGME8hMj9/K2ujfNnd//amtw6mOPrqE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jYWBq6IXlX+Bk3kW46e3tkdgYin6u7tEZ1VcPI7AWncbyi4nhaKgYfWZRWZ10PY5t
	 AQzE/OHM60HgY0H4QL5Bk6xpoBeIV1MqgO9RTW0uQ+bYLwbaxCy8M4Wk3yd2VqrV2L
	 se7c0vlM2BxedvhMyL39HiCj1vlROMjo9I4dMF/erIX4RXRpohPzf7W38OKpIEBxuQ
	 UuZ0eobPH2wi+Mgt8kAF28nQL2EU1utgBrjgORv7jl848Ghspdg0R/orvBBDS3lS5i
	 xdU5ovIp9BmzcdXVgNpA/7h25Pg3kcyf96F2oHRtXOOTiWCbhZ+FTuN2TmHUum/iQU
	 ukSiO3ZoH+m1w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:29 +0200
Subject: [PATCH RFC v2 7/8] mm, slab: add slab_tiny boot param
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-7-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
In-Reply-To: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 62E8420002
X-Rspam-User: 
X-Stat-Signature: 6urfunoyz4x8b6u9417mdhpm9jgnca7w
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792868875-292727
X-HE-Meta: U2FsdGVkX1+Z9VB1dF49ueAePR8XEaOz4Hf12vl8mpd9YopErIpcG1wmWfXBeeYTb7EbNfic3Jj8vnSzbPdJuYYesPYIO2360Odv0evfyxSGy0k20MGhLoytR6pr4f7hymJcKBqPP+o89Bidt+gtiIyN+042fohVADTdxcCZaL2IzB8l0laiTtpKyOGAU2GfSCrqHIbnfRNi+/hopoQ8V4aoKSULb0lCKMROL0YTTP1X/d+sjvPmtwxUcCpf6+cli6zEmvJOUmWQi46V35sb0ZBP6oaXx4kCXCb+dGLgRvaQnPpN28RudyHD/hyT/T+MiD59r7tR+6lJGRVxV9VZxvALwqjkD5gpnlthtEno2C3RYQoG2bpV7MYsiwBLoBX7w9Qf/DpzkOgrD8b9KFdalNoxEczWlFuvtahCM9axXMbL+QL2DnL3GkYnSsHQS3oMS9pmhLzYe/EkVFk/bDDasfRMx/L8haZo0pkXvIBJsviHTxEVUqZQRvc/2qoKWnekJ7awz9ECoU/xgf9u08IUqD1ymkAYEdFSpVoY9+Ch57AbS3wZ2wLVpMIaKHD0I6wUdqBuEuJo/o2SMDFxTlBV0dgCPPJLiabeIr9eCRCMyPNxSZxbF2/3NpEcDd5725aNwR+9Foc2/7tntOjEAfOZk+2bitgRn+43PnsKPDF0R6+NgvJFah3MF4qMvOTiieQp24zyMu/c1RvxwLS96aEZr4Y/2WV58mefIV8FmJ7fsIBIUeArnnVKpGC7lTkBtTJem8JUXGY04K/SpEHig0Ao7UAL0AD9LUdBfLtlIJQ1ee22EL9uofelK0mFxhZYl8nXh7eiWQJISXQyS5hGJe/kGqyRJVO9M9so/Znnlfb9O8WLAG2P0X56o6tjtAVYT6nKa4c6Vli15eG65vsORRxv0WjfvjkvJsXtsActKXp3QmC6CV1pTGmUYqkZAQCnwhwippX/7XDJ+lbpJs/TyZ9
 NvijoOGJ
 ME0PYoSOnzuuXqwiiAUVpTFSNzHiVB0nFxXn1MD/OzcIvT4z6zy18d5pwcFimSx+7qk5GR9o+klHPtEoMkZJIp3po3XulS7FZ+a4fNAvyHsK/5SMzF98MSLHAtZOz07pbsXlEFZI0eFoXglUPBFskIXOCqubV38MXrIAJnVDgAZMiPLlOhczMWgjsOkl6/PAq0Zmz1++/hVmQd9/vCOCU20gxxuRPqcBNNVLwl/p8KZv0mPBgFUo41ycy76+lkoMg+AT6B+EA+r9VeYcxfXv5XZsPuheyWDQzagLy
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
index 03636d799837..29dc1c812473 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7043,6 +7043,10 @@ Kernel parameters
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


