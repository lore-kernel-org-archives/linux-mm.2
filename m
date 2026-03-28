Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B52EF10F3DEA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D13B6B0095; Sat, 28 Mar 2026 13:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281ED6B0096; Sat, 28 Mar 2026 13:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149E16B0098; Sat, 28 Mar 2026 13:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F41B96B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:01:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2D95B5E03
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:01:08 +0000 (UTC)
X-FDA: 84596087016.24.15DCFF5
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id EEEB280010
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:01:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cdrnPzkA;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774717267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bg18eS1djMVIP5KxOMkHWnTtPI0ppyIsarR2yPbY2iY=;
	b=E7a1xBU/ip1Kn7xQ5doejM0Xlr9rbJ85NSyQlAiRAe69SPe+inYlD9aFfnu9OX+ifz8ZSV
	vMqRh17pG0/aTbQ0gHMKZP+CB6kr1GRgoIzL/U15LgencGGbBPON9XMv9CX9pAMTBnWtHf
	Hu9rwPNfsas7PWFZFwTYU4ZZM+V4Zv0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cdrnPzkA;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774717267; a=rsa-sha256;
	cv=none;
	b=WgBYQZDlIv/A2X0AxQPN6CgMp0iumdqqbKdl0QsIqPjpIX4jlrzwDMfVYs557odyvZ+k2x
	8p7kaPL09vJPm3eZuO87eHGTX7K7lK3IKKX4/mQyRGsCvtBh1wC6VgU1qfNP7QoZyUDzNx
	t1erIFmWJ/4sYgz63j+blgLuajHZ++4=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-486ff3a0fc1so28668635e9.2
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774717265; x=1775322065; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bg18eS1djMVIP5KxOMkHWnTtPI0ppyIsarR2yPbY2iY=;
        b=cdrnPzkA2/+WpUD4RYU3XOkjL+2id+uk/72V0gf6rvJrZwZVddGtZLhqaHlhRBF8nn
         D720fHsox6bmZkjYx0Bk06++eyN3h6Neq+dAvuNGogZXuF3pt7dBsaQU/PKNLaNHe4+9
         9JMOUGZCzNoHMAmXk+APACxx7BFBzzwRFFf5BMldTuDwLTeBSx1SzclN+7g9PXLHSBkU
         uVGIxPtR7PBJMVjbW8CgShsxzRQgayhIRZ0nhOq1sxnBFXWOpql8PUnBhnTxgdMeJQrX
         u/TBA7d7ieHjzXnM5Y+kIygKtf1vS9yYu+rvOdwqkqv0C9AaQm9KerIhjWo64CSoYN3s
         q1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774717265; x=1775322065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bg18eS1djMVIP5KxOMkHWnTtPI0ppyIsarR2yPbY2iY=;
        b=Svn63jNQ7HA8g8+ggObqtKeGbqQShDYmMxwcBkugOWa8n7pxBgOHARu7meqwMoZErv
         dbuGoVunY87KONnkgEnEN2ZkFVfi2lIBGR8IRuEl93VpxIZkYKNTI4kCmWjfBM63bhMa
         gyhEQjKTmbg1Kgzsxf1DgA4U1FH7IG6+RpNIHLR2p3kqlOE7cpxQsHz7Zcucp/6iWHVv
         Bi1vSI0kYip3QCYr74yi48m3O850ZG6Y3Sk+ZpzDk7OmQ6Nry0aYT/lNuVeleHn+foRR
         5cWM0qx7hZpqGZ3hLu0qgDhIgEc7+1bnTVHCg8vECpzZotCzgKoE8LlGwyUvS4v7x7iw
         9s3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWA/WyqyXkT/A1RzKQ93wVM3C0bTBemWevDM3YEOG1/+Tmbaoc1np0/463gpttXDThsaGhtKa40cw==@kvack.org
