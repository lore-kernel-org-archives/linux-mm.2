Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69488606A335
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=X+fAzUuK
Received: by kanga.kvack.org (Postfix)
	id 420E96B05BC; Sun,  1 Nov 2026 22:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F85A6B05BD; Sun,  1 Nov 2026 22:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E446B05BE; Sun,  1 Nov 2026 22:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0747B6B05BC
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CDB11C45BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:55 +0000 (UTC)
X-FDA: 85388742390.28.4B93651
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 682F6C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X+fAzUuK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zf/FNDxhVid8OTniOLqen6jveOdJkdoTFHxNy9gCCKI=;
	b=bR5GxK/bsiJmwNM2zbD37MmzmdpeR6BEd753fWzkcH2Ln1aOfd0Kt9j7AbmxSqqf9XXV8P
	jk702QsufZql8METYZ9Dss5UCwCszYPFuTMKdcLigQYpzjx2swYpV/nYK3ZT+X0NmqbZoH
	ALEF9vdnx5lQIja0+y8SHh7aYzzCdpo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X+fAzUuK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590013;
	b=0iswVXoQFz2EFYmSV3IuKY8nGJmofuYgwIbIbeuRTXvkoAaNzM2f+mOqVUEzyUqXiSFkpU
	SCSYSEsU3IknibdRaOQKM5j0EHglTzuElxLhdq/Ce0EQlY3qcBrv0JQhEDkbA7TMvNsCgf
	5UnwL0aD9B2HgB3gmxiaHcJuYZD6D5o=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e987a2ba0cso13700875ad.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590012; x=1794194812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zf/FNDxhVid8OTniOLqen6jveOdJkdoTFHxNy9gCCKI=;
        b=X+fAzUuKrglOSgXW9uEFV6azWi0/hlnmuEnArHcxkxcj3SfyMsQzqq1tkqZBLt8/2q
         MN1DOQpY60ujr7czNxGhKMOkfry3x/II9wdF7nT0uy2dVjp2BcsNhx+6R8XEcD2R97ce
         tr85doMQL+jcUe4ecN+g680cV+Io4K5Q4+s3V27+UH+nn7Gl7QsyjZMPB635dcOC0aC4
         a6L+CSF62tpMNwUVyauPPmegyWXx6mNz6MDq8HgA5W4h1DpW+e3vRkl4uYsJJAgGAOYJ
         amXxQt1MsmOr17imb0AXy0lg+peBurvvwTKnlM7B6DwdCO+o6uhiPSQpW7ppvS0p9kRf
         B9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590012; x=1794194812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zf/FNDxhVid8OTniOLqen6jveOdJkdoTFHxNy9gCCKI=;
        b=fMPCdeY/uHNMcqoLEDKjl/ZSpBqLZANPiRvJGw/spCfueYeDAU97GxB3e7inOahUd+
         dW7Q2jdF6L+tU8nA8Tae4p2wMb/TBxZquwwqSYoctmVbykJfFRNvNissRJPheVO+MFPn
         URfkTnXrqnoSdIufY4PdanUW1jgTQjEHz0CdNq1mJZFctgn40XUG5ZfS9DFXr8EWxFCX
         8DT6r7ea9aeTPXT3wZybaCYOdNRo6jhmID6eHCUzIDe6TAQbZCNGvxkf19FLlXJNmkDC
         JTGFkwU9FF9mIrkAAUozN9f+TpzIt6bjxiTVWbQB7xxgHtG14vLskzmNvm5N23aWwOGY
         AUUg==
X-Forwarded-Encrypted: i=1; AKwUvByPuBgyM+XCRn33B1jZfLWQWL+WJFtyWBelfc1OGi5sLKcaPHIPKXMg9aDWNFuvYO0vmdQawzbueg==@kvack.org
X-Gm-Message-State: APuU4Z9Qn7vTyCiOS3Fn4EsqUV4bcLedMfmiLJHlSrGtjLA4OHHY99hY
	6zlFThgwrDMQP93tYl2wBBIfgPXaC8WpebuB1/xnsUKjW65h4oS4z8JRRvuvA70ETxQ=
X-Gm-Gg: AYBFou3NPxqUGSJWKtOQiitSkBJYBiQc36aPHacwsVnwMBg4PbeJKosOe8Kp5rG+B08
	gFGO8Au188grwmxxIC0C6labUki3O8F76UGldh+rtbpAdo4PeICYTTL+lCs6eJONNiskpt5fqrX
	D96+BXt/V1fJjuDRyz4qQ/2dI5QZZ82KMF/H6LUIUmDlcLogazh8qcXAH4u1fYe0L0ZtPMn5Zob
	9RhseUwKnjVj6SRF7z/9exnLBVY13wjnrZUHAy+6VGRJEq16P8xOmNZnfdlVyH9kMl2PpuICp9h
	NgCtNFQxCRr8pk5Re7JRA3Yk+CyzT/WwaE6UvLnqPhvr+m3HP6SujkQKjBliHXughpEN+/l4U1g
	rHwT1l5EB4zSV8SEN//66pMuYLs8kHycrGt6NgGI6x4jidCECziSC3qOg4ZwViXOjjCUO9vhNpY
	5lH8DnUk15fCEeJljFfTXfngJMZw5ZX13onTm89laVfpCCqMz8aTmQFwMHrwBwym/3SaHne/qdB
	/cOq+Qer+voMshFpsjMktfprVpLn0obLsQ4NzZXNE4v1xd5laXUKDRlz7M9jg6fobDB2PVuSoeK
	S2E8k9E2h4aPfG+DTkAcz/6ktLYvxr63pnuS4xYbARXxRTXH1A==
