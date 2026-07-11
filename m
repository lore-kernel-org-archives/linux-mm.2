Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F71C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09296B00A2; Sat, 11 Jul 2026 14:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D930B6B00A1; Sat, 11 Jul 2026 14:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59166B00A3; Sat, 11 Jul 2026 14:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7D46B00A1
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:48:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BD6C169A04
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:48:12 +0000 (UTC)
X-FDA: 84977380824.28.1258EA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D5CB21C0002;
	Sat, 11 Jul 2026 18:48:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jgpXcvfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPt/8l9E60JoRhMjGZtDOkVB0VSnW+l2hm5OFyFrrO0=;
	b=N8wwopoY85nOwTkXIjYHV+M43a1zAnBln6u9wHlNQS9nUCJQQmwEs7kOQQzlUyyLm1m+mx
	S+n15i+MUEAwDzZ1j+3yCqBULyP+fKZyM6NjUAW9C8aZeYeZG6znWFz41dnWx+0ojfJ7dN
	9kepyG1BIRyxBqQ0SOuPEl+qO6EOt8k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jgpXcvfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795690;
	b=LWNXiN2Fw5TvowRENia1tLQIcoTFjVBFvfidsfq+WrrXvc8zO1IN392AqnX7jbrIrUsv8V
	WW4zPHmBw9k28SGdaIDYdpCECpt8P1JZZXjzmtvkNh8QbTmGwwfaAGjwpZRs9vsqM/+67s
	XMsMKPVnymaYM3n+R2ZWeSsm/0Xx3aY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49C4360052;
	Sat, 11 Jul 2026 18:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E9F1F00A3A;
	Sat, 11 Jul 2026 18:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795689;
	bh=QPt/8l9E60JoRhMjGZtDOkVB0VSnW+l2hm5OFyFrrO0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jgpXcvfv3gVBn7IsGBF1ebSBCDETWMhhmUgGYFu1KJSh6jDQWPcTX0Vq7whuKCVn4
	 rBhFdMRmgxmdR8P0PcWxbkTlO8COzjvSFflXXXwYeV1HcoXi8sN68u8NJ26w+IOyUw
	 R0sApERkImbfGC1PQUNQIDENSFzQep8HDEipIa0GQAQDHYmD1VBxVxmWBk3vGxNW/K
	 4N9W61bIOsobxULyDZZV6QFTrlSEId1V48hblg2M8NWfCHnUNfV+Pr7EKw+8P7wBkV
	 cuWci1FXthx0PZWUsCVBzadkDWBmiusvn/RlVjMBQh/ePtU/5mvkHHdKyTyd9zk3sK
	 /EpfagqzUOOIA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:45:04 +0100
Subject: [PATCH v2 07/13] mm/vma: rename vma_get_page_prot to
 vma_flags_to_page_prot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-7-0fa2357d5431@kernel.org>
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
In-Reply-To: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Russell King <linux+etnaviv@armlinux.org.uk>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Sandy Huang <hjc@rock-chips.com>, 
 =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
 Andy Yan <andy.yan@rock-chips.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>, 
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org, 
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2845; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Soud7SJAfopgWlkROt1dYPu535d7z0wbh0cd1bt/8n8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+i1r+Lfnqbc90vrVGDSl+P4cT/kJqy/bTGI35c5dL
 sXF8uhaRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaSn8zwP+Tvx29OMZ4Olxy3
 dh5LDd7V18X908Jec02jyvrfMTdLNRj+cLwPSWPNn3D00+v715gv/5eulHkbvKPiskGWQoG+s6U
 EAwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: cob83srbczhd1zftuhx6694agqdtd5ph
