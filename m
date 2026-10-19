Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4E4CCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10646B00B9; Sun, 18 Oct 2026 21:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1826B00BA; Sun, 18 Oct 2026 21:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7C16B00BB; Sun, 18 Oct 2026 21:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2336B00B9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:02:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1AFCA0606
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:02:34 +0000 (UTC)
X-FDA: 85337575428.10.88A45C4
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9DA18140003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:02:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V5Q54Or0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792371753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ev3xzK9VUla8R0Otc8+sWvhyjTp5CVfjvUfT1rJwpRA=;
	b=mIzLnpoGS44zb/JjWvZlY2xu3cKXX4EPnbHEGs9/vmwt0EekHjipsyBJXgym3ZTO0UcWaA
	31IoKOYukuv2kHYmt0oW+ioT6nkTF+DD1wzOWq8w/eUTjC54b4MQ5vQQXnBqpaJ7KDpJY2
	5nZKu30ioTGvK/91negBZ9fxgD4oagE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792371753;
	b=v+V55Nmozf6XP/0eqykwoLxRV7Z8Vyu4yrPFviB0QXh+1jl/1Jzy9RmatUCNfgT5KUqwWV
	9T2cdWmLf3dJnjrMREElC1ZYAMljr6WyosTJHOdlTIR39/eprV0hGatPCY5h3Pp95vBiiE
	bRqM4WyBSuOtnMp/X0I3q+1TZr66JRA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V5Q54Or0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7SU2HNON/BqLq2bv/cBKuk5LpU1ziW+Kvf5YYswTIMs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792371750; v=1; x=1792976550;
 b=V5Q54Or0jGTuNpPsKosHfm8ybonnXKSHjGN7wJImYDTyrcP/Xby+C5jLIuLAf5LCl05iBLMf
 0yL5M1HVZdvW72E79PTFS+k4U3IHx01WtNMlVWHeZvqs9dtDEAsUNf2lMVw+l6PlWMPUtVy8zEm
 GR//fK5+cBH7JPr6hLb46adA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9ff5fbd1b53f1ea9;
	Mon, 19 Oct 2026 01:02:30 +0000
X-Mizu-Trace-ID: 9ff5fbd1b53f1ea9
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: samarth.colleges@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/ksm: keep soft-dirty and uffd-wp when merging a page
Date: Mon, 19 Oct 2026 09:02:24 +0800
Message-ID: <20261019010224.69153-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261018122957.526467-1-samarth.colleges@gmail.com>
References: <20261018122957.526467-1-samarth.colleges@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DA18140003
X-Stat-Signature: 9115sar7pdznpohz1f4ohe9imw7fkqeo
X-Rspam-User: 
X-HE-Tag: 1792371752-740807
X-HE-Meta: U2FsdGVkX18ggTMSpcEkG0N2bhYBCP67acy51Tw+ELgHuMq8yND/TN/5+CaY3buhi6Kx9Hx0XTcVh8784VVz/z8jquYls27j5DP3Yuh6ZEeY25knTB7A9Q57CSzzrQEP3NYp9WuTviYSMYx/3WpiZWdw1Bv5dwCAMENDVvWVq4n2/QlPy+H0d6Ba8TXzfU/SPS4zcaji9ieMVezSCbXVPr/OSIxBNeyBq09Y6J1smBxYk9BbKA/5nP0qRhDVEKx8v2llvYRn+jgdoqQSDNQpfgu0+AsX0PCYfFz/knwKc6GsTQoQB5pXkufeZ7pHoqKUdN5Mrk8vmHqIddQs0FTNzvTJuMa0AtJbEZ39BL/SD2Qjd7Hq9x+bZS4BwwufuUqp+E7+iyZmGGZhjWM1Fmxait426r56QQ7dRKoAqaNLNqksSCjdnxgeGhrpKcLs6sNX2k0/to5YU6a8dE74n+lpfdREzhHJr9qwfROugq7EJ/ss7Ijz0R5TIdBR0jA+NiERnGa0exuo8L4VLnMCOOY29BN8JUZIxg4VxmoXqZTMkLQungrk2mZUmU22Q3xAspHxB4X2sXarAQc3UzRIvW4PkppLSqxrzP9hQkL6S9A325P1ao8M0ERqy+oVlDLdwJSTgcUPFftn4Va5EzQaBkqhx7lqGAlVK0zNDX+VajXa+U7Z2D6J6QYlu0UwhHogwbyBDxVfXvXxOlre+rmbZRwJ98+INOt2oiERQnjiUVWOyOj+b8Ja2awkQmWKvTNmmUtkzD4ZrWMSPn2PFhI3waFbrXhpJ6rwJMUX97IDMcOYPyPyO+ggr0PaSrF1KmCWvmXoE4DzSOd8OJV0TvIK1BRjW0upLSKmHs4Yi3Cv83QrWVcmdUn/Pij2M4wMa3KCRW69OEJSeTCkYWpo1HYDoeFQ3n2fbKKgx/HSsKewZJUjQBLYOq+7jvgNbxPdukdA+37Tw+1UEmmg/Ep9/WG/nwP
 0d/T5n3W
 od5LVg8LdLrelZ3HDNvVHwu5eD8VBlfS+AVnUVU3MFXElyYFEQpWpEqUnzxKN38nQ2oSCe5aSOKmEP5g8VaE6nxsdFYNziRoapGgXP+Sas4nu7fuKEgI6VPpH5l2l+RE/E4SO2AFLb6sUHnfI/x6gNLeDx+UTTOG0rzMN2hZf83t5356DEMOk6NTHRMTedUrd9DasMaBCKxcSrTTgFX95jT4+5FIuWamMIiSPr+H9JUuE/gBFZ0GaVrcykO/LkcrSj7xrR5c+LJKEyJzfX2YSqupy9iCDxvXgPOzYzXYRaz2WptXO5PmkdL8wMjThp0jvYmYLdLqXE7gRQ3mywNK8IC7S7RYIaTHlST0JPuBSwnLgFg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Oct 18, 2026 at 05:29:56AM -0700, Samarth Narang wrote:
