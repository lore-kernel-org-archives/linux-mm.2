Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18AEC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57896B02BD; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE34C6B02C2; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BED06B02BD; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 677346B02C0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A174BA2418
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:36:49 +0000 (UTC)
X-FDA: 85096951338.19.616AE1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DDA62C000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:36:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rp9Z/BjE";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642607;
	b=EF4qZ1oIhDsdFxwVi9NhQr1MTxwxF/2BmEfbNzgQpuqG65XkbaGK6fx+eyz/Xv9AZ2w8/F
	oEFvMGIPNb9YwKye1m2KP5fLvqZAtAjIzZCIVLzkDOCT9OAPIShDzvvBfpLLIl/ratPQsl
	9cHr4zdt4r0z6RGnzzFV/0HeAkC3pVs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rp9Z/BjE";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EXc5iOEg9H0d0e1HfYbF7zEjYZ4oBYHKpBUsUiBnw0=;
	b=8ciIZfxk7vWznTOmF7z/iccoq0oHhfD+6Mbmo8+5pRx29/oFJqkmrBSbK9/vFWf69k2YxD
	Cc9tUGAXpDaC/jY2UcP6KQHAOif5SCXEtaBEtN9pSoSt3d56Twy3UZK2LVN5Gne8wXFLfT
	8AEVDQrlAKMKpC84UFR/wvsoJhjq5Wk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7ED98600B0;
	Thu, 13 Aug 2026 17:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631C31F00A3A;
	Thu, 13 Aug 2026 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642607;
	bh=5EXc5iOEg9H0d0e1HfYbF7zEjYZ4oBYHKpBUsUiBnw0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rp9Z/BjEPxpYUoyxaFds6p1oBZAw1SzuHFYiH/cSF6KJkjwec8ieKG8PtE6ebH0Oh
	 XbFmJ+JOri7Q0P5RfkiRIkg7AlWnDHfYrpxRm1e8iXTFNx4Nsul77z22qVOlnUkQ8a
	 uPGrHtUBs6LHOtSIC+tCPR1DG11boYqayR16QQnlpYjEnpvl725Lg28dz7gZnVluGl
	 BfV1JcBTm32fY9GvnTvAN9vQUPJRs9g7qfW/StEW0gC4aLs9Dg+IB3GrdoCpvzyOJp
	 31rLMMpzLNA+nX43lEvPi/d0gs6sRAs2Gxsb4Necef7josS+e4lxADOFVZ5w8/XQ7t
	 jj+g1IHiSK5iA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:28 +0100
Subject: [PATCH v5 11/16] mm: clean up vma_address_end()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-11-c21581c0c3c8@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040; i=ljs@kernel.org;
 h=from:subject:message-id; bh=rEAXpM+Q48loiQvQcclMM0xWbuZorGJAZULvM46znVw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/6/RMJi5nSPlvT53x+qFS++Jt00McDb5oxCeU6vV1
 Vx+fFNIRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayuorhn/YPuR0iaxKVZ/XX
 1h39v2nu6qlREnOOcTZsuvVzcdRxIR+Gv1JinWoLribkBHpV5ngUvzrE2Z0eo+d27syP3CUHJOb
 x8wEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: DDA62C000A
