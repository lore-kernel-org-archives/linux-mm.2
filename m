Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B501039893
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F326B00D2; Fri, 27 Feb 2026 15:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD066B00D6; Fri, 27 Feb 2026 15:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E7F6B00D8; Fri, 27 Feb 2026 15:09:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D43746B00D2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:09:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A51D65B8FC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:09:27 +0000 (UTC)
X-FDA: 84491326374.28.FE54597
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC4D3A000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:09:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TykYjpWv;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772222966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKaTaYabvIguXZmWNNd+BNDEApRXksbBfmtUQ8fhMNM=;
	b=eZr8dG/UXkJnHamTklVvVtF1jGMiEfHCYz49DceHJBHzKZHSqt8rtc/QOjTfSBH2velQKC
	AayXALPPU/b7xPtzYAJamaktdDk5O50BKIb7XYgCsBd/e5MbswV3/UFplHqfIHzG60iJlN
	NNoTkMT8srr0sDaXg9rXoLn8ayt3X0M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TykYjpWv;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772222966; a=rsa-sha256;
	cv=none;
	b=x/rmeVooGshZ6VpUtZdykFSjuXWCp9WgDfkyOSPdtfuVKTPuYqCpBqy26GX+zo2NLduomp
	CvsZklGhcpvN9JZPikh/PnW+9tTEM4GLpxYSHzuin9ctHZWvb6JpVEWyWkatPW4jPNwjp4
	WxX9J18SHldcAXxGyfTxJ86lLCSYV3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AEF0E434E8;
	Fri, 27 Feb 2026 20:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80D2C19423;
	Fri, 27 Feb 2026 20:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772222964;
	bh=oTLLv1/LtvCwIvkJbROBPO/znHjTWfNn5494fkK85gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TykYjpWvgGwljpM6p2COuJBm6vVZY9Djvp9ZNM6zX/Mg+sBmes0wCnbQ4WeSfbmW/
	 SV+IDNBtumzcZhC3ElSbyAiv475EkpQUkxeCLhsWULdxAHfGnT0H335AmzCjAN+dQj
	 QRAOmuBYMH+Ynj0dVRD7vPT/l9+4APLtjm8nWyekU8kueRKpx8XbFw5ajrTVTYHSCI
	 fPG3LX2/4RfCF7sYKFaOg85sIPFkNtlXfBAxGEQ4tDcYAx7xhGzd19vCY9jvvC0Ulp
	 O7aQ9sT3wfiLxfn9cUcpLrszMNdsrZRZprFMOD9AkXLMBxMByussndPeKhWeTlHo/m
	 zYXuh1oeZiM/A==
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
Subject: [PATCH v1 01/16] mm/madvise: drop range checks in madvise_free_single_vma()
Date: Fri, 27 Feb 2026 21:08:32 +0100
Message-ID: <20260227200848.114019-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7htyo1ajprce4c6p79r8te6n9cucxmp8
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EC4D3A000E
X-HE-Tag: 1772222965-721304
X-HE-Meta: U2FsdGVkX19Pap1b9YIeJzLc3H3HJEBP7NalsqrXVygBNSYzsGpLgNJqD6OXJuN3ZCEGZFeyQXQFjseXkwEJQCNWO+eFUzDogHQnoqCTFnQigl0LYfLtkFmk2IawPFHWc+4qp+/BOK/ehZdtNPJ2grEULJGwZjTbJCNLZxmzcIWx5aP2oMKCbbRKEzVSNJbknzRieaiVGK3FO2PNYVe3j9O60D4zZ2Q0uxK+BDdEsKfAI4NYw532t8TOKnUPlX6Od/3kzEQt7Z1BOKooonxczkx5d7+hZyYQsRvHb/WvUkC4bNRtnh2y7ODAwdwrabEoI/xO/nxhR2o5b4LDSKtGoav2CL9PJLIBfjCswRIC+XJLGTj2DrC2XGZBrxgDmRLroCwM3/0uMJV0LXgRLPqq75EKFiTh2rNmYUyfZWaR6hXjangNRf5vgRJbiPCImGgE5/D2RRKmhV/7mKFX1eQPTeLhmP99ENccxSJ/eJvMGmi8JPCUZ2lKy1Ve3mrhx6Kc057RYMSbPLNCJ1mwzFdWxgU0xddlBCzgcu7B3DVtw0v1wjYAGs0s8djTkS7rEtetayhAiK7jezdXUw3LVUcl7wcYCV2Y27wodbpjnHop3vcBzif3OWLLFmBBYUWssMR269fptLHcFjeCf7cygAqZU6ideBTphSoU9ztlThfjcGLQUG51N6qLPCSmRGFGEbl9pO+FFYzVZtVkZEm3WR6x993AT3ZPre1bOxKZSRcu+MONtMKVErLWi2t19wTN5UCfk4Qe+9I1PTN17xv232JFevkrPAgPEfTBtFQGxqR0ck6ogRjbEAguP951p8oSYg9rHyiGIggxC+tooAiwCG7Tf/4qvzgdmxaSNhDe+pHCI0tlPTZBj38r8d4gr/PGoQmEDoFIB6uMSJU3q8w7I38bx1FJk39/oiZMQuLqRE6PWvP0r4V1M2IHrK0sBqxmmriupLDqxk/lrgsA86oN64X
 ClxO/gv5
 cuqxu130z+JLYRca53mGd98JMvHV3v8UDbwtmkWhjG0tvRSAXwjsRbQGDJ6VlMeVr/7vdZdHJWhl7ARb3/EWukZFLzgGnEYeAap0JaDMEEO5m8Em0DCw+lEdrpeXJ6HZxbIIzF7aFf8Xi2DazQyLIFCS1mYJq9RHymc36iniovMOByFCSCH/0vKe9VWG7UO1IGhuoOPjEf/ecxD6oQiW7/fk2Z4yRAq3gK6TG+pzWiWBqlzKyu61YPaGVU1RnsS4GQhn6C2DfmizWTwjcyBBJ2toNkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_vma_behavior()-> madvise_dontneed_free()->madvise_free_single_vma()