X-Gm-Message-State: AOJu0YxOQN2oayuFj8JWY0Bp8+pzarVh6mdErO6UooeuTb8F1wI/1BtO
	On524eDRYV36j2qpct5k9MWjYJlk7wnYKqaloczR3mUUBSI7vuSff/bQ
X-Gm-Gg: ATEYQzxg+gbHKD1F5OnPx+nCh1pzvZitRQooRj/RvdSraJdIOZMQc6gIt1fhm6uj2hk
	P6DvN16L6QGgzzm96osghuIFWSd5jkolKjvOr3yYSfq9uljO6gTJ3OiMtyESDsIhBihwHcFSnOd
	cFSJAB0bSLK+1Zy8kLrAuihXgSpctEttymGg30EsYdP5uhnLBPcfMrRUrTFTJ8LYTUz/g8OQAxc
	tqTsMj91y3vBSjhAw9+QE/HzS8kJQDUHJ4BOPMd4Y+OUP1yML0XOMlJiqgtZ04VM7JbJz39WoW7
	9XpL2T+3Xp7WjTiFp4dUwNhW3BARl+M9Zz6XwLRIiJOZ/zZH7iKx6SEnPVpBTDbkikNy7AOm6WR
	PbRIzffKvcJyCrVOdaafV2f5YBefDytJWnn5E1q39rM04qdh0ng66rswvhzls+OVSRFOVlByMzA
	/swBNZUUnbhlL5U1XyLIxL+nlpPPfeX6g4K6V33JJyA0wAj7sAJJ5L0iIQPCPKGInPudbKGiXso
	8AEHE1T6Psw
X-Received: by 2002:a05:600c:41c4:b0:486:fc5f:1ab9 with SMTP id 5b1f17b1804b1-48727d8410cmr76271105e9.14.1774717265143;
        Sat, 28 Mar 2026 10:01:05 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4872718dfdfsm38161075e9.30.2026.03.28.10.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 10:01:04 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH 1/2] mm/userfaultfd: fix stale ops and VMA type mismatch after copy retry
Date: Sat, 28 Mar 2026 17:01:00 +0000
Message-ID: <20260328170101.184163-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EEEB280010
X-Stat-Signature: 6eu45poffjyfyqn7u9zscche8hyhpkk5
X-Rspam-User: 
X-HE-Tag: 1774717266-581610
X-HE-Meta: U2FsdGVkX1832XQqt1nuW2LOizjlPPKN3UqoSwlWfpT7ObgbwiYnF77sqoTMNnGPWskfDFkWK5QI5UWe5Qk4NOU/1xmO4cj9K6W4r+2XEC0/K//CQFh44lL+Z2pqM4rg3x1nhXhA4Epo0SbZiUwiogupSzUZNiUhBpJUMoLL6loq/xyYiTzQvUvPB76kY8TVJHoZ4M3bvL3Kuh6xc6d18L7bgYfzOilgWKyk/f7O7pEHul+BS/efUehxoNGj3/1TWvK/p1ltoDURCKBQYJxkCBVKwlwuFykWZ6IvMN4CYsdw9hT6+7MnGBuq1dLfocGjaRrq7/IYixQ62mk5B0yho3xx/yjFwdsPMbqkGMkmWV9YkfT41twrCnReDeQykTfSNoZHO8PmInYL2ipjIud64y32mE/NRi5VsWTOy7xv77YhbTz6OaScpPoHuU/8zotUdvcX78Nwn587ZlU2tc3qeToW5FHuKW0RAU0pf5OGPVhX3hnCV33ZDlKVNj5B6B4YuAhG2ekS/eZVWILh6qgrae/f7zGKKYHnFokRi7ZJLTfiGErr7Ivmyr5qz21l3TFsrsuX1osRNoc18Y3VpqMlwLfqXUgdLxkjcOW2m0fR93K6Z9LejdCRVpw+se344+o1KhTHysBlKrUoYjlrK0tRtaW7zBjaUFsoKhTNPzvGC3def9llfmQgcxmN+L4UA8lhQ55jGEX+AnqGfkKfHU/5vgnfaJcJu0H61nMfhxYyF7pMVrQniLXEEin7lkfTYU4w1AyEufGwfIg6IGq/sdiXTNUJyWQyFHn0xxHJpj5a8YHvLmML1guzgOn2f23PGJ3EcBNmtP13tEZloh1ua8GCfxDslRZAJcztZNIuOubJrKsH4w6G9hgvbAA1kByVeSR8j108RlEp/PH6JCoCuynixFFPWQuJVjmW27VeYnJoPPO/f33wQn2YoRx1xFDkc6Gf+iUMFrv/ZJMudXMsIpn
 FNqpjloB
 takpbpTMJSxwi4tB8dkqApdSSVUw430ED5cxMeUaIqKRUKbBPHEiJ7S39sXosPRemtcyyuKeKGIC64U9C9bAQ8Ca32SRZmX14aMluLKFdB+1c4HtVCsUILbMnSHdZvjTBWQJzAh997GbIAkWJC21TQZAf0wwFl6KR4dvMnPnnMvLF9zU9Ozm8X99Z3b2dEZD5/R1SUw0BV+3NXAj/tg+OiqYqGQPbBJ9B9zPN3d97L2gFCKnOf8LISgriyWtGh6YAxxZXaX575zy2t7VUPvrNg6rxcd+TENXqW4GqMnz74o3c3ztQrvPSLxnD+0QEVw028U5cuwsUDMuAd/KnmVOhJRP2XXsmf5rk0y2fHRQgPLblWeBa/EOaTj49GG3eRTmCX6TW35Aqx+1GV5ddMqsYBm5Z5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mfill_atomic_pte_copy(), ops is derived from the VMA once and passed
