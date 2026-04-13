Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC91FEBFD38
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA3B6B00A0; Mon, 13 Apr 2026 06:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AF06B00A1; Mon, 13 Apr 2026 06:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D710E6B00A2; Mon, 13 Apr 2026 06:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C535D6B00A0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:57:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89AB4160143
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:57:33 +0000 (UTC)
X-FDA: 84653231586.18.A2111A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 069B8C000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:57:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwc68Fjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077852; a=rsa-sha256;
	cv=none;
	b=FdO7tCmNKr0a14c6xQqawT9AlpukpePQBB8cdyJDzKZzMvu2uMXM/GiO/dvqp04LHqWacI
	YHlBkvR2S1gsiFsMR1nMOPHrNewM3FpZtO3LCBRCaBkkhxZCHMenKjIolgyYSfF6IzQslE
	+VZGf59f69mMaYcL5+wxIwrN31iVcqQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwc68Fjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pSRKkVSc3p5BWyCAFI/NRqylj/6O0xQw4U3MKbH1fK0=;
	b=BGFjjH67lZETFImQ2LBBNhidyeHHMY9TomTB5ogNNSyLLiOuelw1TdczTf8BNzMFfpK4WJ
	toC+s6+MEQ0VImCWTUlY90Y9ROzdvB0Bx2968fkXBKXa/LXJp85GI1ET/Azyyd9Q132hGd
	kYDsy6IAHhn13+Y+5ruwJyHzlG3GXGU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CEE360172;
	Mon, 13 Apr 2026 10:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B885C116C6;
	Mon, 13 Apr 2026 10:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077851;
	bh=u2egHWP8ia1Dy/ziREu/MdzfbhY6Dr9OLTDesW4wdTY=;
	h=From:To:Cc:Subject:Date:From;
	b=gwc68Fjjz4TqVV2ei+WyJ8tm6LOzzvJuxi59ZnqAs4rR0Nn3bWImiM6zmbLobe7Gm
	 /Mx7LL2GIq+0Msj8O8/i2oLP7X88QTVg0TT3S+ezfbLYui3DrY7/oh+c+1t+ijcKhB
	 7qE1Znty+OVzWGS3c6txkIDOvNs8t8z51U42DftG3j47UkbHjbzxSjqrgCkbOHkARh
	 JqFMkdcB+VyqkVb41W4CF9tTkFgr3H9docg2P5JeABDyCWrfW11fu6Kw7Xh5XUPJTN
	 wzyXsWa8fYLIHNc4WvtuTECD+AZdCdXV3A26aWI7Xw35/L4CiKBQDD8qW781gwNV8Q
	 6en4yaBDPV2MQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH mm-hotfixes] mm/vma: remove __vma_check_mmap_hook()