X-Received: by 2002:a17:90a:e7d2:b0:3a7:f4d:b23d with SMTP id 98e67ed59e1d1-3ae8984dde2mr7884760a91.52.1793590012203;
        Sun, 01 Nov 2026 19:26:52 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:51 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 08/12] mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Mon,  2 Nov 2026 11:25:21 +0800
Message-ID: <20261102032525.3597743-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 682F6C0004
X-Stat-Signature: 1hgtu3wo6i6g433krgyzwenc5z7mowyj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793590013-316979
X-HE-Meta: U2FsdGVkX19ChfPemMuAo3Ea3rz+5hxgoWMEbYF/MwaPa0IjvkdTkxKlJEXCIJGrUMXiicUazml//Zf1tR8d/yKTt8ahSkPfriPSDJJUWWdKWy855M77vm4/4+qqagPXbMlfGSRhVV+tfsUa3fbJcKZkCfoBJayXpwbrPLTj5ITjlijIKCcLRL1GrlN6YsZnTZBk+oxnsWwENb7Ns2PR+dNYrOA9nFa+BJJ8w2qNeaSZQjRu8WvnQLTkIHLdcew/Qd9j67bGGfiw5GSTaDAVlE+U8+a6PWAan4yMq+0h3aQGQBld+HSCgq62qCqgN5tFhdRg+BKAezsYa2hY7PHWYwlOzyTW9S7lEIcLUjhoLIqfHMkYwj3LAuQfwdX7viJ5fv2PVryNfKJkVTu4/+9mDm1KWINhXDZmPahrEILP52pUS2yy7prODrod/dBEk6EqD/6JIlcFjFcC3jV7CBp/45lhcxb48skQXg1n1DQdXNdT6mnRSeqhsk1fVnLwB8dd4/ckw9YFj9ZAMMSDLRtRlazRzDLTX/SyEATd6mz/I99LyqhUMXv6St4OMdgf46uxM3hqrsS95PKd4TfFRlP7r2l/W1VzTW9qVuSOsWYJ1RaJBFnl986EuKv7McStVhi8ctwPkhCBIvjdm9GBJybxrFPiSlAlhhQFRNgxwWWjZVtPbKD/8a5w3BM6eWD1w3jluVn4EVQXQsJpUJEPrCTkTRvREVcoNgMh5RU5538VR3+gQiw9J6nuqmekzJKy1w4ue8+j0T7gTpTIcwHosTDN3nxPjYMV7sLygVx477++MPCSg2CE2F3QD4Vqquf631jyW59XjwNmfV2ipieGprWNKMvI3qXCSLXB29pm0dInXFbySkpThnoU0lUGRRhgst23ILbbA4XA7gw0X0vCgsDTkLzkR5E5bXW6NbUQHg8qNI4s7XEOg8ELKxwsY01S9r/JTwwOkTTiaa93/MltyYi
 pI3YYDpb
 wVaYYa8N6VckJLowGHfQNMYLD1D2zf7NMV8J/eHarBr6s3FM1cuXn9hKj9JSmHoqM8hJ7yEB8cFIWy7H1czXXNcNQeQq+gDCko03bYPrc98ZSJlhp0aD7jK0V1lF6NOLYjNdzTFl77dKztbyR596cF4PtcJ37hoOpa3s5Ay462S8Vd3uX+wp7LcNiJsoOV41MPVCHnMx8lBUR4Dtzw63I0JwZKzx0mijBWgrggGmuI96OhCKZ0vimQ90tghmuRP9L4eS1q46E/bHTckYh5Ialn6SvVuJPR1XETmZ/asSzjTgO3x37BOz5oAf+XLMNWweKZzsHMjJfJpEub0W75F1wAtq/KWgA3HjjCfHW5iMj7bAxDTmLYuGVpMLC4E6WShsJmWqCbvpudowfAO7Ovht/P61BX6u51D2nVxMvOFobpH718v5fIAje5nSj17eoNzRM/ff1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Keep alloc_vmemmap_page_list() together with
free_vmemmap_page_list(). This also allows the folio-oriented
optimization helper introduced in a subsequent change to reuse the
allocator without a forward declaration.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d0af251aa533..244cd8a0c78a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -197,6 +197,28 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
+				   int nid)
+{
+	LIST_HEAD(local);
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		struct page *page;
+
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
+		if (!page) {
+			memmap_pages_add(i);
+			free_vmemmap_page_list(&local);
+			return -ENOMEM;
+		}
+		list_add(&page->lru, &local);
+	}
+	list_splice(&local, head);
+	memmap_pages_add(nr_pages);
+
+	return 0;
+}
+
 static struct page *vmemmap_dup_page_from_list(const struct page *src,
 					       struct list_head *vmemmap_pages)
 {
@@ -325,28 +347,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
-				   int nid)
-{
-	LIST_HEAD(local);
-
-	for (unsigned int i = 0; i < nr_pages; i++) {
-		struct page *page;
-
-		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
-		if (!page) {
-			memmap_pages_add(i);
-			free_vmemmap_page_list(&local);
-			return -ENOMEM;
-		}
-		list_add(&page->lru, &local);
-	}
-	list_splice(&local, head);
-	memmap_pages_add(nr_pages);
-
-	return 0;
-}
-
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
-- 
2.54.0


