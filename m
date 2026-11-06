Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D06606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rIL05bAp
Received: by kanga.kvack.org (Postfix)
	id 894F66B05C0; Fri,  6 Nov 2026 08:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844B46B05C1; Fri,  6 Nov 2026 08:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781D66B05C2; Fri,  6 Nov 2026 08:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8106B05C0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:20:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02C69A0D11
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:24 +0000 (UTC)
X-FDA: 85404753210.22.116D386
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1F28980007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIL05bAp;
	spf=pass (imf30.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5STX0i0nZe9qBiCwKpYPE22fAldGg2mVbLAiRStB5A=;
	b=or0AQIOR3LZuzfaJMPvaJKdZZ7xrKf4RMQDDbgi4i886QIYz0k105N2CRH1CbilodFo868
	6vXYY24bYja1Q0pae+Uq1nGenR4tCp3I6R87v5A2nZjJIm9NbT8jpw6drB8U+fBGjnsF3E
	AhjxN31Yk7LRfkNRVdBQ3prttiKVx18=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971223;
	b=23WtmwdFTJDBgC2ADQatNAf4POSLRdHE5T+kbUPkhluKWwsNsRg0bvYf7rjdobb7afyWPJ
	4oBrnYIZmEgJpKJVDJNlA6ttZRm6ddAlW1QDquKaO25Res8Ea1t0u/HuCMFIRaDwySi0OF
	R5FA4zpWeXfIigevqc5bqaREAHgG+8E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIL05bAp;
	spf=pass (imf30.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lnwy3IIIUITEEW39wV2rv1u7rm4YP9o1MSolIsKb45g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971221; v=1; x=1794576021;
 b=rIL05bApbBDzOPWzbbU8YuxO7nQzlRV10FOkiPXXtG+Vy2ZGnjEWnAq12IsnzslYTzIRVk5B
 h/tgqwtkZSdnpTFJvl7bkqNLG0+Xrsm31XkQW14CwE2VrR+NWIE2mfShF1ULKWPQ6cWhJVWD0OW
 /OoTZqkomwb3ocSMx2DXmZwo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 42ebb214afb95bc7;
	Fri, 06 Nov 2026 13:20:17 +0000
X-Mizu-Trace-ID: 42ebb214afb95bc7
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org,
	dgilbert@interlog.com,
	mkp@kernel.org,
	loberman@redhat.com,
	jmeneghi@redhat.com,
	kraxel@redhat.com,
	vivek.kasireddy@intel.com,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	rostedt@goodmis.org,
	vdonnefort@google.com,
	mhiramat@kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	axboe@kernel.dk
Cc: linux-mm@kvack.org,
	James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	phasta@kernel.org,
	joro@8bytes.org,
	will@kernel.org,
	linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com,
	mason@kernel.org,
	aesteve@redhat.com,
	tjmercier@google.com,
	harry@kernel.org,
	vbabka@suse.cz,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 5/7] iommufd: account the hw_queue page array to memcg
Date: Fri,  6 Nov 2026 21:18:27 +0800
Message-ID: <20261106131829.3228926-6-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106131829.3228926-1-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: qi9onsn8rnkpjidqoh8se549jbtyjmpo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1F28980007
X-Rspam-User: 
X-HE-Tag: 1793971222-742684
X-HE-Meta: U2FsdGVkX18Xo8BGvXc3RloAWKZ6DqXmx/NsT7G4RFbI/S/wmPEqypNIWa1EVjPHNr9920jscvDGtBGNFGSvVCJWYd5E9xtJqfeoYYVJHz8/5va3WxZUdP2HyfoFYXIzimRK0NaF2qiGqspek+oEQ2Jwr15o6jVMMkuAjUiQCP+zbb6EgQ+9fCXA8thTRNIcn9aPUo2gaIimzm3V9iiURnbtrZpsx+kxG6zBcBfQcPmNPtHGz/sJ7SwLujC8bfaVswbqnKbUiibkkkXHIeRriehAnlD+qx9zEzybF39ZZ3PuSxkL5UGkpZn75ksoPUPVT4r42J0nAQ9CMqadalU9BgOjF7H1nvwTGxiYMHboGF5Cc45IYsCTI96T9FuTbwIaqq6t6KIoKlex9SJL6emltSQfi+16XOleBngc5uP+4ivI9lByKqSMhiUubRhm/BhFSPYsynD6henQzHnh2WQjeVQkype9hQ0urXPO9VuOWKcpRC/ERNLZy2dHa6eakNF1t0LLmQyUsWwxsuB5mB1BEst6sLweRFR0nyVpF4OSAP/VeHLd58uji5laJtkvlSw6GCtDmRZBZIjfvFFj7d1tzUeYKHdlijcblUzfeohuEObBSfp7WBw4y96yWoja99WGavHQmEYljbaFaWCbCSLAVBjNlhazNwequ1JX66YKOld9x1ePujfWYuAMhrVy3sAy62BKF8GSu35/nkeXXkJnGeMbtLkcG71akbDVU96MajWgdDX6kKeviUE2+pAy0fe+WtL71Ha4To/hXn3gd6g/XKk7ln2wSq2lTRwFEoD3mlQtqPwfUB8pdCc0G2pLCDs3wyuK7I0m1OvTwiJnAH5ggZFqqdvhryYd+ATr8fjf/EGhBJJakmyHVgB6k1ThlDAyv6V6ySvpzSVKPB9ID2XADgr8bFsZ+qx6wx2Wo6F1u1svuPDyxqoP+X724a5IwG1b9+M4ep8N3Sb4gj9tSRC
 JiEDmYU8
 OboYdfdbrwqxbIi1eNnwkPyU+XnwBHjhFR5k5zXctmfxeujAZikqXu7eY1JG6qmetyqYntGHwnjnp99hYUzpDQsn0b2tMHBxvJlcljk18c/eadBZgEM32lAGZqTAZLUsWuIqE9uj66K3RYrsqq+nI5HQ9qjEcmZrNtRAB4a1eJRqeuI1pgNuGz/teMIULmXUy6w1zDFsIr7kZ1cUSVpfojumhnJHGKPhaalbVzrgLEaS/ad2tDNtaxIKscg42x65mDIKjhWUGtAGiWNLkwBuZlbfGQbU33qQjVf38ZB4fHUlFuyJjpvITjbyrhgUhDDmU9sVB5Q9MOVBYCMtdthx4tYMBgBc7sPgOBRMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

IOMMUFD_CMD_HW_QUEUE_ALLOC pins up to max_npages pages just to check
that a user supplied queue region is physically contiguous, and the
page array for that check is plain GFP_KERNEL.  The size comes from
cmd->length, a u64 that is only overflow checked, and the array is
freed again as soon as the contiguity check fails, so the allocation
can be repeated concurrently: a 1GB region costs about 2MB of
uncharged memory per attempt.

Every other iommufd allocation that scales with user input is already
charged, and the pinned pages charge the mapper at map time.  Charge
this array like the rest.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/iommu/iommufd/viommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index f7951057a1e5..ab17e190da49 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -330,7 +330,8 @@ iommufd_hw_queue_alloc_phys(struct iommu_hw_queue_alloc *cmd,
 	 * Use kvcalloc() to avoid memory fragmentation for a large page array.
 	 * Set __GFP_NOWARN to avoid syzkaller blowups
 	 */
-	pages = kvzalloc_objs(*pages, max_npages, GFP_KERNEL | __GFP_NOWARN);
+	pages = kvzalloc_objs(*pages, max_npages,
+			      GFP_KERNEL | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0


