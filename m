Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0577D606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z6Jehsii
Received: by kanga.kvack.org (Postfix)
	id 1B8506B05BC; Tue, 10 Nov 2026 19:24:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1695A6B05BE; Tue, 10 Nov 2026 19:24:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E893D6B05BF; Tue, 10 Nov 2026 19:24:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFEAF6B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E0E8A761A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:23 +0000 (UTC)
X-FDA: 85420941606.07.9225189
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69AFA140008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z6Jehsii;
	spf=pass (imf26.hostedemail.com: domain of 3tLXzaggKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3tLXzaggKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDGpajhrmdSjBCrv+9z48USF9DLlcre7dauJ37omj8M=;
	b=4WNPiehuu3r81mLU+sAxIuqUA5QO9FZwPriKhtp7HuYpSpPjX46sPQGEhAkb3zwZde1Pm0
	xxk3hhZKUoWTo8cGum2MFxUpESJB2KrhC6IMo5dsjy1FFGHStZqmWR/ILYeRLkgPzAU4GE
	omK5FWsc5KArPX8iOywSSk4mTUtAFj4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356661;
	b=3CjUvY7HQRdD/nT25QULSI4FuG+8MlALDa9WeT3h7c4bdFq+hyRITX5JPsxAwQo573P4J9
	0v+rIwp2Q0iuqvFDp9+4fTGRIzZXZGg3t7C+8tkUIBUq0uBVR5UhXylPvh6dUeUMw1dBpq
	wla4JXO+7swEowxTqmyMQmmNwbXnWs8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z6Jehsii;
	spf=pass (imf26.hostedemail.com: domain of 3tLXzaggKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3tLXzaggKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-823d73ffca1so3159650a34.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356660; x=1794961460; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oDGpajhrmdSjBCrv+9z48USF9DLlcre7dauJ37omj8M=;
        b=Z6JehsiiYpOEHwKhgKlaoRphqVratW558oLGqNvdO9+fOwERg76BxP/EKNDT9srwig
         hJxsb/0sDWY5AVS0KR/xYWLsZy4U9V92zRMSWPt4Zw/6yDWOQygbXqJOvWfjgKq5DIXo
         jZEgz5sw5pQItQQaHNF7Hl4LM7UllEK/OEhf6hItxz+MOo+q/48tDftHfPW7mFzkbmgP
         p1eFHU66S0RD/feZTeH+zB4zp9N8DK+oNA/2aLrUI7Fo8bvLV/nksWsjgPvFBQKCOb4c
         Z8YukkMTEnv/oerNDyUoMpTs1YnFVCfxATKWWWFlLXEDqs8wuzYxOdGUhepvhf1rEESz
         tReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356660; x=1794961460;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oDGpajhrmdSjBCrv+9z48USF9DLlcre7dauJ37omj8M=;
        b=v67pnvG9ol67lPY9Ixi2wxcZaDFMVHxsh7izDF+YfMy4tNYsPu/3CkM/6y31uWbxmL
         jixbcLqRg68HcopCVY5bjirhRhVIoKHAJs0pQ1QUIkLwa+KHCSi/dPSdv4quCBxxTn9j
         E6aDRHBH0OM7Op8t4hn/DoONayVMB3GkZL786JlCfpfcUI0gtaIkkJ1jkRM+XGKQ8FPR
         bm7mgcJm5ftfSMN6p5lPbfVcCqE8LfCbrKVuF71Aax5O/LFN1XMBi53ptCw558aw+qSv
         uHbH8CkblhRcafG25SYb9uHrvqgaFMtcNi0PqDROHNtuHyZS0JSQl1uYNqmaWoN+2oHB
         Vb8w==
X-Forwarded-Encrypted: i=1; AL+hErGjiylGsrkP9NrKd3sYRtffThxfCPG6YacBb4Nnr0xJWG8YAzBqcrmtgt0fv5FrYDTMzI8rsZGfNg==@kvack.org
X-Gm-Message-State: APuU4Z8VznB5VZNFfa4X1E8uJ9F+QOuf2qTkkIwZoDaK4fgcai0RLEPo
	pf8/Znldbqvg++Mar+Nk1sHLvGBFRLSxulD6Jcf9N3dpRJX61VxS3VePehPuWX6dPIGqxc4bPeW
	sC3xCsDZ3bJtIGw==
X-Received: from iobgl21.prod.google.com ([2002:a05:6602:4f15:b0:9c7:70d7:1521])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1581:b0:4f3:e98f:fa26 with SMTP id 5614622812f47-56b98727e41mr556110b6e.58.1794356660168;
 Tue, 10 Nov 2026 16:24:20 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:48 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-11-dmatlack@google.com>
Subject: [PATCH v4 10/19] mm/shmem_luo: Don't make early retrieve failures permanent
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bcwzzhsi5q8onakz5xuebietzss6ts4d
X-Rspamd-Queue-Id: 69AFA140008
X-Rspam-User: 
X-HE-Tag: 1794356661-238992
X-HE-Meta: U2FsdGVkX19CxLdram/1QuEudX3kGTpG3AE9C4CdI27qUWhB+m3UVNo8QVO6FaN8jnl9619hpMjDiKEkwJqKSFPtrD/I2IzAddbzGF41gSXguUkqErMvjmzqU0mAYl4fQeCn+P9g25DpMTQxeM111KsnZyefqv0vahRlSKrz04jWPYS8bUBhBhPgvN/RAjFUDLy2LeP6+POkq8BPFqbQBUTMA771y7VZN0ItXYU7hZHdYscuBgoSXvwUdsKMoTRezR+MT+COImjWKjyARr6qwPeRbSTl9WP+lVVsJkzqRUP3syyRMh4JSFB7WiQ92aF304f2NpY11rSXBmdmdbdTQOAtc3N2yYBiDd+1/dUdU3GFGBeX0JW597ZFyp9Um7AMR3uiIPBRRbcW+brp1UbQ4txvhi4s1VEGvz1rLcvd9UJ4BJL7moMTQwDbTXNfaEpENGUfMU4kzNjNXEWqudh7Oids36UZCKhuwo+mLJsxVeXA48kUQ1r8xBXv1TmFwDxalMwO8YXoeXmU3fAHEPIeO91llojsqw0LuO6fkx43MvM3nkcWfunAf2nmaHksBjmomzjs4A40d8ZuMh0MC/8G+rRIYkP9QP1tmsiaCRECoDrfCbVuF/hZi981wuYK3j8OgJc0z/0rEfLYoJe41dAtAj7O4Vkfb7kwHKkD35TJAx2xMGESuFWYOY7J9YNRWLQvigaE5iAKjA24AjJ8AAoVkDjTYxvFjQEOgEpAtsWLBrwiLPiZndgSjDwpq+xnNKWk5/fQdint9YVwBGCp+CXglRn8i892f2fGAfME+0R5wKvzeHNT7COGNA9xgB+wwiq1L0y0+gBt3Yz7v2pTWviHyM9p06etlPnkm6xrcajKSmTPNUST4xJ4fwprCXbJVeVGgdvxTP5n+DJ0eLcLWGkWh8UXA6LROZc6Sso4iQ8UQ+E0Uat5MjPw8bQmppkJDzltGeg6arndSGU6Wqok9k6
 AXAVp/OO
 /vp6CjP73N8JCnewomuq5mQhhpRliA37f9GryjGDh1zwi3+jHq82QmPftBJTNYhj1OItksrxWK0rusOU2WVVDkTwDAm7jMuW9R1fHdhNw5C2v6vQBYyM4+uNlr1NuDEmFrBsvIuN5foUtHqcreDmUVg1mi63lAeFCpNbBbyXsiB9IaCLQrvBpxKHp0MU76LTXiboupHyA89BV3YPPovNIkZcQE/QgzRCPDhOa8Ks+u3LBOfSHTyVa3okGOTxByj3tTtiXTNW0awPNEBJCrVeTG/OdxO74CTWrmej2JNU+qe5bNdK5NGEp4mKcJFRIMZY4ExSpiIGeOjPGHt0MAxohgBWP+aXgv4Ba48EPNb7CXF13lAE29gv/Ea1lDwnuiiuyu6Y0ZTuuh4DBJ/gvdz/Cc/NE+Oq4F6wut5YLY6Cq7xJzRCUp427btH5lwBCJgo9SAe9aMHQQIvR1y+MhBV3fxpQfyCmwM+MbDYc5k0YZBOrk5lAMPJKtKGJ3N2NnzFJ9OIFP5HvXo+T1tZzhutjbnpZmDNwvMC1EQsXom5IBhJSId9srjrUXP6MwkwypRst/fwSnUQntXup/Yk+39DT7/L2dR4MfXYcQH2jkZJ8w3tPDGw3su/2YNrRys607fdoNNwCK/2kjtdlRDp2i8sNFKByWUyKZIKlSQvuK0HFYjU1U45JhYqIJXwJg8NERwpak8mX1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mark failures in shmem_luo_retrieve() before it starts restoring the
folios as retryable. If no retrieve succeeds, finish() frees the
preserved state, like it does for a file that was never retrieved.

Until the folios are restored, nothing has consumed the preserved state.
Leave it for another retrieve, which may succeed, e.g. if
memfd_alloc_file() failed with -ENOMEM.

The exception is a preserved file that this kernel can't restore, e.g.
because it has seals that this kernel doesn't support. Retrying can't
help, so keep that failure permanent, so that every later retrieve
returns the same error.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/shmem_luo.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index b48d7f460493..dc6ede528822 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -552,6 +552,14 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
 		return -EOPNOTSUPP;
 
+	/*
+	 * Nothing consumes the preserved state until the folios are restored
+	 * below. If the retrieve fails before that, leave the state for another
+	 * retrieve, or for finish() to free. The checks above can't succeed on
+	 * a retry, so they fail permanently.
+	 */
+	args->retryable = true;
+
 	/*
 	 * The seals are preserved. Allow sealing here so they can be added
 	 * later.
@@ -571,6 +579,9 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
+	/* The preserved state is consumed from here on. */
+	args->retryable = false;
+
 	err = shmem_luo_restore_folios(file, ser);
 	if (err)
 		goto put_file;
-- 
2.56.0.542.g3ef89b7020-goog


