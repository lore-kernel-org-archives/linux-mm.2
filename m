Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34AE9C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346996B0098; Fri, 31 Jul 2026 16:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320766B0099; Fri, 31 Jul 2026 16:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198796B009B; Fri, 31 Jul 2026 16:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7CFC6B0098
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68D67140136
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:13 +0000 (UTC)
X-FDA: 85050158466.20.C17A62B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id D45621A0007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WEUFo6lg;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJ70o10O/g3H5Xkl1BshZBHBRF3IX9NucmJReUP8SV0=;
	b=oct2ag0MNcHW5miiCaHb+iYLdxns3bX8cM3S3imJqGek+Jmxgj47BgN2P0BJZ4qvQCJ5jm
	oOe9e1EVAk7BNTzL924SbosN4vIfrYerwo9W/NmUsGgaBawZci/eak0ajNgyh/gsFQTtLo
	l59XajHBPc6t0BSFapYz4aLGSkC3XYY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WEUFo6lg;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528491;
	b=FJnhUk/k8TbIjoEuGtkkygMYEtX2zMENvVMbIxZEIRdCMr4Sy4MHipCRh9JoE5rdnR1sOA
	u8AayNZ7A8qwlcBKjLBnJsKVBp6EgYuSwgLoXL6scvV5q4oMpTTIW90Jrtfafwrns3rWFY
	UWbn1dHSLy5wLLGmwIs5MTHIXWK+fF4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=bJ70o10O/g3H5Xkl1BshZBHBRF3IX9NucmJReUP8SV0=; b=WEUFo6lgpEaA3POSXGYOQvorJ9
	q53YIASpBfUusnCBlMc8ZeJXQClAlqIBG8xH98fFuBv8wle3jTQqR/d7AqvrCCjMYTvXY3Lh7RJ4L
	5xJVaolHKvCU2XoLkGguvbczr+dN9xS9+qjc28qvAR8tuR/zJT+Kh3iFd+GAIuHWymQN/TkwZMcZy
	jcyop2y8kT2j23DSIqZc8tTVfyzw3cERn/7cFsPIN4h+EX0dgtLC8pUyDouP286OjeVhAdg0We/nu
	AP/d57Df9WRrji5aarcIVGCJgxTyoB7NJx1kopNFKmXsa8KphPUsu7NtqdyK7v9mqC73a9aKpbxUJ
	iOPnk2dA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWW-00000002PjV-2oCc;
	Fri, 31 Jul 2026 20:08:04 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH v8 05/15] guest_memfd: Use folio_has_hwpoisoned_page()
Date: Fri, 31 Jul 2026 21:07:50 +0100
Message-ID: <20260731200802.574821-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D45621A0007
X-Rspam-User: 
X-Stat-Signature: poxchjyfjzhrgfisse53bojfbioi71qz
X-Rspamd-Server: rspam04
X-HE-Tag: 1785528491-140005
X-HE-Meta: U2FsdGVkX19ICZ3Y0aUPdLL/do7izEdJ1qfvuLfNc+vQ/AJPr+5mxm0pSi5x3inmQrfCM1hAh4fIKHWNcqF2Sdtrs+Dz4ZeAwDtMCYOZzgrM0b7B+cGpRJ0+tWtCWoi0qL1810OEkVkJhzb3a55u8LDrfSOFdyCYgjlumqGX/JCo0OAJkiM6GdbTRci8tv0FnNlCmRmOheEdKOLtks/l5iVeBcAmPUssWFPVuvYzEGmeMDNSWYlRzO+gh38keE2DJhVWwOkys+N5Vl9tsBykw0Cnaxxc0ks0APyQbUv8Us+gMzX9gL/d1vqeRJoiXBKksB45vLhee+M8OszYz3gPvz5k56aKnO5h4/1gGnPthoTIy13AUpK1csDvX9WP40ichsqjfBtkRYgCP8073VlvvXO3tl9C80ZOcQigADiJxRoFCnCUfHrCFOKbd3IefaE533eXasNYxK6RoK8glcksvo8tKCp38GZlZk5xhybyvNB6FWYVDweXAj7M8G1KoEkdmIbNOZmFnfroXbSE/hD6AkSulchQaBGjREx/74Jsr9Z9scnmxWdxlpcTqlZVrm52q0zfzgv2tjNA/dT75gGaOfYRQU6AWP5Wd/K7XgmQNXz3EIFoB7zobWZvNJj2wn7yRNSb9Sm28qzK0c+NPCAvTyMi77tr9x3YTjBfpC5n4qo7XzFTEJMl29NYytLQsEAcoZPLuLhasXakcysIeEyoMHusDmpufAg+EtHuzOGvVGIbg1sSQ5jRVHhnOOKOL3sW2nr/hmASSmTfN3OqrT6jWs++3o2kX2M9dbTeujOSZl5ItQX0REr7oxy7sKrx1BlBUmGZB4iTOOcs5FzjFZA2C/x8ilTkQ0hPafGdkqYlgprby9scwBjPDAtL9PW3sslbuLhc+yFfYvnK/iZjGEnUa0DuxezgdRSur0hBRgR80UUcgiGgcsMWUnHr9nyD/eFsOfhBbXSgTksP6bCmbSw
 1J708uzg
 CkiIHY86wELMJwTNT8lUmLt2hQ391akxa5HtXzyqw0N5kR673R8kHtvfAsSUVl2pw8T9RjSEBhnGj9OhZTlUXRcZcgody2VsIXQjO0rOBF5NT6Hni1/wjxt7a+PSTfzLAoH1YblB9j3ucZ1Bnt+YV0/r1wDm09XA8YHQW47aBIclxZirNgGCacgqvTcvuxKcejddJITiGTvn7HSbL0DBdfMPRlEiXuPh4I7ptId2QNp4dXWz/EKjH/R+JP3Ar+FXWpXKROFKS+jhSSsxV5LkGJATYV4pDDpsZ0BRf3uomfU3YS5IDaHU/nSBIfSgK53AFbRMfqQ/QmL6BVRzNPnEJc2H4anZrOPFrPI9kXAMfWUj5H3RMQ0qOcpKoiZG2u4Yw/HN5GZKUy0tzW5JbcUdi0Nfwyn9UoPIUgNju2QPKJMMmVPU+p99BpyUpJ4VBWO/QN7KKRydyKCD/G5VpwO9VrPiyz2e3m+JHu0Q8diuPAyGmE8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_test_hwpoison() only works on hugetlb folios today and will give
the wrong answer for other large folios.  folio_has_hwpoisoned_page()
works on both.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 virt/kvm/guest_memfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index db57c5766ab6..94eedcc7f1a9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -774,7 +774,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (IS_ERR(folio))
 		return folio;
 
-	if (folio_test_hwpoison(folio)) {
+	if (folio_has_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(-EHWPOISON);
-- 
2.47.3


