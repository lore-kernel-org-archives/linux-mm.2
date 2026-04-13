Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4673FF34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858C36B0088; Mon, 13 Apr 2026 12:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830686B008A; Mon, 13 Apr 2026 12:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DE66B0092; Mon, 13 Apr 2026 12:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 698166B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:51:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 122A6139D25
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:51:01 +0000 (UTC)
X-FDA: 84654122322.24.6FA17F8
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E330120011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:50:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVJX2HlG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776099059; a=rsa-sha256;
	cv=none;
	b=yvI+B70kAGVAJ4kJEdH1DwzZ4aKpARpUbtByXpxZFxTqmh7Av32PcN88S+DGcoz6d9viyk
	7b7hoTtxmBVbRCvO+bvT1/splr+YC+ZOinFXhazn1Ju0owbJG4mi6t7C2900OORqX2YN9E
	hup2N1EcNaH4AcL6VNyiw5SioqVtPE8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVJX2HlG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776099059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+BLLR3j874rB7kfCtfS4+8D+5ngQlGoYnpCAW4pZzFA=;
	b=oD13HicngniI1g8OWQDJP21kVtC03BYEAhy7iwkEsjOWn8j0fWOco7YonWZrSnXGA0m/iw
	VXcrLASA4p5Q40+nzkLxHDky0Ym6LBH+T6agb0Xifym/W4jDgUZ5t4xwdYmgFI+XSp5Y/D
	4jtCDtAaWpTSPU88cpiCVMm6W/0DXqE=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b467d03d57so501195ad.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776099058; x=1776703858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+BLLR3j874rB7kfCtfS4+8D+5ngQlGoYnpCAW4pZzFA=;
        b=IVJX2HlGZWskwr4BmiOYquZTCRRYdctGAwnUN4iHcP9mWmOCLpl/KRJTox8HRaz0Cw
         l5muYm6NT/4Wdb1wfDLilqDxb4B66eveOki4O2oCK/Sr0f1NmJAmUs82+8lcsqDzGGMG
         j7YSTnCMiZHnJSz18/yUCzYGxS3Vd/qTL1clqnozOJiRUgeAppEzIFFOuciB0kExI9Nr
         E3RxsQ2M0BDagBnD1uBgly11jWtVoP7zub4crYsO4tLM6lKgj4IoAd+0iWgONH0zFLg2
         JCsy4GXUQYchl/ujz8+7nyBr0aq02DixplpgzgZMwbC1UkUqj0480wOzNc0GMrwUJGX3
         kl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776099058; x=1776703858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BLLR3j874rB7kfCtfS4+8D+5ngQlGoYnpCAW4pZzFA=;
        b=o4l542USihTAN+lwSQr0Lwinkuo0qw3ME+ssjYuWIYXu+pjS4mrlKLfsYAFdNWOKwB
         NfFB77RAokeTwfn9OMLP19F6dBB0Mtv7dtFjKCecDZf5+hMxPRFjRSTGR3lB1ZLgUs+s
         R63csL6bCH+Ru4icgcUeIIuHbK7KiEFOJo2fGqWy/yD314NmOed7z5gH+r7Jv7DZydPd
         9Z+4VTckq7001FYavmVED1tx5tSRGvJEs64fQo4bGwroOgV0zofY6oe0caIaFEXlQNlM
         H63DuEsDPVzbasHI8JGXWVazUBDBa64oNeAzkVBl65JO1Fd1rMiogeZpfq8JAaesvWk9
         WUMA==
X-Forwarded-Encrypted: i=1; AFNElJ+VcXJ/ltbg+KV7shetY3+ZETadGdZ73Ps/1gLwHTBDHthmECs1tRlY1ejvlmxGgweCB7FLf190GA==@kvack.org
X-Gm-Message-State: AOJu0YxC3Fb0YeFD1YKHDGauJ5Bt39ajqqtHMSthGL12n0jcJnVp2xej
	pTk11aDf/TvJqW+VocwaGy4ij1+niW6I6FHTOs3FN61CAiZcFCfuhbU9gz9Chy2f
X-Gm-Gg: AeBDievnweqRa18mUhOo6F3U9Vk9UznAhtbeQQpXjD0fEL5fXil/xkE7BEB2q2kl/eF
	k2HPcJF/SyNsoEsBUiEzkPyqZK4E74IMmW0rpBg2dZlP41Rc41zX4AJaO3O2VNcksB98WR9k1+0
	TGW3mLt8qBZxj7L59vvSYJReifK9GvEZRNmMExdoBm444EB5kGS09uh+QCVqiGvdbB56iLWVrUf
	UFpGHYcrLTc5/3bDN+k4fsLnnvDQiSW/mtd3WFEaApgQZ/jtQuBrg49h3u7v8+7/6PYfH5JMgI1
	TMaMqNfde7Wm2mE7+kTLvprdBnorT94DSyFwPLhkZ4Qg4dutVmdU1UOXDUcPp8lyMviqOyNi6IT
	bfiIwzJsKmlApn0yExSDXkAlyymuuC+092mwpP/0QEt/GxQv4zDlzAjyyUQKdgLej8uEB5eapIV
	B3enShIGhS7KH6EjcxKFqjuPuioT4=