>replace_page() maps the KSM page with a PTE built from scratch, so the
>soft-dirty and uffd bits of the PTE it replaces are lost. Due to this, a
>write before the merge no longer shows as soft-dirty, the next write to
>a uffd-wp page raises no write-protect fault, and because the page is
>mapped with the VMA's normal permissions, on a uffd-rwp VMA the next
>access raises no RWP fault.
>
>Copy the soft-dirty and uffd bits from the original PTE to the new PTE,
>and restore PAGE_NONE for RWP VMAs, as try_to_map_unused_to_zeropage()
>does.
>
>Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
>Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
>Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")

Shouldn't we use these two instead?

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")

At 292924b26024, WP registration still returns -EINVAL. RWP registration
isn't enabled at 763f43865fc4 either.

Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")

As for soft-dirty, the tag looks fine to me :)

>Cc: stable@vger.kernel.org
>Assisted-by: LLM
>Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
>---
> mm/ksm.c | 13 +++++++++++++
> 1 file changed, 13 insertions(+)
>
>diff --git a/mm/ksm.c b/mm/ksm.c
>index dbfb8f98b189..b0d0555aa1b5 100644
>--- a/mm/ksm.c
>+++ b/mm/ksm.c
>@@ -34,6 +34,7 @@
> #include <linux/memory.h>
> #include <linux/mmu_notifier.h>
> #include <linux/swap.h>
>+#include <linux/userfaultfd_k.h>
> #include <linux/ksm.h>
> #include <linux/hashtable.h>
> #include <linux/freezer.h>
>@@ -1463,6 +1464,18 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
> 		dec_mm_counter(mm, MM_ANONPAGES);
> 	}
> 
>+	/*
>+	 * The old PTE may carry soft-dirty and uffd-wp state that tracks writes
>+	 * to this address. Make sure to preserve these bits in the new PTE.
>+	 * On a uffd-rwp VMA, also restore PAGE_NONE.
>+	 */

Nit: the uffd bit also carries RWP state, so "tracks writes" doesn't quite
cover it.

Maybe:

/*
 * Preserve soft-dirty and uffd bits when replacing the page.
 * Restore PAGE_NONE for RWP-protected PTEs.
 */

Otherwise, LGTM, thanks!

Tested-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

>+	if (pte_soft_dirty(orig_pte))
>+		newpte = pte_mksoft_dirty(newpte);
>+	if (pte_uffd(orig_pte))
>+		newpte = pte_mkuffd(newpte);
>+	if (pte_uffd(orig_pte) && userfaultfd_rwp(vma))
>+		newpte = pte_modify(newpte, PAGE_NONE);
>+
> 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
> 	/*
> 	 * No need to notify as we are replacing a read only page with another
>
>base-commit: 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc
>-- 
>2.53.0
>
>

