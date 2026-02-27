Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B55FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558496B00E5; Fri, 27 Feb 2026 15:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523226B00E7; Fri, 27 Feb 2026 15:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4185C6B00E8; Fri, 27 Feb 2026 15:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29C866B00E5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:11:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E129213BE13
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:06 +0000 (UTC)
X-FDA: 84491330532.01.A7D7ED1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6E25C160010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RtZuxKn3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IR4UGUOMgNOxTtW/UDLDk9ruI161Ftbjj/3k3iE/RdU=;
	b=MqfOjYmjHp0IhCUQzcurRxp/pGbMTaSBa48YWqSMiPwfPNKCuhyiyLEHuIzxUMCRRz7vxz
	SGlct1Ry3thuBPBtAML0p73k8JWwrOUCxJn+IeK16iC0eiK/TUcsPmN/+rJDspqAx8E+9Q
	wcPcNZ30lCX7G6lYCWOtGqGZiXa37Vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223065; a=rsa-sha256;
	cv=none;
	b=tmCX6YGqu82MBhm5p0Ia5YZvdwag8LeAzsf/fbNhTz+w6Pwgb1OIlJN53KW8Hyvs13k0H4
	alu+gQiNvE0gCC3OnMmDZo5a+l1pWiTChYk9RL/lc9vEsU0ahJwVcUBARh+oTPwnWDCSy4
	mXfOlklLXRRR2b8kWkQ3QP058FJ0jA4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RtZuxKn3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B518460126;
	Fri, 27 Feb 2026 20:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1D7C4AF0D;
	Fri, 27 Feb 2026 20:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223064;
	bh=1+QuoW/elQeLApVDz9csX68UOgFLcRXKeXzvwiiZ4og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtZuxKn3Ziqokc8GpxUXMnZvP6x2/VNh0HcDRcORj7Jjg1pwi+muUt68y2oAPSSn7
	 oXm3RcX/NB5+rlaz1Axv1CYblxhdridhg0R2TC1bV4DMOIkHe0e+ljXOAu11x8YisK
	 3cKrd3jepyMfsg/8UQ9qaT5UFz7UcP0BvlO+Vb0tqIcwpCcAoN5ovlLJWFsERdCVR6
	 c+KzkQnQ8g6/c5BNYsVswZIxJhuTUYh3A1VIWKouIbNnLMzCE98PRU6kla3Ls2hHHn
	 Xnpogri0UwXahapxbF6VQB/VcdHdOn11slPbn6O6jernACtIFzDi0c0Un4gk9KL7uH
	 doaGGvuSkLX+w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 07/16] mm/memory: rename unmap_single_vma() to __zap_vma_range()
Date: Fri, 27 Feb 2026 21:08:38 +0100
Message-ID: <20260227200848.114019-8-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6E25C160010
X-Stat-Signature: cszf98pdjjjkbt33od1hfpxb8s314d5e
X-Rspam-User: 
X-HE-Tag: 1772223065-129619
X-HE-Meta: U2FsdGVkX1+yfL294L8IYaWdp2KMko8T1AgmdjaYE0lWCYcRufRv4MECBkKShKV5zjNirI95UXUz4O5wZXbQJ0anpYBjNzFgQWC+QvAsgLw/uTZhZKWl6/vVyBDpY0VJir2IH+Sk/zdUFqOr7JAyvT8IAKsN8e/Pg20DF7/OPmDDrFt6jCW20z4mbtT/3qP5TtAoxKfdpEmXKRGi0H1I+OLPouua3M7gkdC/uSShkRRuXx36Ktnpl72iW86NAR0rcH0FYd49obLd4buxy7UQSETPpniqdr1zKFzGzOF9Ciew8IcAOKisGLwJiHmub/Nt+NlmP5Fito6IJK6X4baBXE/JHzufjiaWbaaP3AazavAqYInfQx2hHEN4AwJC2EqGKq6tstaoVrB8jGst88aA5cgm9W/U04Je+wK+TtwSsSPPklDdZyogHLD9+Gx2nZoMSVqc1ZQLV+W5RkOqJgDIQWaf7dAs4k8huwiFuEstATv/apVg1UWazBf/mIqpJ6s77PVa59a685YdEOj/ZX+OQKhLvcicpRw+jnF8PQMPQEAa9xx0GO5FSY6myJnAiw3RGklmOHGlv5LhmrC6DP2ALCqQzN0J9ZlTobsDESMLm7bRzcYdtgf+yrlUB3dSIAryHVC2b/rOPTBgBoCjIII9ajNDiPSApz+AeoUS/6LKXLCNC7lMAaA43ZX+cMihImm0VIfdSlK/X4KHsA11R96qinQSTAPYarleASS1gq19czh0tWmA5f00m+1QqxR7Z8Dfz3NDBYZ9ttl7xnc74oPwspPpy1Vk+uGH3X21XaXKdjWjh4WjKZ19I6xF7V6s4rE/Ew1qNXDPI/CaOGXw3h4HupPAxZywqqV8WlI05hIlAGpnsKJDedWyYjPhIYMjMok1hvmMgCkKR4N4VMn0urPVkjbK1xVDw6kSIkEEf5hqAqBL6etf9psVW3ijdoOa91nIOluywurWfuvhJE6/dj5
 /4TQN/nS
 DngrhrOby9pldDF964Rv1oVrtrsLaDnTVVKzqUTC3+jiOudo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's rename it to better fit our new naming scheme.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 621f38ae1425..f0aaec57a66b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2074,7 +2074,7 @@ static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 }
 
 
-static void unmap_single_vma(struct mmu_gather *tlb,
+static void __zap_vma_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		unsigned long end_addr, struct zap_details *details)
 {
@@ -2177,7 +2177,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 		unsigned long start = unmap->vma_start;
 		unsigned long end = unmap->vma_end;
 		hugetlb_zap_begin(vma, &start, &end);
-		unmap_single_vma(tlb, vma, start, end, &details);
+		__zap_vma_range(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(unmap->mas, unmap->tree_end - 1);
 	} while (vma);
@@ -2213,7 +2213,7 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
 	 * unmap 'address-end' not 'range.start-range.end' as range
 	 * could have been expanded for hugetlb pmd sharing.
 	 */
-	unmap_single_vma(tlb, vma, address, end, details);
+	__zap_vma_range(tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
 	if (is_vm_hugetlb_page(vma)) {
 		/*
-- 
2.43.0