X-Received: by 2002:a17:903:3d54:b0:2b2:5857:5847 with SMTP id d9443c01a7336-2b2d5a6e90fmr60372575ad.5.1776099057890;
        Mon, 13 Apr 2026 09:50:57 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b463cb01afsm26172155ad.25.2026.04.13.09.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 09:50:57 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	akpm@linux-foundation.org
Cc: pratyush@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH] mm: memfd_luo: account restored large folios correctly
Date: Tue, 14 Apr 2026 01:50:53 +0900
Message-ID: <20260413165053.164338-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wb9hthnegmx6y6gmu476oxatmqcw4r93
X-Rspamd-Queue-Id: 4E330120011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776099059-731502
X-HE-Meta: U2FsdGVkX1+4RcEzDoDA9sN23+9UA1a4BE/D667NZRfRMszu4g5jJ3+AKrJH8X/QHkpmG7m2iyMGC8bwT4xv0KoF49wJ0cgyrpPUziKX6iolEFlmWUGnqV6JfqB63nzzeturZ01xqoeLev1tZO5LEcW4AAn5AbqclZ3fT6CKjq4JYhv20Ka2kE/X4Chpcya1o7uUzvMCtkpKRAnX7MTLjKO3+DMdnPEFCysGExRESP+ZTpf1bQX4tSGdYR0bSNnYjSniFAfhFaebUty47CEpLyE65xKsfkidaJ8wL8t4hxrTusQA6teBVvr3YwDuz4ETmXmjyx2k3qUa1nJx6bKtNwLhlRkP4zvKHn7tMdOP0cmEHQOMSGXXIoYo/EwKpq42SLHJIbLoABOZslAbozSYkrgt5aD+1GHbnd4zFa3rOyuVeQWFoG93GZ/c6JztUmxRiAhHIv0Em5qeHoiM8izEbJovx19EwiF6Uw/nR3hJmXdy/enoi2QwiiD6WrBHmePd0cgoK7e4QSyRCB1nuA7aVSBGAyjkRNOMlX7klaWIs/PRv3FAa3oSWy7j8MwkGCmW62oqn39vukCOGDvauKugS+w0wdnrh8OAFM3zo9xNaiRjp3mBkZMrILn8MSd6PYtnV4NLDNS3ottDD4bDfSBk/xPnGKiHPXSxmX+M6GZdF0i2I4NoNn259Tf9KXFS3viGgv6K6vZ3vN9P3c07leYynrHUhbDjnmOEUO+4fI+xykaSy/iZuYdqaUQ9lLySjZXdA7MSp1x4g2C82BTwuNrb9ZPCGIDX2+kBcmGl8k6tVOEchKVlUfog5Ty9vTRyrbH7MOOvzCG90HAJIVqsVMkUiDmPl48FKpmmSo1Abbb7jW1ODsUbtS+9Al7JQmwXiqjU15/Fg1Wy6bbHdf0Dd2PWTz4OuCHCYY2OBLU2zJhlmwq+UsFw8Cc/qt9udDjiNkyJApqF0hZbuCvLYb8aC5R
 hd4iNBfw
 nsfm7C+cbzHNgVszHhP+ValaCWl1mSH5CMuFQChlEBAnTgDt67syJQbxMxY99hV4ISztsDIKqorD+UkUGm7Inm9uidQ+oZxsGBswvHzQ8W+BiLBqImiTbuygtYgl+1vMwrI67DdeHoehbGyFyjcqPEzuOL5Kn/1llsAHRkgyLh5hY8iZRPcqcU5RrH0HQ+KATQUmMr6VeSKQxMoZHNMeHhEx0eUIhMUa1ptBr1uKFUC6w7jNgAwYCucr6ELmB+NupNeKAzmHL44CTRatvERmYByqieUJNJYlMI9cL/DKkdK/1iN6uCvn1qmZkQ6UT2DYiFzlNrjgq6vUkSBnv4Prb4RfAPc2hm1mvv0SCZED7Abmin9uyRlYo/6LyxWmutKuyjSQ6Er84aNSkPAgCAIbcpPCUN11PlW6FkFBvMAGOpjRNFQiakVBu/3o1ss/K7l9b2yyTqriqyvXijpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_luo_retrieve_folios() always passes 1 to
shmem_inode_acct_blocks() and shmem_recalc_inode(), even when the
restored folio spans multiple pages.

That mismatches the normal shmem path: shmem_add_to_page_cache()
accounts the folio in mapping->nrpages using folio_nr_pages(folio),
and shmem_alloc_and_add_folio() passes the same page count to
shmem_inode_acct_blocks() and shmem_recalc_inode().

As a result, restored large folios are under-accounted in shmem inode
and block accounting.

Use folio_nr_pages(folio) here as well.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 mm/memfd_luo.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..6dd0284b90c6 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -402,6 +402,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
 		phys_addr_t phys;
 		u64 index;
+		long pages;
 		int flags;
 
 		if (!pfolio->pfn)
@@ -441,14 +442,16 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (flags & MEMFD_LUO_FOLIO_DIRTY)
 			folio_mark_dirty(folio);
 
-		err = shmem_inode_acct_blocks(inode, 1);
+		pages = folio_nr_pages(folio);
+
+		err = shmem_inode_acct_blocks(inode, pages);
 		if (err) {
 			pr_err("shmem: failed to account folio index %ld: %d\n",
 			       i, err);
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, 1, 0);
+		shmem_recalc_inode(inode, pages, 0);
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
-- 
2.43.0


