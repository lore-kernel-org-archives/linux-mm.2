Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4C4C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA0AF6B00D7; Fri, 17 Jul 2026 13:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A266B00D8; Fri, 17 Jul 2026 13:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C609C6B00D9; Fri, 17 Jul 2026 13:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98FF86B00D7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:31:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E155160195
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:12 +0000 (UTC)
X-FDA: 84998959584.09.F35FD9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F29F40008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mW7ymBxJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adqfM1VF52UApKZ4esto4yd6ee7VDcwIxlypGM7JBY0=;
	b=ggAik6PbsO77oh3PmJ01EkFmjt/FLiN7jmxSQfb4DOjOO0h0MBFmvlTOcbWWoyDJBKoYgx
	54o+07g5uMatrcNRGdqMIjpypzI7X/OsSwuTVGxTCjNx/tL77z2o7SCkhVSjC88Xr9J6V2
	k1aKpb3ncUFe5YYteKnSpj1hnuuV8sA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mW7ymBxJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309470;
	b=HdVb1LuHb+CFES7Va8CslOtQtk3FFLjA2VGnCE32vp23sME695Lauxwr/MKT3pFtQ/8GdO
	lY0v4i3rjEhZeWulyFiXeifQSVYfmTIJirAdPWCFIJ/lGlTZTdifp62/DXfwLz+IfBN++V
	3PI2mcQv2LGhvVzzPSKDnzLgpHMPq80=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0083D60A6D;
	Fri, 17 Jul 2026 17:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAC61F00A3D;
	Fri, 17 Jul 2026 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309469;
	bh=adqfM1VF52UApKZ4esto4yd6ee7VDcwIxlypGM7JBY0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mW7ymBxJXJPEnbbaFA0UsYPLhTxbTPMblfLKS7QeqW568DbUxgaRUY7zLQHxGBoBV
	 86680uEMKDxD8AyU/EC/HTv00K7gMLCsLcIMgFw/h4+sd1JxGQP12ypOycjVQk4sQ4
	 XBw5xkgSCJZHStzGysvvQFQc3q+2SLQya0hcPMCY5poXVoUzXJOJktSpfzSwZuLWcP
	 l6v+rJjiTfPQIRFJXhiCRlaPUFoIlfz+2DFQ7bdvXQzDmIezeWGk5RAeuBcpAaCee0
	 9I+8T6Sqetq+fpVtXU+xXV2uy6o8CWbtwIW34asPTGI6DYAusFhqkhi3WBhe+G+ICz
	 XlFmoeK/VQs2g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:30:09 +0100
Subject: [PATCH mm-hotfixes v5 3/5] x86/mm/pat: acquire init_mm read lock
 on attribute change to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-series-vmap-race-fix-v5-3-606a0ac6d3e5@kernel.org>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
In-Reply-To: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2831; i=ljs@kernel.org;
 h=from:subject:message-id; bh=FncxTVoaDCe8XgBgxmxR3F4pYkqYCxDSgA+rKimYCJI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKi0rbrCT16ub2mRjsq5L1Ck+OmWsWrey2ezPoumvndp
 //7rluuHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI8lSG/463b91xC/KqPrxk
 pv+ST1+Lb6zYqchaXR3jecN8wv/f+nMZGdbd3WG6dcPVjzoTrIqfHzq179POoAUh3IsL5wj9t9L
 dvp8HAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F29F40008
