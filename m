Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B464EC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2426B007B; Fri, 25 Jul 2025 04:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA146B0088; Fri, 25 Jul 2025 04:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF9F6B0089; Fri, 25 Jul 2025 04:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF306B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:07:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5766BA46B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:07:50 +0000 (UTC)
X-FDA: 83702058300.19.A06132E
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id B886140010
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:07:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VH3V1MWn;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753430868;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXMaEZZATaqkCZVg69+il4b2i1RIWEG7iB7MnNkYGzI=;
	b=YK0jrEcSzlNgM3ROc6Dh/DOL9jJRbA0JHlfuH3azndG92VFB+L6ux8+5kMMe1HHnfAnU4l
	KzTXgJrpLpbG9J6SoxtVhfV9pLNnuhz6ghApvvAoL5i8iso7rvyiuCKQSkH0mnErKwM7OM
	2ADC4WVRDIDfRvXYJmAzUsuK/HsnB3I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VH3V1MWn;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753430868; a=rsa-sha256;
	cv=none;
	b=rZrIa/wz24+dkhuMOlszFkmstZuFzZoV1X8S9SJrt1PjD+HKB/BkK3NXWOxJ2iYvjltBjD
	mvNN8VFo13aC0JpmBbKWtkJ/vn2OAXAZZmkHF6kM04mYv5T4udycBvFa8H1LxOgmBeaFFf
	ihxcEGETqy/Cevv1ocG8ofFeCa3rKFg=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae3703c2a8bso370176866b.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753430867; x=1754035667; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXMaEZZATaqkCZVg69+il4b2i1RIWEG7iB7MnNkYGzI=;
        b=VH3V1MWnoQhsR9mzA4W1gn0LHPH+Mwx0Ei6esiaiT1vy9EnX7UpkXSPLGGCmsHV1yw
         kZIMRb8Auir+OQeGk6PtdWyD/4T+UQC6+CHHNYdOJz9y8Edsm4hcWK82WH0GKyViK6AS
         o95Uv4z8T8s8pDDtHw0gyHV3fh+cAxmoSSOEM1c//Y4YLQXTXOpGdYZ/g1n3GE31fWkh
         id9PL22uau7S+OQ8ua3bhDmUaaGhmvvZzjBlpe3eT8bYtaE+M7T+ntDynulYW5+uvvrh
         FLpn9OWzd2YtFN7fYdt5fM18nMwmxQJt6v2RG7Ca0ZrQ7VCugPTDq3UMppMsphL0TVur
         vWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753430867; x=1754035667;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lXMaEZZATaqkCZVg69+il4b2i1RIWEG7iB7MnNkYGzI=;
        b=L3rV1ks6WX+6L2NM8DR6zqcGJVyrAAr1K+8W1ZjSpOWUiFsNHlqzVJhSmF8j9mwYH9
         fkdZajpuUL7//WlewIe00xGWEcV+MuWqhufgt3NlKKOHgYvVT7Q5RlLgM3DH2DhJTmk+
         xDtD1RQ+wcwtI7tDrePZZUE45AkausZZSLaQgF8gt4QzCjhkcJYYGCpq6jOq4hhKPng4
         MixQ7xyAx5dYlCWrYUrNWTWhb3RBKRqbY+knOYG/8P3RTZMfxLKpXK49oHZt9OMEC3eu
         5fHPtCldD9PbemCLOzCvYpSESjGhThrNuZHtEV1MUvI26u31hzMZuzBBS8yaIzuaKw8G
         7XBg==
X-Forwarded-Encrypted: i=1; AJvYcCVx0jqFO+ud7sVfYKay+OiGfj300lt1XdSnWRJbAL2hXGjKvajceRgYNZyaYidkZyE5OHS66d4IEA==@kvack.org
X-Gm-Message-State: AOJu0Yyi2is2HLHyRCEkbPbiZqTblVem3c/mqarYAF2ay7VByrfpe06u
	cwAaLBJCzXNKvt0OHBlrG39Gqc6kvzVydaycG3ehCEUJJ684vohbrvRe
X-Gm-Gg: ASbGncsXE+WXDewZjWg7ajeZFM7REqbdJ0+EL9b8fS00uQ82IAn+LEOHOjTZxQ8CBX/
	iQQWDe1RpIENj8qS1HzgI0WLMI6bqGtITUL95eUguSq1Jy0cAU7lc2/Xh0CD9eduUXcH0Oeamu1
	tK2iZupstFZqLRxEYlMje9pT2ynSG3uUaj/pie+iNyXrIo4Lo0XrkvH9Y+SzV43t1ylkj9EcJCu
	8VOE8ufchTXm/veymsTV8vxwnSmKn7j+J5IKtc/ow/M674PPO2p452dbF0vf9cvQtsYAPrhJUxd
	xmzaBCnSxjYRXyEvNni5QKbtraIBbD/LqfRY1SyIiJBSh/oaLo7/+LTyfMRt5tVQQXlt+fUTLc+
	r/zTBD8aL1U/8veKL1C6SqQ==
X-Google-Smtp-Source: AGHT+IHl6UmUdU8B6e4xhx6Ln8Ji33PC6IYqJ94cYWNmCS+nZAA1Gam8BVTsB8iILWrkEqlErnW5Hg==
X-Received: by 2002:a17:906:7949:b0:ae8:476c:3b85 with SMTP id a640c23a62f3a-af6172034a8mr105706166b.8.1753430866719;
        Fri, 25 Jul 2025 01:07:46 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-614cd0d1f85sm1848549a12.4.2025.07.25.01.07.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jul 2025 01:07:46 -0700 (PDT)