X-Rspam-User: 
X-Stat-Signature: g4hfzwuaqo9bxnqqaqeybpgaun7i47a1
X-Rspamd-Server: rspam06
X-HE-Tag: 1786642607-678495
X-HE-Meta: U2FsdGVkX1+cKArMvQo3IHOk0BKo8O31aOOKbY1YELCjqiIeTfI9YXf9Y0m36h6f0jEVhOf8WGKnJ7tQOakmIPBfXJBMoHN89oI72p4pBuQ5U1zBlgr62jOLuo+3u+C5/SkpcJyvpfJtdPU0loLIELNjNC+ZyCCtwu0qgpIMOAmW6p+YfxkWmfDZjsM2i2PTCDY3PJUiwnjk1ud95ihj69QyZdS8XV3qEea/VTxYWArzmngZqFKVTStQOfA4XeIztORPCk4BrRlglTW4AUfvqY963mVa3tfuCMyiiyOeyn8NY3fPfYyXHbt30QZ9pVMDeBdZpDWZS9NwaFeYTMlIVZT87GYQxM0/VqxibHrycVHMfAgTjMYBLaEYpLB83PzDs8yoWni6Uzce6I1mv8VFcT2n2W9Es+9WHRBlVGpyBGtPj0aFTLi2jwyj+mohYvlTSH4mdXVJv4sospv925PNur4AiOJtYMc5El9OgyNIyDbaG04kx3RTebkICMGFGSpGHz+AyOot0puhcls0VTUglyV6Oq1kfCiAxz12dYlQuHyo7VHS7UBo2O/nam1rW/OmImpBADf7/FpUPHdHm21O97m2sEEtgio48zhk6ekNvVwRbadhwihwF2H4C8yQ+l4LU/N6a2Hi7K84Hw3tFK8ADwnlAB3ikCreUB5UiGRtY9xIZxf4aJ/aKnbNH82gB3c7wCF4OOPX6HsUIk8r3MPxS5id43iQk5r0v1SEuxykOIEUS46ZZOPxmjDdMR/oED+TLhIoI0W6vyposdQofAWqRLpuj0iYQw1zo1oMgJAGEkjO0TUXrVbBBc8WdWPpVEYpBxPGPV0kHvpstYMqVQJek3C8GfedkQ0Fo0S6CxFzA4FYQTOQg2QuWLHAP2r6nl994fS0CPIZIsoimXoBv+eK0XTvMUBi1SSzZz2v7liaEbi5XEU7+7zoaaAQ7YR+UVxSm422ZUqu0QB3JxUGTtZ
 OwPFsyAv
 tB2P8R/tyXUPPwnRcbPceyrRsID6y1AVvq2YeKo5WrgstkNjX4nYeOPs5GPQTSnMPMIwau8pCyeOsvSDlJctPNg+AVhCcFtWcEllgqPIgHW1pFO3VpWiwjFqCi6j54UFhRtgSsiy2z5n0wRGwx8F04dJplyD3LL+dZxSQBGwo7xn+c+/apb5ZN/I0gtyHSEsuD5xjsMK61LG5D996E0NPw+xJf0garIPDqFWoNWLmZtEGCtWiUZYfPNRGsw0ZS3IaQ6nBp9dR7B5zL+MmQuqi6Q6SZW9q9/cHKQ+vcy4P/9mKem7bVH2u0HbEsOpiysixH5H1kYKXQ/oUwJ8xyZZD8qhYljnD48jn9zkYBgC53PgZg8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_address_end() is a confusing function with a lot of moving parts so
clean it up prior to extending it for anon page indexed mappings.

Const-ify some variables and establish pgoff_vma_start and pgoff_end
variables to clearly identify the page offset for the start of the VMA and
the end of the page offset range specified by the page walk.

This simplifies the function significantly and lays the groundwork for a
future change to update this function to account for anonymously page
indexed folios.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 03145b8d0d56..98b067472ceb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1079,22 +1079,24 @@ static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
 }
 
 /*
- * Then at what user virtual address will none of the range be found in vma?
+ * At what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
 static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 {
-	struct vm_area_struct *vma = pvmw->vma;
-	pgoff_t pgoff;
+	const pgoff_t pgoff_end = pvmw->pgoff + pvmw->nr_pages;
+	const struct vm_area_struct *vma = pvmw->vma;
+	pgoff_t pgoff_vma_start;
 	unsigned long address;
 
 	/* Common case, plus ->pgoff is invalid for KSM */
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff = pvmw->pgoff + pvmw->nr_pages;
+	pgoff_vma_start = vma_start_pgoff(vma);
+
 	address = vma->vm_start +
-		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
+		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
 	/* Check for address beyond vma (or wrapped through 0?) */
 	if (address < vma->vm_start || address > vma->vm_end)
 		address = vma->vm_end;

-- 
2.55.0


