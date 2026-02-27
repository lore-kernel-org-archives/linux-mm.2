Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B341039893
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4216B00DF; Fri, 27 Feb 2026 15:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B1E6B00E1; Fri, 27 Feb 2026 15:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555C36B00E2; Fri, 27 Feb 2026 15:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7226B00DF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:10:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FA69C2FC1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:34 +0000 (UTC)
X-FDA: 84491329188.16.F24B336
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6DC3F1C0012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBRHRg84;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adBcRZ6N/feIVBkm9Rv6T28TMxfba+nAFWMcJGZNc9E=;
	b=dc5dJNyBZsNdeOLTgtyDTSSh6sL5QZRDmSU9I/VJexbllTp120yatIWp5bEd61TvVu1BCI
	8YXbLWuSKRahJgvvljbt/yd146iPPijdjYiWMGo5YyQP5H2vc0VXKT2exP9XKWW1zbhUgK
	/wG2HMlHfuU7r1l4Rv+KVEGBV6anb+Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBRHRg84;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223032; a=rsa-sha256;
	cv=none;
	b=WiloxP8xVNUDLl4kQ5M0L/9lqRddQ1QVx9FODQuGEUs4yk8AZzLUb6z6I+h0tXI61L1Q+o
	Pwvkwh21cBsG8K7KCg2PI8LrCiGPnBtZwkh39OP+Ef97L0Aac95Lr1aVh7rcihxm9VERqW
	fht0Oivmhcv2tH9l0NXc/nN52XnDKII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A4DA432F8;
	Fri, 27 Feb 2026 20:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5E5C2BCB0;
	Fri, 27 Feb 2026 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223031;
	bh=GDIsuZYm2zKYxLFzdJGIwkOaoBFqEdMRlEhHeQ3/4/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBRHRg84mUFFa5j1Ap08A/NiDuF3TUvfcRS7C3+9hv775NpD/8NroucXGTumCDp/q
	 yrfW9Y3j7L6NHLbxDVoLPnwidDlbqQx43JL5ql1ycR4JGKaqhcycHzZzwNzJlcvc02
	 dllhdtIOUZfDuMDJj+LoTseNq6O5uagn4G64tCcqE5fAIbrOu0ko0XkUr7ircdpbQh
	 bXRyXmVj6xEUhwSFjMMxmlipUHZ264tacuMAwtSvAd5grFuLAF6s73NejFFuX4hEaz
	 JPFck19AXo77usRat6V50+er5SScDpOmDuKTSvIT6gz+N5E8JF7nu9dERR/ctItvMT
	 m5GfMgiKzWHMQ==
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
Subject: [PATCH v1 05/16] mm/oom_kill: use MMU_NOTIFY_CLEAR in __oom_reap_task_mm()
Date: Fri, 27 Feb 2026 21:08:36 +0100
Message-ID: <20260227200848.114019-6-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6DC3F1C0012
X-Rspamd-Server: rspam07
X-Stat-Signature: n6khu3413c9ew1a55m5zijxbdqcg6dke
X-Rspam-User: 
X-HE-Tag: 1772223032-192938
X-HE-Meta: U2FsdGVkX18iJS8qYVUc5qP/SYdzBKa3a/IVNhgGyb8WFQN0QZtw+a+VXr6aj55hzSIUA9R15DhJOFiBIxuw5OMFEHJjk0mhjDo6Nm67qtZ4WXU2IjwRdQZ0tTU0BGWylPNogyuSfMmmZCivA3tstrK7rA2g9tB8e66nvDZ+A4yZkd5reE/45C7AlHt50bsUGYTcaIHC7UnXY1IDpsQC8iheTCFq6WW35uuIUAXKyRIyckypmk7gr9sVfKuK69Vn8SEAOl9LSuzs+cD7pbr6muVt7np1511mNlArpdNbk5cKTocqrq0/YRYHXnF9sDwxL9SGgtfdvZ3luDrIl1gKSQFIxj9Inq60xwfgeNN0pjAuL/WIuPqCR9vPaHi6dGEDH/1RtOjUEfhZkYGfN7jEyor62/3prMcDAcAU4+uG5CSUf/CAHKzqmeanjBM+NGR4nEP6DqUkQ0K3g5NyXQLTIFLsemvmXps+hZZyrabXpOZTK1tTnjHYGCWoya5lFb7KOEtkgY0tQH5DnnjbSydqPoX4tQjYNY3ggmDXPKR+x3XyZs9RntM1g09xkzl8UrXpUe6XxPPE/7Y+9bjEr1CMoZE+TyYpfHB/SBOeap2pdWd1E1fdeh+ud+vD8gdCL+0JMQyrTrLvIDmLq2d7EHYtOtLNGFvtF4P9jArdxhCzTCt8NwTdzM+15mtQk3GZhLXBfeHCrsfn5E5MIHbXe0NQk5NzFSmkQgvmoxjsVRyQdDF6DskkTSEe4m/kRLo7qn3E/gHmPDlfdj3NEMDL3EHGZYCKjjDinr2PKVVoiE9lwB6jkVkLHZGCFqTUNjdLboYk8RGqjO36nqaw5BvFkIlnOVm6ZvjBNt91Amida4W+gt+YuWmvCOg5u6mzgD12uq3wW9worVGp08JE5U7uB2aWHMovWc7Banz3B3iGcu57zZj4CKRwHHWSUJEXAdKVqgv/RbhYnYg72k57PxaTdcc
 MoWQshPR
 D4fH0yGycE9mA1JmG6EPKYZ8SwovdpQzybvRuc3XF7PhEGlSmfogVnkrz1CWgFmhOLo4eThcgc9wHzgT1Bj33bq8I6vXste6Tzb8Ybw8kF2k0s/wqCI8NYTFerPxFIbHMomy3KYYi3BkC41OAZqoPiLcwSkOe9iuUc3vwJ5b+ah7Qeen6pRmCtJ7DBfOm1sqO84M06sLOGcZAobTgzDl5j8qm9CAQ/JRnjkqleZU6kbCoIxz1R+/S/DyFY9LYtC4CUl4qPTKvgxlzGFKxZsEjF8ob6pqyZ/oOeADBH3jMragDmGRW7QnFSvE5EkO501uvYioS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit 7269f999934b ("mm/mmu_notifier: use correct mmu_notifier events
for each invalidation") we converted all MMU_NOTIFY_UNMAP to
MMU_NOTIFY_CLEAR, except the ones that actually perform munmap() or
mremap() as documented.

__oom_reap_task_mm() behaves much more like MADV_DONTNEED. So use
MMU_NOTIFY_CLEAR as well.

This is a preparation for further changes.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/oom_kill.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..0ba56fcd10d5 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -551,7 +551,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 			struct mmu_notifier_range range;
 			struct mmu_gather tlb;
 
-			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
+			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
 						mm, vma->vm_start,
 						vma->vm_end);
 			tlb_gather_mmu(&tlb, mm);
-- 
2.43.0