Date: Fri, 25 Jul 2025 08:07:45 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 3/9] mm/huge_memory: support huge zero folio in
 vmf_insert_folio_pmd()
Message-ID: <20250725080745.clm4s73fqtmsnqsn@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-4-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-4-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: me4ersmuibn5p8bhtgbryyxg87diwxtz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B886140010
X-Rspam-User: 
X-HE-Tag: 1753430868-129476
X-HE-Meta: U2FsdGVkX1/Z/A2DuK1MT5RU/NCedW7ZdAKgD0B3Df8VTbJ1BAe2LaMSYk9Ln33ZvBYkIvQKmj6yUkCgJMJZ8BHcvCgZWGeKB9Bn/RaOHaoAMspesSs50LSWcdMbTtvVFuaC43t+ooFqfsm3CGpOYQxZ1mdx92FDI1MReU9M7BrreUBNNEpRUEJ+1xscJE4PYuPQclamL5ZBTLVkovxVABvwN0rSNlSE6jzVGice8beyYOmu/9HdYwPeLvodpOpodXOkbTPSyfWieOkGTi4UVTDLrZVofyni0yscP20Vk8ifw36+61+TvrPArpki6e/G8BQ5JZiaJaOaiqpgAzyP+Qc+Fcg7s3yWPXmp36n0Mi8XoJe/rt/QnnshDvh/bgxVYPozqPUxvIZ/VXdUX6P1Qm8ceQpqMyNq87cmBdZl4DxBlxJo97riTAeD44C+PuA0IwxKssKBml9P11TDMT/RXzUtr5AA6MkMKhgNLYY0OJ8YJGaxFIJg4XzIg9YxesaG3yC1i8O8jJ+Mk+CECcdFInati4FW8QKnRSzVT1qZO67HaeBRlEZ4iUveYZEgiP1lfkOMscdKQ1ZHWGtE9KZGsaynU6izIFGUBwGQJy9xfiyNZF0oWuNrnqVDi0eqZu2oSaDaxSsI7dt09CBl0DLOXMWe6W5ZmJasTNVEh/2/4/kHkS48SNcqHWtH++4p0sRXUCqs93v0jrry+CDLX5uv2CdR+mkI5d7D1YHkai+rtvq1ZG2Zq0cIu+V6gVB6y5TlKTlEmtxaH+BsqwAA8y+2jbzC49ztsNvSVCn3azy5Lt5RWTAuvHJ4y6wAEO0bZ2MoZJmDdcyo0JWxIUYaulya6N6LWadVpT7KRazr8y/5BWnpEMqVpK4gpbOQjIr/W9SkfVuQYrE5NSXZB0nbNF/ZVN5GP04PV00hhRLyLYJ/Gazp7oekhp6i+bAP904n8unaYvT27BCQeyv/M6WeZHx
 ijP9Qury
 sI40sVNA1JR2UJ+MyCf7xYkdzMwriiNMEVSoLmbruzGnOaUd0Mkcfy9d5LfAd5LBSxvqEA/glDgrSXLg+FN5E14RygOMEYndXO/34T1ro577XfDAQORbJH50vbRdWKc1QotSIR8KZd+gW2uy2gsewivkpV1bIWbfIwvOGucRTVRboJNo8DXhNzVDiV9M79JUIP8my9KlmAZRTHQuhlEEwP+8dNOHsRB92WUPcQd1Ow5jtrbbLpSEjtQD/G6d0oNfEpIS+JO8LSEE/xTT2vsM64nfjuUaQlKkO7cstz1ZSfab8DpYyWQGLT4ScFHia3pRLI+ycJ/qNgjdzzNAfdhDKfEJHmzxTU/wdn0pF/hO+EOrz6aAtnLjVqRzwdzRojGBO/3dwu5lKhCmF/ROIomtbZHhbU4qTu7cbTqb302A/12AEo1TcFohM5/HnhkhHDK+ComilQ68BjKHXX5CSHM6ueM2c14xBhjMmBqphM9p+KEKlluoOGc1cYoLjEYSznJr1XgYw0VnLV26Wk8xJ/wDL7kBThlb3GHjPQc6o5xDbI4pu63Glfak3x6N2Fv2DjaGlk7sQ1cvO6BxM45r3HFAMoFKOr54KDuhkTkQZ3xcVcaSxK8TtCElw+DZt6/hRmnvuUF9LOb46leYa43lLuwTvSlDriMBpIscZwr6A0yCIuIZeePtmo9eWjWds4LEfzSEi4mLHLyp5ZnLuz7KiJtRd7trgeSWQrFF9IWlM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 01:52:06PM +0200, David Hildenbrand wrote:
>Just like we do for vmf_insert_page_mkwrite() -> ... ->
>insert_page_into_pte_locked() with the shared zeropage, support the
>huge zero folio in vmf_insert_folio_pmd().
>
>When (un)mapping the huge zero folio in page tables, we neither
>adjust the refcount nor the mapcount, just like for the shared zeropage.
>
>For now, the huge zero folio is not marked as special yet, although
>vm_normal_page_pmd() really wants to treat it as special. We'll change
>that next.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>
>---
> mm/huge_memory.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 849feacaf8064..db08c37b87077 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -1429,9 +1429,11 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> 	if (fop.is_folio) {
> 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
> 
>-		folio_get(fop.folio);
>-		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
>-		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>+		if (!is_huge_zero_folio(fop.folio)) {
>+			folio_get(fop.folio);
>+			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
>+			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>+		}

I think this is reasonable.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

> 	} else {
> 		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
> 		entry = pmd_mkspecial(entry);
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

