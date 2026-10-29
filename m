Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D704E60A3824
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WhdvjoN5
Received: by kanga.kvack.org (Postfix)
	id ED79E6B05BE; Thu, 29 Oct 2026 16:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF1D6B05C1; Thu, 29 Oct 2026 16:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5866B05D5; Thu, 29 Oct 2026 16:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEC6C6B05BE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:45:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32F13C0529
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:45:08 +0000 (UTC)
X-FDA: 85376843496.22.5BB72C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5142A40006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:45:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WhdvjoN5;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTbYn1B9uEaHo+IwnQISx6DSu8nadScf/DEgScNsxUY=;
	b=veS4Umz1n7JnBfM2M72TJTC+3GSSMfNxe/57LR4IDSuXTcFnz+mXoiCcQJZVrPtr9pK/vp
	oWC7v7JSASO5Aopz8fK8ibGF2CF/Cwgp5WgJnq/c3u0SYMnTcorf0eGBvt6B5/VISqrE9A
	rs4CfGHtHWOEamaZNrrTA813ImJkTPo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WhdvjoN5;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306706;
	b=KfkCidrf3Vz/gKFMn79L1lXTLU6iG5MRRLgRxf8clUf1x/kAK4KyycVoTSxmX4bQJQCuIv
	T6ywJ4t9mT9URRD2+U4M+3HrH4gqkobvf66UAu+OTxBsL0FDC/sXwwW9ZwKalW3he9W/1s
	jZMv3XjZg8OyHMyLdD+Tg+84HCRSTmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5EFC60623;
	Thu, 29 Oct 2026 20:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB641F01826;
	Thu, 29 Oct 2026 20:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306705;
	bh=GTbYn1B9uEaHo+IwnQISx6DSu8nadScf/DEgScNsxUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WhdvjoN5s9yBtKL7TO38yUQNFfwrtZV+RPRgO+dXzIyrW8v5zeF7U9sUJeRD31dCv
	 tnqMt3RnlqgeqbFDBeJAps0ju8zYO89p+SoK/or2UoMdEm0hCT/TD/yDv0PCOqJ85P
	 fNE8dHo04vvN/YtksdSHaEnUUy15/kf2CTeZdHFG47FJoXBqSAglNrRlOwaDjz8AAy
	 wlfc60h5OWJMf1LQnsGiuPdwzn1ZbsCsvU/CR2NPTcn/RQ5ASf9KNEV4lkEIoVlIr7
	 6AOCkbODg+/zUBE9orFJVeVfbx5hHhBwXIQMFWWkdVDDspFJ9Pj/83r9qJZySYzwBG
	 KUEYRbyPx4IGw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:42 +0100
Subject: [PATCH v2 47/47] fs/proc/task_mmu: refuse addresses beyond 32 bits
 on 32bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-47-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1693; i=david@kernel.org;
 h=from:subject:message-id; bh=H23iSXQ9Zo3UCvNDkTgZhR+Jd2mqfSBMzvPG+6Su2Bs=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+36dd5g2Q4ND87Jf761zFBNvRKV+lT8j+vKzflze
 YyOa+w70FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEvrUyMqy5fPDlzml6Z/cX
 79h+PNfDilFB5ZDotvsSF56fsl9+5eVERoa/IndyDIr42sM3z5yxY7reXodOs79NDjUek3fdtxO
 tdeEBAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5142A40006