Date: Mon, 13 Apr 2026 11:57:13 +0100
Message-ID: <20260413105713.92625-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1gsiyhxn36x9neqm9etd1ux5qdruez6g
X-Rspamd-Queue-Id: 069B8C000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776077851-576451
X-HE-Meta: U2FsdGVkX184AQ5ssInR81iPLJy/VFCj6LFxAV6WCpUO/EQ0/tU/N9ph58aVmuQX+vhbgQqKa++xN93CvonDwKrC0oiBxzyoQD1hje6fxP3DlqYC027ddHM1MFcgpT1hWcLHHz/k0kH21ADLxnaRTU8K+5Qv+1At3LR9zRsZoKRaKUqOjPCDolztbEP3XGGRlYD1aXndF3ulPTpXXag9PygqR/eBotL+RYvqy+4rVIzYpNVbGtIrZA/oiFRERskmjSbvTX+3bQQAKGYP9jNKIbD5Yn9173bxiGRQKkQPyFFhgVfLtQpdonFwp1jz/WHsLXamIhWDiuh2QUAabNzjpidwj/hzHfQWd5T7HBP3DvJ1CXe8wpQos97I6cvCYc7uZxdzwZPFyP5i6SuHMiZ2vefy1fMmnznJ6YTsEZyWFIc6U01KaJi33+/f7CurAyPxsXFTxIWCALG9BZl8DvHpIB4EdYDP+rBsbywVBJhrNYW7cHJBrccT3yc9HeHEy5JAzYWF6+ZdLXuE/1JU1DSlIqckf+WJc1VqdNkv6af0rrRK53zrK4R8oOOD3ac3qWeg53V+DmXnsqBxDCMfpPU8iFkaLrOydjTBDL69hEiCiW0caWPVY++3WtVZOhpJGg4LpeO5d/ZRugigOq8dcm5vKb8hR+UD7j+ne4zR/UdrUl1ZxjnT1nRYeITjM9j39i76dWvVjWxWMkdti7JyZGDnztffU4i6zBizQBqvye4JpYWKmn1sYeJcWceD7dor8tEUlixOLSPU72m8/7O3rfzvXsW55Z+idzADdXbAm/VKMOGNlRxF1XoNJcxCbBQSA6G7DRGcNK9uR+kOB+7MSJ7nDhBxicVOKgjifo/iTX5RIQwkMsRgXDpKZjJ4V0wCKDfgzRB+jT9an38TophlRmTa+gdaQleUtwNUqyAY28gjVZ97IOrQeqA2uRho7EnZA+atD5+MvgjaTd9TzgpeScN
 phK9h1jG
 iT2rEjCxMUfFoGqxo1BRDDGXisOvRHskThRXalK64eEfRLLuOnUzJyS4cq0x5U+E4m1AqGoSPlB6dFgNlTu3M2651c13yv0hxBmfH54B+BE3CAEEinRAEdLxi6Bw4wfvyAHxF39N0nDDFnVHjh1Q45rczngZJ0wXSruhbzYrccAGK0fCzccBCh1gml6q5yyKMm+uU81j++MaaLZuyZoCpaqbnb00tln4TPoQ8xAzqnkQVcQ7tiSMmmjPR1gu9HjmZ44Z4T0XanT5Qe9OOXU5B0+AzcPFfaQOnF3lJFjEewYsAK36JALnIN78p/Dw8pDQXFP+psKlYL6PYHNFdTEtU4j6J0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit c50ca15dd496 ("mm: add vm_ops->mapped hook") introduced
__vma_check_mmap_hook() in order to assert that a driver doesn't
incorrectly implement both an f_op->mmap() and a vm_ops->mapped hook, the
latter of which would not ultimately get invoked.

However, this did not correctly account for stacked drivers (or drivers
that otherwise use the compatibility layer) which might recursively call
an mmap_prepare hook via the compatibility layer.

Thus the nested mmap_prepare() invocation might result in a VMA which has
vm_ops->mapped set with an overlaying mmap() hook, causing the
__vma_check_mmap_hook() to fail in vfs_mmap(), wrongly failing the
operation.

This patch resolves this by simply removing the check, as we can't be
certain that an mmap() hook doesn't at some point invoke the compatibility
layer, and it's not worth trying to track it.

Fixes: c50ca15dd496 ("mm: add vm_ops->mapped hook")
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/all/adx2ws5z0NMIe5Yj@shinmob/
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---

Andrew -

c50ca15dd496 is in mm-stable, so thought best to do as fix-patch? Will
leave a small bisection hazard (unfortunately) so putting this as close as
possible to the patch it fixes would be ideal.

Thanks!

 include/linux/fs.h |  9 +--------
 mm/util.c          | 10 ----------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0bdccfa70b44..f3ca9b841892 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2062,20 +2062,13 @@ void compat_set_desc_from_vma(struct vm_area_desc *desc, const struct file *file
 			      const struct vm_area_struct *vma);
 int __compat_vma_mmap(struct vm_area_desc *desc, struct vm_area_struct *vma);
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
-int __vma_check_mmap_hook(struct vm_area_struct *vma);

 static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	int err;
-
 	if (file->f_op->mmap_prepare)
 		return compat_vma_mmap(file, vma);

-	err = file->f_op->mmap(file, vma);
-	if (err)
-		return err;
-
-	return __vma_check_mmap_hook(vma);
+	return file->f_op->mmap(file, vma);
 }

 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
diff --git a/mm/util.c b/mm/util.c
index f063fd4de1e8..232c3930a662 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1281,16 +1281,6 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 }
 EXPORT_SYMBOL(compat_vma_mmap);

-int __vma_check_mmap_hook(struct vm_area_struct *vma)
-{
-	/* vm_ops->mapped is not valid if mmap() is specified. */
-	if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
-		return -EINVAL;
-
-	return 0;
-}
-EXPORT_SYMBOL(__vma_check_mmap_hook);
-
 static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 			 const struct page *page)
 {
--
2.53.0

