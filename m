Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB024C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2636B00A0; Fri, 21 Aug 2026 10:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6535D6B00A2; Fri, 21 Aug 2026 10:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542296B00A3; Fri, 21 Aug 2026 10:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 284EF6B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:50:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C075160154
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:50:11 +0000 (UTC)
X-FDA: 85125561822.19.EE87384
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id B60FB40009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:50:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hsf8uU01;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787323809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsVHSsNBVmunDbjw2peBUvjMtVALhYSkX0xXozMheRU=;
	b=x4KBV+RYQTu2wkgGMZZJ/k/8mFX6tekLOVgfkPB7yDBnJdexnc0DHereGEqACMOmBXs0cr
	gtzIbJc0by88H4sffkT73jvn722rD9iKIBO2dDF8zMfiDAqon7nT68QPLgPTecLCz6j8FP
	Ha2h8wdL4uV/cElUWSZTo0K26IR1j1g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hsf8uU01;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787323809;
	b=ciwvY/dIBtIuPjynDjrpNGW4LnpAQFDEL3nVrYlKA1lMih6lU7g/ANkgF6wCLQGXYm63RD
	KxUF5lRi5KX8Rcbg1mOarauWv4wNtQsiifVGfCxb8URKOgUo6315rIEVm8GdhOwCLvVLOd
	vA6NZUhVyEwftCETWiAQnWJjJ/xge7Y=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e6a434cabso57099285a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787323809; x=1787928609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xsVHSsNBVmunDbjw2peBUvjMtVALhYSkX0xXozMheRU=;
        b=hsf8uU01kf4QdOmCV20NPQL6K8q4JGvctlSwCWpkQLESl2Tn37il+bY5GuDVUCFKrA
         H96amv/YX13De6CcmV4Dyaf8345dHeipwfubzd0RXtVGA5ZXq0gFA+7XdE0faLa0QvTT
         6/296xLuZgJ9XaFPlzTjXvdJepo0h/Lhb5rrSEIAx+y6RPtuYfOiKTsdx2Tb7NOz3QJO
         WyNZG2ewAGwog01hTVtoBTKoAZmw6HHWefmSxbMmdPcquDKsWWgna4Ltd8doZ+NMn0Jc
         yHxDTlwnZuc8l77nD+uefxi5Z+oYsKguRB9n4WdL8xODcmGyGOll2TNo96NOBNV8H9gF
         g3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323809; x=1787928609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xsVHSsNBVmunDbjw2peBUvjMtVALhYSkX0xXozMheRU=;
        b=A/dzDUi+QoklyPuHLA5E4XkJ1+zoZEScvzAFASziICniIgxQC6A/RquKdYBsYZoUV6
         TmB5CyBjf5UIM0KX+cJSgQF0hzDJpW4Lw56MafWQ/Ura0fS1CGYVkBTQQ0Gw3vlfk586
         91oHKS6yIn3t6zTXceboDyRs/tqUBsWzzmZXWfsH+EMQl/TOTibFx/mEhFaDKonr9UyJ
         35q7nQKKBfI6TbuABeg8dlKmt7nKKWyNsQWRPQJ2GZZ2KmAHW8172hQrayOCmGUo6+Mu
         EEPNG2FcIAJlrtFVy5m9/pS0hS46N+WaQCMWgTL2ib1WvVV8OyP31cHlkubLiPkL7tB5
         4LGQ==
X-Gm-Message-State: AOJu0YxMzJSjdShedSqm6AlnpLpii1PfDL+alEMLwFI4zBEzbxnBrdyQ
	wCmjxAMKNGvCClbBNYdtyJRGoYUsondA4l3k+1HYL7KN+QmxB8tRTlJBM79hzM24DITauCiTG67
	5c3SxSNk=
X-Gm-Gg: AR+sD11NAMnjrWR+Nf+EU+VTkVkbS/yvMQ38hKIDtuweR0/+TSwPbS5kziScfFZIlvP
	ybj5J6ggmAYDApCqM1CUbaGkOcNCzbJj1TFX3gNM1Qdnul1/EMmu9tn9m8AKwyMsJy+2KGd5uR6
	3Z5JMJ4H7upby8xwmyqP1e0B8WRmWuNINdH+bb3hn+UtadbAgYFO0AdZrhcYyx7J8aBP06sgWtJ
	BvHuN/ELI0EHLBDQr8pKxT/xOkVoxyGAsmWN96ELX3jJJpxEs3sGntLYWiw7vM2KqPV1dnwrPs9
	E0xrI73yNTbCHuwNRpObGs4n63saJd8yj66fCE5iWE1WLLsMe9HyhQ/A4tqM2sa1HhvnPq3cXYU
	QAXNMzwB6Orc/5FEAxZ4vhCskLMOPMYmxVe9/laxueK/4OZsxwBti9nESvsUyfSvSD5ITUpjCtU
	lUfOtUOfhyGWf6jQsxJ7XnY7aaCrBwiDT2keLsCBk3axT22cMuJfaTjKL1jh2rMKDTCh2D2w7aI
	qWyA1wrYLxbhhDj43GUrjzbjijW7LBTNGcA6o+7tkANIB83FQ==
X-Received: by 2002:a05:620a:70f2:b0:92e:603f:1f20 with SMTP id af79cd13be357-937394e9257mr431611785a.2.1787323808787;
        Fri, 21 Aug 2026 07:50:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720493f35sm609512385a.9.2026.08.21.07.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 07:50:08 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
