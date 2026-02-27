Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3028F1039895
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA146B00F3; Fri, 27 Feb 2026 15:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894276B00F5; Fri, 27 Feb 2026 15:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7805A6B00F6; Fri, 27 Feb 2026 15:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8696B00F3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:13:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0CBA8C5DC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:13:34 +0000 (UTC)
X-FDA: 84491336748.18.7354930
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E5ADC0007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:13:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BsV4ULrX;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRXSC4+iBXa4TW3ukLrtyEiHYn2JRmCbRPucTWT87Iw=;
	b=k2kKIot+xbTNOiO91oz04Hyqncmt3l8HiiAjSimK7V82n4z9m74J0+7TLXHP6ZpWpoHLmL
	f8GlCQViM73E6ykfBn35ArQh1ZnsnKFM0KBwNNL3uMf+DTq71gls9RuwoXsCxWr1QpRHsy
	r/tHpAssDiLJK07zEfdJoBFVB5bU3wk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BsV4ULrX;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223213; a=rsa-sha256;
	cv=none;
	b=eXT5rYCJnkMaGeYDAjJjyE0Sal8V1DyzpI9vTRgNc9+29Mihvw7nR4cbJ1BpAWxccXNkGq
	8l7thVENA5zY2A3tjvDkh5Mqsdqn45gAPVN0zftb1E8izWBFjXlWVw25vevaTedA2lG5rp
	KMToDEkeicNIJDUxTNirAfOSjUAx6TE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36CC9401C0;
	Fri, 27 Feb 2026 20:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5BFC116C6;
	Fri, 27 Feb 2026 20:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223212;
	bh=8DjODQ9JTo8rNPBCTFGX0cqEx7ur/z2XYX0+HQB8juc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsV4ULrXcf69csyHSuGqVHkErg/TmBz0CXhzBZuPFMOJEd58YYsV9GY3LYfW2rxUB
	 B/Bd+jNerrYiWu/dHQ4j9aEcpp/k/BLY3TOUIcBEDZazpW4Qb1rlsg807wAQftoetu
	 oKHzBMSDxjv/CxuvG+QWIc4cPfrDOfwX0D5SZxDFnYn2LED/gYiKa1XwK/OgvUaDiQ
	 wgo5tEx/CUq90wHpk0NTCoqjaz2e0NS8iGFwY2Tc6jUxOCGeEWKQQpTGNJBMzS+gGd
	 d3N1RDyJOeuPtak0u7xYeGcKnNxHOOxKOC4LpkDRwUfoXIisyM7oV5jLZ/g+BGM9tD
	 tmtukJMtnncfA==
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
Subject: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in zap_special_vma_range()
Date: Fri, 27 Feb 2026 21:08:47 +0100
Message-ID: <20260227200848.114019-17-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E5ADC0007
X-Stat-Signature: e37gwskzxf9qubzpuug8e4nauq77tcuk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772223212-47025
X-HE-Meta: U2FsdGVkX18t802PkEUdk8ED3YTjCFqxkRVtBPmO4tKCznGo4qQeBPmiwt2ZoBh1vxjP/4L10Jhyna+Uh3vmzKqMXx4ftMI6KV3LCD1bpa1Er4Bn5YlHUfHHNx0pcZ/PXSaadIlZLCR64BXkZDVPMzjYbhJaoO7/LkYV+XDBF4wgsnXk736kaYZB9cmRKglLs1LZ2JPc6Ptt18DbsFejzroFD4W+a5LBYmRVLz8+cK7iYOdsqi31lSKC1b9JuYVFem6cTB1hcHiqKw/73Bgexc7wK026w9pwhKaMi+qcUFvVT2D+Vx4SJY+M5EMTZZzC3GBwUVx8oDr19V/oF6HBsSaTDh39+J6Pl36MrCCR2vZFHi6ILbr2yv7RCN1C1C2aJgRwEG5gjfQHy8eSeHh4PeY44RBAzG0lVLoWHxW9cwwPG95EgMq0FuxM8ToentUU4AcoY0CqFUxNp06oYDuaNH/8nrYB6r7LbfhlNepAL9zEZNkunjlBrYwu/cJjJSSZA7Y22ZdKHAPOiArVPbZGozQvj74JAs/TlskR7CZjF0uAR/ZNlk7SuHDUilo5uQCy2LTPBXTlCfzkcMWP/iEX+Rxe8pcop9NqXC2r5RtleKQGXtLF9bcyuTh0H31zgD49grB8dWQujj9a38FnfcYv3cOR/oF+mZHX9KsSJ4GwsJ0jp5mBQJOEBuCTzY4Z+1wIfXnqXJUH+BekZvh1ZX+yQQK+W4ibvmYJ+8vMd/fC+UTO04sRCLwXlRRSgnTHkwWNvU0PcbJkiLC5t6Pq/S94GOdZB23D8OmkHWDN7GMIcmhYDZL8lcCt8MalIlex0d+bMceYFN6cXHY776HL6zyU4GOROibA7+iT48M9XchBvMHu3urHg37zYlWOBb5WOapaHKXQ44EgSGMcp3N+kTsLyXh8ZV/SIDPtVASdENNMJLAlP5S1uWTGWxasvFrb8l0AizbOZJbT9in0paELlqV
 T5eOHt5S
 0v+VzZDLnBkSyv8FO09ZDF52P4uReZTZy3rvWLFQVvVddTZeHjJm9eMpNo0UxKhxAXZgerwGcSBgJ3e7cVltFbL/uAf2ZIiiX/E4c3bWqFTlsApYuMWQVAfuJMYJFFLnxqMIqjT/wiSQebMVh9/OSMZNp4vafulKUhpa/Um4u5UB35QfcaAa3484L+3wabwOdYzT+VggpQ1d85dVXYAqjGwfnlaH7n5jgRx6XNqIZERDdVeROn0lJ4ccHLKN/636YumpdfGHI/tYBAEShA2lS6rkGM67iF5fWHeKcBGlyUX2lEA2lkGg1yd5lgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is demand for also zapping page table entries by drivers in
VM_MIXEDMAP VMAs[1].

Nothing really speaks against supporting VM_MIXEDMAP for driver use. We
just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.

[1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index f3b7b7e16138..3fe30dc2f179 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2239,13 +2239,13 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP.
+ * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	    		!(vma->vm_flags & VM_PFNMAP))
+	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
 		return;
 
 	zap_vma_range(vma, address, size);
-- 
2.43.0