X-Rspamd-Queue-Id: D5CB21C0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783795689-385446
X-HE-Meta: U2FsdGVkX1/SRM510jIh34wKbPYpeoBm9lpfOQf9x4viGl9DU8Mz6bYohv4bPaOILDNJ71E8z0EfHtUJd5Iom1glp4Y0nwc+XYs87pCfHNXwDe7yC9Ck8B4YyxDG5/Nqu4Ojp8Hag9JHlC1QPpcIgGLn91bpz2CvgJId+b+mip7oGfq0ZZs1q6yhw4mBsXGfHmWuE+44wPWzKLpUD71PG7R73WzvW9IPybV6KkAgVS6g1Gvkb7q+v5ggi7CrM9qejs7JcyoODfYwDTJ3THuAe5lfiJ8Qc7stWbN6ALmfjQdslFUORJ2DBkyhSJ+FhnvsuANItUxwp7tHw89fTNMxPWMEW/5F12CLRZzTmZSwu75D48eDuT0pktOmFrAQPQwPbOflYH5Ya7c0Mqse4uSAT0Cp8dqSCmqFV0/RBGLZXssk8sbI5/ATRdk9GTdD95haOxd7gHT76Ce2V/FIMw3pQTS719eD73EE6FdFunE//vM+6PLOkXKNcEp1uutDY6sXUbCHUNAkpIIMr9bDvw6PG6RgRd7eVlj+hasj2HP5X3ZmF2Yf6bFbH7GhURrFiRDjVrUNF9uMJQ4RQlerud6g1zgRiDqFQnYtAoTtaVxz7mtxEnHjQ2fi28t/KVRqK+IVYa5TWY1EmzoHrulAkVp8xit8kGxn445BROorY8qG9g/0y/GnyIjcN85HOikRoOrdP7pakEko5kfQoYaZ+v2X2j9OQJwwSJUdjcgsJBtB6TbR7hEZNdcVv46sJHsR6MmGhba862t2JAmfLJmIC4/+iNVmZMBP62y2EfKqz2fiKT23lRDr71JH+cuUMWfxF1UtswKhHaoFw4cwa6GDm7clRke5Oa/UvOkDby94oZSODQkpJHyIuttL9kIpmMcr+wZ3O5BaRkhCV+AU7wL5HZBEtkrIVesuc0LLL55EXP11Dxc+gVZU2hMEFrmNQGYgq0urDaSqq/z1wH6l0JBh1kq
 pVd0iLZB
 E8HCjcicXKwOjJ0kkvOLMmrotbd+K838oSiFXAoHozQAWjNBVSEkwN5rIkc2ZwC6nFVBpQFrRa4/wwXVQA/r1pQEecrGJFrE/KXfhnAdZkmdxCY2DzeUw1Z3OZDB/oHXC3hLHYFBfcotStEgK8M4PmR+mSDK8g+K1xeNkD0RuFBcsC/SJejzAiaFPUyWGwFFKHIF5/STSbx16f4LBR/Ry4VT7HfKDX/Fm1zi8HPQmCsjYj1zdOZlqsVGeM2a2Dc9QwLOT8pztx43T7sVzPkUvxDRH584lIga+xCnT+oqmmS1IiMJTGgHxtAmYe3OVGpBTWbHWQeaP9k64Flxb/xgBhWJ8CNHoqYY9j9moZ4Y/g3lPZwMm3GBcFox7otzMzalI6ZvwMvp3/cxVs8T8Bw4vg1cKPyYhjxCkfnoc4LqDeMm0N84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having vma_get_page_prot() refer to VMA flags and vma_set_page_prot() refer
to a VMA is confusing.

Rename vma_get_page_prot() to vma_flags_to_page_prot() to resolve this
confusion.

No functional change intended.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              | 4 ++--
 mm/vma.c                        | 2 +-
 mm/vma.h                        | 2 +-
 tools/testing/vma/include/dup.h | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5b3825fddf58..b8fe40f89d87 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4603,7 +4603,7 @@ static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
 #ifdef CONFIG_MMU
 pgprot_t vm_get_page_prot(vm_flags_t vm_flags);
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 
@@ -4616,7 +4616,7 @@ static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	return __pgprot(0);
 }
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	return __pgprot(0);
 }
diff --git a/mm/vma.c b/mm/vma.c
index a74a0e467c63..38481aca7321 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -56,7 +56,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
-		.page_prot = vma_get_page_prot(vma_flags_),		\
+		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
 #define VMG_MMAP_STATE(name, map_, vma_)				\
diff --git a/mm/vma.h b/mm/vma.h
index 8ca6e7e8ae28..0bc7d521e976 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -543,7 +543,7 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
 #ifdef CONFIG_MMU
 static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
 {
-	const pgprot_t prot = vma_get_page_prot(vma_flags);
+	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
 
 	return pgprot_modify(oldprot, prot);
 }
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 24955a1e318a..8621a7ae8980 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1545,7 +1545,7 @@ static inline int get_sysctl_max_map_count(void)
 #define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
 #endif
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 

-- 
2.55.0