Date: Fri, 21 Aug 2026 10:49:47 -0400
Message-ID: <20260821144947.167382-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821144947.167382-1-gourry@gourry.net>
References: <20260821144947.167382-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rsat7t7pyxxad9z8ro9yoe57kfohdirs
X-Rspamd-Queue-Id: B60FB40009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787323809-590527
X-HE-Meta: U2FsdGVkX19RGF0Bsmu9eMlZi0OLV0gi+c2BqiD++XkiiEK8T6I+VMZ+L/yjG9qVDULiXTu2tNCh2DGFyORS0F3lpH8dd6hayejpcs9hMP/17sx7L26gcvgsuf96rOjVnhsXciBlcLbTQUouk4avDlujz+M1TPoy7HpviZPu10MVh4MoYqNTSEkh04XRF8nfGW68VD8ZFfYtIpXz7i86DP1qmILCpflKd6IPkwJ4cLMeMJ9UValWXfy9+yBMrBa5eT4Wzlr9v/oXaNUGk/M/pR+2B8yy2l1brnWA92Z5rCZuUGpxCV3yGTIPiZ4S98Qvw2NJ1iI8cSBLQo3bep3mXISGynWBynXHOiZ8o922wXnXG/zvgCiAJVOJUkUTQp6m5YFWsQfAyEKfxh9q+20/EUHA3iL54NkYHC8CsACqXSJFgjjDNBDUlBEAgfIVwKAB6b5Bz1xiZCz5kjmeuF50kL3AWn2t2ntvdHJX3VgyrFgQ1IL2WjxLgcHkmq6bH1EGjvV/qCsoK1CLdV1gXLYscaExj5QUCKbiI5zFc+4aS6dr14KI94b76NPpY1Ac2IfXXL6LrRr7RMsgdJJMIB9N4vgSRjcGzZwg/79bM38Dd3b4wJEvGUOYbpFpVBoDAWNNKTQZMd5wfcOmKHBA3TosDW0fxRBO10TLK2qzEgaTOe6Te++QLd2TOQ+A8cnTACNCFjt6ShjhGEGcEG51uHfHNl95uVqlzW14cOdUFvLvcYgKVaPzzxTRJ/o9nBjGnjcsbrUZWexVir2M6N1cWMzyDxrFxwaaEvstvRe7gh2fqTRG8lyoZKfMEnVatpB6Z5TMYPAqBUsMye32mP1JFIGVMm8fiFFrULeO/wIQe21YKFxqUhv9Hcca/PiWMLBmMEDCi/tSKrklCRrcmJaQaPtVKoig10Du0mVfslplpQFu2lSu00aHfw0VsNddsVxVR7qHZEKNsDy0JGuDISR9U+S
 h4Vu69T3
 KEolezN1Ru22gytAZqaK6xBokze3s4t3pL+rJ1nOpMdF2t7YJSLMaOEsVCsYjmUiJPbs8xdHT7grkAbVUEKPpcgOzplqIaukvloNVrdED0yZbQ8fO3Ax6TbKbdsU98Av3Mq98X34cy9H/QpvySM0IvhK/Qd4yi0k9t+blXMA90vnchM+dcpVxNsOAsjdVurESdYOmSADzqY773FZaF7QoIJFzkwFCCReHncu0dzBb0/2w2KGT7UkwHrbIH9rqaSGbaxTK0C2ebxWDqOZyqC/Dd0b9xLD/jhcRWyKYKDe+25RZvWRNVVNf3XSAUkAFtBrmC7cU/cbHOXdYsFDWAQIHLy9VRbspBUO3oj3DdZ7QnQagxRXr+e4iuocnYD89tO+cH5EuwxYmoEnOUWa73ONKEQZ4wI2d5yahe7HkAfCrU2NHWrE3TwgL9utTtd17+C68u36DmKPXNcQaPd5cNRyF2JqnN3bd+UnuNqaV1Q+V5MnRWEzR1B/swtYYcmtpay/v6mO+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap a VM_MIXEDMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - mshv_vtl_low does this, and needs CAP_SYS_ADMIN to
open - then

	madvise(p, PMD_SIZE, MADV_PAGEOUT);

With a stand-in module for the driver:

  BUG: unable to handle page fault for address: fffff587c0000008
  RIP: 0010:madvise_cold_or_pageout_pte_range+0x410/0x9b0
   walk_pgd_range+0x52b/0xaf0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_vma_unsafe+0x8e/0x120
   madvise_pageout+0xb2/0x180
   madvise_vma_behavior+0x46b/0xa90
   do_madvise+0x108/0x190
   __x64_sys_madvise+0x26/0x30

Nothing validates the pfn on the way in:

  can_madv_lru_vma()     rejects VM_PFNMAP, but not VM_MIXEDMAP
  can_fault()            *pfn = vmf->pgoff & ~(mask >> PAGE_SHIFT);
  vmf_insert_pfn_pmd()   no pfn_valid() check
  pmd_folio()            pfn_to_page() -> unpopulated vmemmap

Even with a valid pfn the path is wrong.  The mapping carries no rmap, so
folio_maybe_mapped_shared() sees mapcount 0, and the walker goes on to
folio_deactivate(), or folio_isolate_lru() plus reclaim_pages(), against a
folio this mapping does not own.

Use vm_normal_folio_pmd() and skip on NULL, as the PTE half of this same
walker already does with vm_normal_folio().  The huge zero PMD is already
handled further up by is_huge_zero_pmd().

Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Cc: <stable@vger.kernel.org> # v6.19+
Assisted-by: Claude:claude-opus-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index ffd6a68320a8..ab362bc482a5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -393,7 +393,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			goto huge_unlock;
 		}
 
-		folio = pmd_folio(orig_pmd);
+		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+		if (!folio)
+			goto huge_unlock;
 
 		if (folio_is_zone_device(folio))
 			goto huge_unlock;
-- 
2.55.0


