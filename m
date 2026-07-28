Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CFCDC54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4F56B00B0; Tue, 28 Jul 2026 16:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2957D6B00B1; Tue, 28 Jul 2026 16:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D96A6B00B2; Tue, 28 Jul 2026 16:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D693F6B00B0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 471BB80510
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:46 +0000 (UTC)
X-FDA: 85039364172.24.E5DCAE7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC953100007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JzvrCSsz;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJ70o10O/g3H5Xkl1BshZBHBRF3IX9NucmJReUP8SV0=;
	b=p/3GwGRqtzLgIPuXxskJUslW3E3h/fXwonKa9p1J0bEkXTjI4MfkP4KycHydpWo5bgLPC8
	uLw9tRGemwX9ZXx0Ms18ok9ZX6UGMHQAQLOqQwbLVZERNfRWc5QhY7Zao7K+XXlGPZH5Hf
	rFFyICloJ1V+CdHNB1xNNmJKmtoZvJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271484;
	b=DLY/m4ZkIpShME75jazviQoWiWBfCoCPnt2j5ntMF46w+w0De+q/b8Zh4Gi+J19jqg+acF
	MZnSeUlm0vjeXRHLczUoKjfVojAQRHnuOi3wVNcSiEAFNM/0Y/YNRnMTFAdVZp1+LOG+Qm
	cb/4TIimbb7CjAx5O0vsTx6lxMz43i0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JzvrCSsz;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=bJ70o10O/g3H5Xkl1BshZBHBRF3IX9NucmJReUP8SV0=; b=JzvrCSszvYiOIce4qGKkpUiAh6
	KQ3keSUTFtL80Lr2flwEphoPRUKe4rhlOTdq4XtjQoFIUbwa59Imw7G3jl9bzINM+UezFF31uw0aG
	z2UaMjcHOaQjT2bI661R6gOsxbv/qs9WTFIHaVc5weAe+FTR3t0TL8ED9xKbPE/a9mzVbTVgUrfBF
	34kzY53UzTljsbU4Qeblgt4QPyMpnKSFiG7F/eNfqSEwKHML9/ah+6QG89LsF+kfYrcLbLBcqu+xs
	4dz+zOiMhKNXJcx2eJBXgQ8YAQgAtPDnpQI8Hqn50iV6sF6gqMhZIicjch1h7OGKaOq3FgD/7TtE5
	596TWKdw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooep-0000000EFWX-0K3s;
	Tue, 28 Jul 2026 20:44:11 +0000
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
Subject: [PATCH v7 04/13] guest_memfd: Use folio_has_hwpoisoned_page()
Date: Tue, 28 Jul 2026 21:43:56 +0100
Message-ID: <20260728204409.3396238-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC953100007
X-Stat-Signature: fdtooitkfyq79p54qrhq16bbmg4n1by6
X-Rspam-User: 
X-HE-Tag: 1785271484-167900
X-HE-Meta: U2FsdGVkX18JqkEYxNQUsmH/cNCzdY5W8whOiWhDZd3a7LRrhLK1x4yCZ6ym+xaMYscMTzzaDVmjfZ1QUiwcVZQ3WprC9PhKPUaKSmBWTOKMIkK7UJCC68PGqRDavjLF+3BNMn4vifq0VRbRUqLpee9pnJnGJ4+Azwb1SrqkdzGbl6QrWu3tzjsM+Puuou6tCiaP4XcY/iv9UdlGEzRnwPbE3RwNapt+ieE3/liG+aikhczyAe/nHUU5aEZrVo14vQdmMBWl814BrMFMMdXa4A73+YbP0xy7GD9UF5AlEpaf88G8GWWMrIz6Br0VIyQF5G1tBo2VuQ0vyqHRA3LWGTMXYdN9jIrzzGRAI4k3htXoYMIuxRTh6Xyuv4+KDr4LkOP4BM3ZlQYTiSTdJcqfyUWd2rp55shuL2BPQkO2kcWhX+sRgaYBr9x/DUOqz4IiHjIzYrBb2oXCWd+sz2Ck9wHYnWX0o10La73K08EuZjqx0uDYbcQpfQSomtvI1MVqpqvwkgcnXfOD5UCg65jPg89dq65GGRw5+Z4Ya0a+bdAv5YRO4IiC5ImzJtgrPoxBD6HB8MNdpiSRJAjo72yfiasBHjbIYE93+wwjoMHEiAzv18wiMXDbnEcozjH64HTzAWLILqD3Fj8GHare1Ah7mOipQ6yry+ys7hivoL/Ay2O6mudKlUxp4ArF+ddJVtbKGzL8uaYYyBnjbeVNNHrsHFYHfYOlZBvigIMaxWk+BrPladOmimtakI6t+2MHB7Z6qf/GZ5BJsNqdwODTTQjDCLk56iL1z42kg1XeNttkTmjEGO4nvCQmCAgE1UMV5wxys53s7w3TCAZl3iA+vC75ER1eMN0Txo81/wGJR4AiG8zdJyDWxqtgRgxXc+MiwfbBRmt0NNnjpknnKgOBY/SGwYqJXw0a4ATBzhW2RMs0v10/R4tExo7axjz0XpzPdsj99NdEcrVySyKLsPN1DgO
 +CCPbPFR
 cRkbrCQ3170JLFtk9EnnN518bsPAJWYt4NFvGTqVw4sOXpcV6LtFDyUKsWOjDwyjFxBOI39B1vru+6b238yp9i7CM2ilEZ7r4oKVBwUCGoA+juOF0vcu57+99y+j8u6arpADdXwjvC1L3EZpujBNZjmj5DS7oUJRfhvRIMp3S2rmvrQdJ1CNnnV5NoCWghLC7yRTuNNTQzY/pxc7j+mdi3msF0292r/33VLPBDfYZk0UTNH1wQhyW4dNtMoo5LBgJnqn/ViUZR41Tb+SCfuueZDsUU2apODzZBsyUC6xnUofGq8f3t2SEFwNb1mS9zjggxuyOwsDAZgIPRevh1rsxuyPcyRrorwBIFNFfPVQ2oMBka76p1V8ogvdn6k2tBXVEOfygbe17LV150T7ZvImyKrvMsdRqPYsmDqRAi5nyFhJIimDlbxtJ1TLVDDMquoRIQLwrETkTDyfPMejw88xexnJDZnJhRhUAiFuxOEj3KUz1dv4=
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