X-Stat-Signature: radsj6gsdoi4n4magqyjqqmybzcqkpo1
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793306706-338177
X-HE-Meta: U2FsdGVkX19OMpRv4WwMIHJHuf156aloIuw6nHI8WI1OpXMEfetMxKBmPEFdz9hGtdNnXIWOfYH0AzexPvIlgoOXbwnrbeNQbht90FfPRm3NSswwaonsFpiCbAFxpoq3Zl1691hyiaW+OMVOiYID/voqrVmD7EW0PpNUqtnmMV6BXn2ptfXNZd9sd9pcVXknMOPQ+gIJRRuBCFnCDEF0sNwTVlZLOvvURQxV4sgFmBbcZ+4Sftoe4nzKw474fRWA9dYIvWo/wsSwNnTgBFlFBD3u2S0tiNiNmmxkydt/W65dJqjtvdpMj4TJM0q+71EA/YFztzuaMhv1sXFA1bqq0RTScSTP/Q1UNGcZp0dneA1ZHrd5zKMOwSHA8GhxKicAhm6x9D+jklf2zuzhgszmTNhxNvjxU78tKFl2zkP2MxIUjIWHUTjTVqqFfq4jIkeNx6oX/0sOpM2PPlvLNJapKrtR9gUb0//z9n8SU+tmZczH3w9lHDVuFfJ+BIyaCKS5xX7j0zRhlnjDzWA5hWzKdQWxpKdPrl03yXVnJsS0CfIzsNGfwY0TMIyZabaJcs7l7zn6Q9IYMsuqy7AxzZVkKK5W+Xs/m2xQHuy4mEni5ErEXczb0Wyj5VaFb4ybGJWv2pYH+mQ0hQVQV+/8MXYTXsk8nnyMz43ajKeyyriPgF7M48RLZkjWd5XDBuwgF4tVMMl4rPNEqskZTVjDpNYdkqsk0Vx6AtUobz4utwGfTDRjI0RkG4+ViB2mm2ik+rdVNPiNBaPRWguNqSiAGCPHLcLrYafrdgwgFWsNjlATlif+r5rhooVfY8Rxw7ley5zRkgJ7kkrSxQe7NaR+e1nxLYyZkmGlmRSpkXGqMarqKhlYqUr51ODLxt+Zq9k9X2SHv2PkW75eylehhw5Xxu10MUM1usz0Ov2mNF/Pyzleu9HAZCwVfN0nVHv4hx6D+dxG9DE2IkRoqdQEIEp8fBp
 noPNsWJA
 ABU+tgPel0sEiYwvfN0WGe7xbLoVj+0QnPBrX38bC2WOESYECE+HVCWKLugy9eQiSV1yv2DzEDVEmMMLYQNDjBryiXiyP1jFnmVFhncCANn4NohNA1tGa0KKXoI3fSDlNF9a4/gSwLGzCLd9yib+enjsC7yaILymJkMXA9cHPZ3PMXt8cARM5JuyzE0ExhjpRhV3nxxMsCWnoGuRhwNgifDGdKiD1Olnf0eY+TOJwuax7sBTzTW68OBDCnY1iW7FD26q+6BDmx1/a6jXKKESDrG+nKogIqtXZAaEGQp5f/aWb5a75XaycrmSOjZ17M6KEnOpeHN1WCo1N7s2YWVs9M1HGEIeDv+uTR/kkEbjDvWCBqqf9CCJnSYxYN+vfPfPjXr1V6oAIA+JAb/NzCGOUi4I+frg3C+fO0JNC1Ssubc7vc3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

The addresses in struct pm_scan_arg are 64 bits wide.  The first thing
pagemap_scan_get_args() does with them is to cast them to unsigned
long.  On a 32-bit kernel the upper half is dropped without a word:
PAGEMAP_SCAN of 0x100001000-0x100002000 scans, and with
PM_SCAN_WP_MATCHING write-protects, 0x1000-0x2000, stores the result
at the lower half of vec, and reports success.

Return -EFAULT, as for other addresses outside of the address space.

This is probably not worth CCing stable.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7452b695fdae..762b6dbb81e4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3032,6 +3032,12 @@ static int pagemap_scan_get_args(struct pm_scan_arg *arg,
 	     arg->category_anyof_mask | arg->return_mask) & ~PM_SCAN_CATEGORIES)
 		return -EINVAL;
 
+	/* Don't cut 64-bit numbers down to addresses that happen to work. */
+	if (arg->start != (unsigned long)arg->start ||
+	    arg->end != (unsigned long)arg->end ||
+	    arg->vec != (unsigned long)arg->vec)
+		return -EFAULT;
+
 	arg->start = untagged_addr((unsigned long)arg->start);
 	arg->end = untagged_addr((unsigned long)arg->end);
 	arg->vec = untagged_addr((unsigned long)arg->vec);

-- 
2.43.0


