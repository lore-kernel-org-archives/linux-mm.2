Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74660606A339
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNeqyRn/
Received: by kanga.kvack.org (Postfix)
	id 7E5A56B05B4; Wed,  4 Nov 2026 11:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796586B05B5; Wed,  4 Nov 2026 11:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC9C6B05B6; Wed,  4 Nov 2026 11:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E83F6B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B87AAC0777
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:10:08 +0000 (UTC)
X-FDA: 85397923296.10.5B5C8F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19992100003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:10:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RNeqyRn/";
	spf=pass (imf14.hostedemail.com: domain of blum@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=blum@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793808607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RtmPL253ch29gIpiVq0xncUfpACHZ/Al//0T+QvAtTE=;
	b=RMiWBnDEPhvEmqr9uWWoXwBuHUm5qj6PeODEPw/nZhrtdAtoYYnzCu9iMb5d/DTDiOt9DV
	Uvp5zyXA1ieIBSf5RQ8GzjXUPzH1Ha6/HSMJ1Swqk1IbVzuxE2rkifNQxBaLD012o0ANX8
	1HuUPhcZ0E0MGcu8Gf0lGuMtdqmkBMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793808607;
	b=nt7cLFavFdRb+qOhPWkTznI6NWYjJ8OQqeH5j2lFcRSNB7SlM+mdjD6EQwMqn6Rp3Vt7o1
	S0yDKFXG5OzQLu+e/QvE3glGH0dd6uGX5xUFKsiXRATyqUEn9f8QzMWgfa86CHwp6qJX5S
	oOiy7QyqCHRSH09hxfXFrqW7pOsok2g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RNeqyRn/";
	spf=pass (imf14.hostedemail.com: domain of blum@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=blum@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 414F440408;
	Wed,  4 Nov 2026 16:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E891F000C1;
	Wed,  4 Nov 2026 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793808606;
	bh=RtmPL253ch29gIpiVq0xncUfpACHZ/Al//0T+QvAtTE=;
	h=From:To:Cc:Subject:Date;
	b=RNeqyRn/+CAKNyHK1ZSpb5UjExecLIqj3fBVcdwXtDgwP3GD3K2oWn9O+BeR5f6iD
	 gGZm0g+KRIh1bAYuxnGOY7dka/dJSJwhjHuLo9AtAgtUQMB8+JzJC/vXfdcOgOXuV+
	 x8rM7hwQAAPtS3Uv3aDUO9tJqeRowSRCB3FUkfNs0xD75nb4gGYpepZQNYn0zO3/d6
	 cYqZOLjDi+J678FAqiQvZBY4gsD3kJYIPF3KVVYyO47J/cnVNVnWubmTePH9VfHsSA
	 COZG0AyNSJPa2/0DqmiVIPjBAKoInx1W+CZp2A9+plaaoM0ihnyQFKVr+eqDitlc2/
	 CzBSbSvni9abg==
From: Thorsten Blum <blum@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Changyuan Lyu <changyuanl@google.com>
Cc: Thorsten Blum <blum@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: Remove redundant 0x prefixes
Date: Wed,  4 Nov 2026 17:09:33 +0100
Message-ID: <20261104160931.137174-3-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1112; i=blum@kernel.org; h=from:subject; bh=oE3Ypxncsp4Y/KarKJNB8OKsSEs9/QmS2hxHg/unzIs=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmvI3Zv1fppN+UXC/sW4+cuEwVuZ0kEFzycNW2lWOsqu 0Pbsz/d7ShlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJ9Lcw/GJerqB35l+QfSSr Wdwh7sD/8+cff3DT9HjaTcHL/yb9XnCckWHGcjeJtu83zJ+v0VZM1luzUJ5/3gkGga5Y+xarnes ZRHkA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zj5ziy9byguji6sw3u6ziuir4hg43hy8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 19992100003
X-Rspam-User: 
X-HE-Tag: 1793808606-883192
X-HE-Meta: U2FsdGVkX19PiE2FCo11NcVnhrIZNNLPLXGX6Ax4OKmwyZfMZY2UWak3bURWl4MIGDE4BB+dXzNCQ4nP6eBrF5FQ5WHOok8of9ABDx0Y49tBY5dIT8k+wgfNmL+LyxEXE+9KOAcanEVVBalwjoBNm13YkcF1jqHyQgNsweaGWUQanUUlYR8VP+KHj0K0zyUha+f+iWvpALwHrZsXOI+SciF6oCnTLTKUmbm0CnF8jX06pwOzOqrOdGeef/KDqtXforKcyJzAEHi5rQrwyKMAPDul5Nu9NqCcI1fCQw5Rp4QZJe0AzXWrdkQbMTTda6lj8+uv/e62wx951kqldsyCT6vEHAtp38Jcm0hxF0/xGfrSzy6HPlzvRqgCgiuwDG8OBBtYgtqqyBt9JV5DNNAmDEqjO4Kgsi8so1F1RrdQ3bXG3mIAy2YVzLplmYh46adsuQuGCwhHk2fHh0UapQGnGVf/Bdg+1jdH08WoLXfJmmAMdeYGbGWEAHvtLG5qY4b1/b/qfWYwvNBEJ3rZ7rXs0jA6V9Aerb5dukFQZi/pSzQWeYBQ44TnorM0yZ7XZOEbhhbJZWwYpLhf0+wwSiBEduE2asFyzUctyem6DkLJsMhTNlrIN72t/1T0Fb6Z7Ihexwalkn/wl8y+c/XbfDWOA/S37+bNZ5Ed/DKXY/OaaL3ryeGB11l2Dm8m8vIfdoufICjgmnl5HjJqa+UpzjBJSVH6sasXTk2HFcH4CcBbA4r95P6ozch7wy+a6R6/FG9F4KfIVR5oyAHMhAnrnlz6o4zm/jB/4EPPmo1SGKC4vNbfoIkptqYNV3fs6/EABq6zCUHezlgD8XAVccPYttfVqGLI8XkYpVxzvC4CJWAi4FLSnBNrdGqvDeFM6HqREw1xwWyx4H7iGeLeRVxCcBLTzDMglF/zr1qlezWaflJMW+yo/Z1Ml2pc2QsFW9Ve1/xfisY7Kt2vs0nTDCe3D6k
 2ezyd5+R
 mmv4RU35IFLXF29yYQO1uq7Sgi7RCwpqsvP/MpMFsZXPz/v5T0XOEjk+1T6DBino0FUqGFvs/OcwaN5nTuGGmUe+WlwIZR4ce4vWLrm7doC3OkVwsqQcAq4Bhket/a3DqOi1YMqS07O5ldeQ+eYSb76BPKofe9zChElNQqvML3smg3VhNNer/0HcbaFJiErjs2KTvnga9E2qZOI4bebYZ3cyMR1JPhODtyZpcbSz1p/IfKLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The %pa format specifier already includes the 0x prefix. Remove the
redundant prefixes to avoid printing 0x0x.

Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..5f828eb44f75 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -2015,11 +2015,11 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_noprsrv(area->addr, size);
 		if (err) {
-			pr_warn("failed to mark the bootmem region 0x%pa+0x%pa: %pe",
+			pr_warn("failed to mark the bootmem region %pa+%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
 			goto unmap_bootmem;
 		}
-		pr_debug("Marked 0x%pa+0x%pa as bootmem", &area->addr, &size);
+		pr_debug("Marked %pa+%pa as bootmem", &area->addr, &size);
 	}
 
 	memblock_reserve(bootmem_phys, bootmem_len);

