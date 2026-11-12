Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B284606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HM4HKwBw
Received: by kanga.kvack.org (Postfix)
	id 66D436B05F5; Thu, 12 Nov 2026 17:09:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E206B05F7; Thu, 12 Nov 2026 17:09:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5340B6B05F8; Thu, 12 Nov 2026 17:09:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 283BF6B05F5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9984BA0207
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:36 +0000 (UTC)
X-FDA: 85427859552.30.10B3417
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC01580006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HM4HKwBw;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Viwqy3ITQgBszpOy2nxIavh5Mt0ao4kMQc4DSQeToGo=;
	b=Jp9E9cLoXf65EFZb3itLoHwOPSzoeKyY8dyFFATLpx3LHVRP0fPsMhmC8IgY2cC/2mIpK9
	ML8EIE2OjWHMyggfl7aSpZyNiSX/zDLEnok2a2UkFais8JwEGWKtryu0WlXIpoqnlNskdb
	2OtaLJjSoQVTBHci17LoTP+wkdm+oE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521375;
	b=45ScIcDjawaWWm0czDUQt2sMyYi9AQPfa50hnaDFlZtFFMruZmwErpXKH3G8dOLhgSyuFO
	7GzD8H6GKltA6bAOkmc5sXb9dJwYnAkUtPnF9zMUIQO2qpNXQtkcKzEgX5gW7msdp7c11Q
	X/I/0zgxSl8gMrOxcUXPjjcfcqG8PYI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HM4HKwBw;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 751506248D;
	Thu, 12 Nov 2026 22:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555C61F000D4;
	Thu, 12 Nov 2026 22:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521374;
	bh=Viwqy3ITQgBszpOy2nxIavh5Mt0ao4kMQc4DSQeToGo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HM4HKwBwenX5LPu3liCUHEMsEalytKn7ys2DDGNSBAMroq/1dFf/rVUIYBjFEHEpI
	 hE/fY4rJBXGrrTOlj+FZDCzgZ/BtsewXoNR8UtSzaKL3UkvJ1GnU2uIWtxs8CtmBBW
	 0qUUCKuerr+2hwfE4QZ3r9yCnSLDgkteS96rugzAyzmanEYhnXcnUEsXjy0yK3Id9c
	 1d7fVZqky1H5uWLL9Z3pHvNpyENJfo+QwEDcpD3mU4gm8mDkSdZS36INIPyHwx5f4d
	 gwGCNlnn5K6jpoD06i27gE2QSn1Iab7gBi1sgmvAemRpMKmkZuQiuX4NtlNV7WUC/I
	 p0yh9C0dDrLeg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:08:59 +0100
Subject: [PATCH 3/5] drm/i915/selftests: request read access for mmap
 access tests
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-access_shite-v1-3-988a5c470db2@kernel.org>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
In-Reply-To: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Willy Tarreau <w@1wt.eu>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>, 
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1199; i=david@kernel.org;
 h=from:subject:message-id; bh=UNHRKTPPJVrGYq3JL2OOfSiN8BE6XDeP4WdpR0zw48w=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+WfzXfSMdyle0+taS0KYbrY+ZzNvWegtJcp07d9F1o
 8y9imPFHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkkzEjw1dWKyPrzb+96jf5
 r53V6B4zxaXk36Gv5ozRBdwzOZ5LsDMyfDYz6l6worxt7dyFeduun10lZLpV2HND/cMu4aMaMY/
 7uAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC01580006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3o6gg1qy9zp81tugtky981ptu465c5u7
X-Rspam-User: 
X-HE-Tag: 1794521374-655459
X-HE-Meta: U2FsdGVkX1/Nz7bXePlhGt8ZnYmTNUzDl21yx06ifCbUsdyyDZqlYKL0KepyIAU+lnW+9RDopbSYEnSVAURk0FST5iDjFekTWYlPu4bLeFl93XnZVIeleQbJaqCsJeSbPKrSliC6CKDfTUQqE9Ur34D8dNsKYHMU2rhWdGPKevDRli76gOc97T/Bcoo/zLnfBiEq3FtcVpWzKU/Cx80azjCDmrlueVjpBa+zIG9KgTxi2UQoJe9KNPzxh/YVRPhqbPADDypm6ovnXsdgsI1UQNM4x2mkEakX4wfUJOCHi9wpcZNVMkbyTIyHD6n5JeautGWAVYmolRDgRJNqblGrUqGZwe6smtO2IGdw9vh810Rh96O22kjGgtAkBPApnb7vj+v2FR9Mi4wYItNfulldu/QGAMtNuIsvx7qfzq1EkN23goVIr0KoYMZvRWJxAFQic1aePCBiig69wAMowv1Xrtj9JsRvCnmkVDGtTWezpMqJ2At6e7Gr2symg8hH9KCVn/ArppHndV0VQ4xiQS0V7Qo4OytE3e4YThn3cxf62nYD+3Vfw58lt+3X1sHD/i3OuGLNnFxfFUNinWYpNn4COM+5Hajl3dPtYxHE8GVSVrM/CteypohSwdUsVmk3P3pl3H+Cr+AwtSuSmqT7ZE969/tB8fg6hb9KJIrAl5S/sVLZeBqZYvyHzngrqZcY68NIIqsGq2deFcOgwqfw2A6QS5UEcSC7+ZUw+kmxbTr715P3xIeZBSFppNU0PvyJomVxzKOy8kHZLn50B//G60k7krJJkeXeQQNZeCjbsN7tTiwuDh4UK5iMdHwkp3Y8vWghFtSgosJeJk+jTM/ZE90Lh9FCL8nBNJvNkKVOZcDGOpmrc5D+nUoktaDgAa2ChvCHcpjmZDfu4XnPjMcdAl9j4M0V+x1z7pi/uPQsX+xvr6XTL3xN5yPAjkrWEyT9t4XZguz9YCKZSB5srMh8uOC
 HwaMclEY
 1++8Bi7CkXd10lHP+1E1+5WdakqWTZlxU3SR+YEH3O9xpDrf71CI2tMuFT8HG2JR+B0d4F8FhK5cVekb0l6qxT8VUJc/H2ENFjGOrR9dFkkot/kvpP1fq8EFjihxniFEeRUgYm6I9Uhl7W05MhHGZXNP518p33IIGTNhqxZz7e8+jvBImqWj8k3v8uQHJS+66G4Z3alvp1B0pyDKtcjxaOYXJOPqDDw0rJreMIIiAmelhvGpIMkS8N5BP5BhjgzYMaPcPu1sHusZgSX+kswtgszUKxgB+JQ1uMcGxCtQtQDDfR4t4Rt6PS49Rsoh8gTYqmcrU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__igt_mmap_access() reads the buffer with access_process_vm() without
FOLL_FORCE, but creates the mapping with only PROT_WRITE. Request
PROT_READ as well so the test remains valid when we fix the ->access
fallback to properly check VMA access permissions.

Fixes: 9f909e215fea ("drm/i915: Implement vm_ops->access for gdb access into mmaps")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
index 303be698891fd..d9c828032a1aa 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -1460,7 +1460,8 @@ static int __igt_mmap_access(struct drm_i915_private *i915,
 	if (err)
 		return err;
 
-	addr = igt_mmap_offset(i915, offset, obj->base.size, PROT_WRITE, MAP_SHARED);
+	addr = igt_mmap_offset(i915, offset, obj->base.size,
+			       PROT_READ | PROT_WRITE, MAP_SHARED);
 	if (IS_ERR_VALUE(addr))
 		return addr;
 	ptr = (unsigned long __user *)addr;

-- 
2.43.0