is only called from madvise_walk_vmas()

(a) After try_vma_read_lock() confirmed that the whole range falls into
    a single VMA (see is_vma_lock_sufficient()).

(b) After adjusting the range to the VMA in the loop afterwards.

madvise_dontneed_free() might drop the MM lock when handling
userfaultfd, but it properly looks up the VMA again to adjust the range.

So in madvise_free_single_vma(), the given range should always fall into
a single VMA and should also span at least one page.

Let's drop the error checks.

The code now matches what we do in madvise_dontneed_single_vma(), where
we call zap_vma_range_batched() that documents: "The range must fit into
one VMA.". Although that function still adjusts that range, we'll change
that soon.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/madvise.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index c0370d9b4e23..efc04334a000 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -799,9 +799,10 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
 	struct vm_area_struct *vma = madv_behavior->vma;
-	unsigned long start_addr = madv_behavior->range.start;
-	unsigned long end_addr = madv_behavior->range.end;
-	struct mmu_notifier_range range;
+	struct mmu_notifier_range range = {
+		.start = madv_behavior->range.start,
+		.end = madv_behavior->range.end,
+	};
 	struct mmu_gather *tlb = madv_behavior->tlb;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry		= madvise_free_pte_range,
@@ -811,12 +812,6 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
 	if (!vma_is_anonymous(vma))
 		return -EINVAL;
 
-	range.start = max(vma->vm_start, start_addr);
-	if (range.start >= vma->vm_end)
-		return -EINVAL;
-	range.end = min(vma->vm_end, end_addr);
-	if (range.end <= vma->vm_start)
-		return -EINVAL;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				range.start, range.end);
 
-- 
2.43.0