X-Stat-Signature: wd8habkxb9ao9x8w75mtujzht1hx3rm9
X-Rspam-User: 
X-HE-Tag: 1784309470-10511
X-HE-Meta: U2FsdGVkX1/Jwr9u2GSLYF0AP32C4tNl6OiR9Uz4v5GLVjzplQtI2NBQ9QJsdmZfxnNayr/4TFNTo0epHozBY1/hOOkgAEAB1BhK/NFugucNeodw7z6It/LoRHPRoNqaw3qBY6vCQa/Dt4NXpJ7P4IlQrnk7OkHO/abN0MnB0sqPSAJR4aU7sp2q2keekRXV8teHki35CAi8EIqY+EgnmUMzvTc8AbZ/E+/CC9hms0HEz5EmJqx2cpQZNebFfkTAEGTSGbZVCzslUWKNT2ptTQm+t2e3GYhZ/3Mpcp58TtUFyrgttbUY78U38Zq+R9eqoU7xhI00HC7cJZzamaKm3M+7XkoDT2Nq1/8rE1JDzm6+OYQXFMiQrVfrpSJrddFIf572Pwk0283rpFdTvAm7F6Dhw8X+opP+QGm8MkjkhRYYaFe+1FPk6C5AvNk4daZIIm7L3zIDo/SXnltYlfeOOlfYPkX45l4pJnKkqs0Ibf7PcBMqrPQWNS+27oaRQIRbIk6o2FyvL38/+4RUz8UkZYsE8xDu016HHOET+3YPPvUc/Nnm8Ov6ZPFmzMa9JS1pk/wGOq11WhkJbh7R3dA4gLrJaY7ErXg4j4wKetkFSlP7X3jYlaIwR3oXWX9pA+tqz4ufOU/9mCV0+qA5H11AjX3aakpGz7n/kaL+9VqY1IDtqRVVN6HDRxafnmqn+fUdfnvMxZLE+jUgADL+BJsJDcsoKamJqdIYtcM28bbQdKJRU4PMOzfR0wcNVjlEJ3rMoBs5d78zrgZjX497umWt/uOVIC+OZd83QsVgYVp7niAQF52X0pyJzijWq+T8zbrT75i9qeZTI67whlDmwbvf1fA1wQPNx9YB8QM/ein9PjknPVkP8H/d3mh2VALn0/mcOPHfDz5kf3rZ21WNZihrGsfPptp5NZ0VLpZerID6GTvu7anhu5ElN54BwSjO5hkvTVAo61o161LxTMdo2yO
 duHgd9iq
 S5D1hkP09wTbLIpucW35i0ILUlRWM5SvaXQ5NJNLKtk3H1r602lSj5irGN8p71Ph23YdHELKPklp68GQKaMvrfxPyBIBy/2TIIrzxouoEHJkAgwbjfVd2w5vmEYsNhcDk+2nX/p+iB9HR6bgqMfhLIL0YPDaBxSB0gwsAQZ/YUntwhcyx0M8serhnIFxHDjurO+8aSzPanX9eA7GYwTHtIYeBkGseZLNL6M1IvGHMEv6poB06JDg+zb/GTrRxQit0pcGBvMJMbNLQQmA0EK24q0INC1MGUjGvJpngIizbYW2+sCtUr4erB5L1i3Lif86fNGbfOKsEJm5IIiV+g0tFXQeF9FkvrySKk2tQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A previous commit protected us against races between ptdump and CPA
collapse, however one still exists between attribute changes and collapse
as reported by Denis V. Lunev (linked).

When an attribute change arises, a lockless page table walker obtains a PTE
entry, which is later written to via set_pte_atomic():

...
-> change_page_attr_set_clr()
-> __change_page_attr_set_clr()
-> __change_page_attr()
	-> _lookup_address_cpa()
	-> lookup_address_in_pgd_attr()
	-> [ lockless page table walker ]
-> set_pte_atomic()

There is nothing preventing a concurrent CPA collapse which can free the
PTE that was retrieved here, resulting in a use-after-free.

With the mmap write lock taken on init_mm over CPA collapse, we can now
resolve this race by acquiring an mmap read lock on init_mm over
__change_page_attr_set_clr().

This locks across the whole operation over which the walk and the PTE entry
write occurs, solving the race.

It is safe to do this here, as no spinlocks are held upon entry to
__change_page_attr_set_clr().

The CPA_COLLAPSE flag is only set by set_memory_rox(), which exclusively
operates upon vmalloc ranges, and on x86 only within the module mapping
space.

This is important, because some callers directly invoke
__change_page_attr_set_clr(), bypassing this lock. However, none of these
operate within the module mapping space.

* cpa_process_alias() - a recursive helper called by
  __change_page_attr_set_clr().
* __set_memory_enc_pgtable() - operates on the direct mapping and (via
  __vmbus_establish_gpadl()) the vmalloc mapping space.
* __set_pages_[n]p() - called by set_direct_map_[invalid, default,
  valid]_noflush(), __kernel_map_pages() - operates on the direct map.
* kernel_[un]map_pages_in_pgd() - operates on EFI ranges.

This work is based upon Denis V. Lunev's excellent analysis of the bug with
gratitude.

Link: https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org/
Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d1e63f7d267f..301fb9e77d91 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2122,7 +2122,9 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	ret = __change_page_attr_set_clr(&cpa, 1);
+	/* Avoid race with concurrent CPA collapse. */
+	scoped_guard(mmap_read_lock, &init_mm)
+		ret = __change_page_attr_set_clr(&cpa, 1);
 
 	/*
 	 * Check whether we really changed something:

-- 
2.55.0


