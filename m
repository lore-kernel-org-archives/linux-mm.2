Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A446060A3807
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VAQEqFAq
Received: by kanga.kvack.org (Postfix)
	id CA47D6B06E7; Wed, 21 Oct 2026 07:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74E46B06E8; Wed, 21 Oct 2026 07:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A926B06E9; Wed, 21 Oct 2026 07:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 522316B06E7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:48:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE4184052F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:11 +0000 (UTC)
X-FDA: 85346459982.24.15F9414
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 39C804000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAQEqFAq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5h8ao2sl0gSDsVo7bAD/bZpeGjj83T87XQIb40RcPU=;
	b=DuwSm3cTn+jPuWEf7wTzKNIshy9CNTVpznd7+47z6dlbGMdO7BCQGgAOZwDhvdyRrPf7Yf
	sOES4aZM7Sgh0Syms1ThFlS0eit4prxgyoVksxOcqTUUF5RS8jCTJ9wTSQuNlg3uepjldT
	AqILSQdJQhSMCaQUYQMCPATdcyxmOqQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAQEqFAq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583290;
	b=kvtp2hidXrWyQv93XFn9BnfFbuOablvQX1YaGIhVla6SfgxNpWZF4mwg64Q9V+GNyGx5Hg
	MKtLNvoYH/DwkvraADG5QRSWTp+6R5IqnzaByDEXXy6Z4JblZepfly/NvaG8ETbpZyT1q0
	TpASbnuHCtn8ng6zu9JDMKHtnVQJtPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88EEE4021A;
	Wed, 21 Oct 2026 11:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA461F000C6;
	Wed, 21 Oct 2026 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583289;
	bh=v5h8ao2sl0gSDsVo7bAD/bZpeGjj83T87XQIb40RcPU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VAQEqFAqztqAv3qcxYHFlzZ1jnwzQHztkQm2Ku6wB0q3Zn6zx9WSz/DftIPSC4uQW
	 UQEGhZzE8CTFEjNhoxKw6waO8eavv3OLCCMKLx1GMsRQ9ICbb+Mox0wzsrZ1867sBL
	 aruuh8VMrFgTIUoyxKK4IXRW4dLn158hDVknl84KDCH0v2DbNKnSO/snpqe1npTURl
	 GRaxsmZQIx2WoRZi/tK+3tf9KSujh1BQnvJPcZk4NjeHAeE5TaNft5yEaxTDGnru43
	 KMZoUuUMx6pEJeQlPxds41+IXvnl0aoR1n+LeH4ZuyqzqPYAlaVVAINqpFtQKt6k6I
	 FLmCIoTGX4RiQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:53 +0100
Subject: [PATCH slab/for-next 12/14] hostfs: specify SLAB_MAY_ACCOUNT for
 inode cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-12-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 39C804000B
X-Stat-Signature: qecba865agtmdyr7x11njx54gzc8sxf7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583290-374197
X-HE-Meta: U2FsdGVkX18Q7IedjW5PVG08eDiqO9GU87dPf1mu9bCOMQ6fXJiaTMWslKKQwnkJglqGZIqeXBZw0FfPQoo7Q8XblURX7Lk54SFXPrxogGNCzKQIXYtEImnVHd0OO6NsN7Mpy7s20QRBCKmy/Bhmoub80JIzjuIfAWaHco3lPER6t82rgquUTfW8wFLiwqUMtxF50f1Y/j+znNAIbnd3DTTJLcZgl5l2vSPoX0R2xQ5YLDHF9m3TdvXvvgExSsCc6oIrFjJTTm/qjsZf6chee8r24zPqpdsFjlO9/c+7U8aPj1ftQ+2jTijr7MRcuOt9Dfwr7JjTZ+a3/2MN18wVwYfX0fUHk6/d+afSb+VDrRBSfPoWF19vuHOYEozVHLZaGZNeLoujoj1LofUe4GiqMG2HNFKBJfA7/IQf3S84d+QDxHaO0RWvIjI0otP2wJ88C190tDSjr1/I+EZ3SOq7rOkvZ5+J6QUGB5aVFo6CM8avGzcxAMWTzUGfXHunHCeP38vCp4K1OQYgenRmVDKQ65yr7jLPfk7iHOASGlWy6xE90Wwx15K5Bcmj9n29Q/QsUlYWgj5REuFyw+pct6VSZLS7TfQo1hauHjgTT7t5CruvJEfHtB28lzRoF+PXsTvMryg2w9Rxpz6Gon7lkh8kqtos1v0kwbJ8icsYZGoJVeTfr0ML0kc3qFWV0p6QMjPxRjDgpnwzS8tC2hqtIi0k7IdQIP4Sz9BbtUTF190/aUmWxemPwvllmrB4aPba1zZVDzewPPSPr6oGj45ywgQYe2Utqt5w54G8y3SVBH0qyxX7l97i01JzDGy02cVIBycEOv75gICBp2OJqAAQr2sHDq6q4CSIrg66mqqt4Itb/4tylFkG9q+PHb+DWhk5AG+yZwdilAGjPRrVP+CQTfgXq6CKKlotVHnhkxWqWoVSPCfwYIszrzh9sLemTsyvPt6xRFUA8ryW7/PY2SP9Uk5
 F2GWft0i
 9cZctH3wBu4Sx3eaIwGMab+UJu8+lr7theu2nTguvbxYVJKrKVA7onvuOEfz5Y1f/yhl0PT2QceGkGveG/fFmSbDRglZd2M6ZrJb+5/0bTZ7XLQY+zf2D8ITCfTi0Npq9JlxXG/Dp4Yx02kieQltev4bgTxvTxgJGjJaAkc1uJux3HsEZlNk6bKc37b9FeFE5fhp3lxSuPP+co3ieZNxW+q6eD1vK1dhVl/wVWw/rBQ4SHgTZSBhA+gblvJu06WmiqT1uCPK6EVFxal+JoxHImVOnC0j/mmCRkRWsH9GjAUUEH3XAOuqjDdqMjNLTKV6dF/3Y91cpfVQ5oa1t9LcTOp1vMGoApZZ5N7zK3pWVEiRz0ld9xxCIxDiKtnSOZQEiBQa8Ua03eImPqXLqDZIt/4bKHUPPiUJp8rQmfmtzGty45MBKwcI/TrDFPg7xk3cMH82owEL2GrgzKI1gJmlNetFKzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hostfs inodes are allocated with GFP_KERNEL_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: lookup -> hostfs_iget() -> hostfs_alloc_inode()
  -> alloc_inode_sb(sb, hostfs_inode_cache, GFP_KERNEL_ACCOUNT)

Assisted-by: LLM
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 fs/hostfs/hostfs_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 7add056d47d8..2d55f53569ca 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -1078,7 +1078,7 @@ MODULE_ALIAS_FS("hostfs");
 
 static int __init init_hostfs(void)
 {
-	hostfs_inode_cache = KMEM_CACHE(hostfs_inode_info, 0);
+	hostfs_inode_cache = KMEM_CACHE(hostfs_inode_info, SLAB_MAY_ACCOUNT);
 	if (!hostfs_inode_cache)
 		return -ENOMEM;
 	return register_filesystem(&hostfs_type);

-- 
2.54.0