to __mfill_atomic_pte(). When the initial copy_from_user() fails under
pagefault_disable(), mfill_copy_folio_retry() drops all locks, performs
the copy with page faults enabled, then re-acquires locks via
mfill_get_vma(). During this window, the VMA can be replaced entirely
(e.g. munmap + mmap + UFFDIO_REGISTER by another thread), but ops is
never re-validated.

If a shared shmem VMA is replaced by an anonymous VMA, the stale
shmem_uffd_ops->filemap_add calls shmem_mfill_filemap_add() with an
anonymous VMA, causing a NULL pointer dereference at file_inode(vma->
vm_file) since vm_file is NULL for anonymous mappings.

The mmap_changing guard does not fully prevent this because
userfaultfd_unmap_prep() only increments mmap_changing when
UFFD_FEATURE_EVENT_UNMAP is enabled, which is optional. Without it,
munmap proceeds without any signal to the retry path.

The copy_from_user() in the retry runs with page faults enabled and can
block on slow backing stores (FUSE, NFS), significantly widening the
race window.

Fix this by:
 - Validating that the VMA's userfaultfd context matches state->ctx in
   mfill_get_vma() to detect cross-context VMA replacement.
 - Re-checking that vma_uffd_ops() still matches the frozen ops after
   the retry, and that the VMA is still VM_SHARED when ops expects it
   to be, returning -EAGAIN otherwise.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/userfaultfd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb4442..2a6e034b15aa 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -225,8 +225,9 @@ static int mfill_get_vma(struct mfill_state *state)
 	 */
 	down_read(&ctx->map_changing_lock);
 	state->vma = dst_vma;
+
 	err = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (dst_vma->vm_userfaultfd_ctx.ctx != ctx || atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
 
 	err = -EINVAL;
@@ -498,6 +499,12 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 			ret = mfill_copy_folio_retry(state, folio);
 			if (ret)
 				goto err_folio_put;
+			if (vma_uffd_ops(state->vma) != ops ||
+			    (ops != &anon_uffd_ops &&
+			    !(state->vma->vm_flags & VM_SHARED))) {
+				ret = -EAGAIN;
+				goto err_folio_put;
+			}
 		}
 	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
 		clear_user_highpage(&folio->page, state->dst_addr);
-- 
2.53.0


