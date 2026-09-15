Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 440EEC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCDD6B00A1; Tue, 15 Sep 2026 08:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C0A6B00A2; Tue, 15 Sep 2026 08:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2416B00A3; Tue, 15 Sep 2026 08:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE546B00A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:54:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADD39403FE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:50 +0000 (UTC)
X-FDA: 85215991140.02.6FBF986
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id F1476180004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tthTfBN4;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFGAjcgsBNZUtMlZjlNuj+eLmu5d+vEUzhR99IX1VDA=;
	b=HgR/VA+gsGi+WOZdnzKL6aa26uDw73NiOIRJzh2y0YWgZ1jRa82T0rOOPMdPLV5o4Yy1jf
	yg0xjREb7zsESumFusYSlkiBd+aHhK2QRYBft100ZSw6cGTuweDCObCwRDeRcIYL0Shsvo
	pa3ozzufvcv8v/cUmQQ4ZGdOET2Dx6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476889;
	b=NH0mtI018i5tvnxygsbfjHFDKsR/slPIQnGoU4k9lp1JrOACW/S6q8aO2j5Y+Yn0gsvC6v
	G4klVl32mzLIOpFEl6NMDlSBJSYFrAEjb0o5QdpegIYIgbctmY/XCRlpYnwiwBV83VgJv5
	WrNn2vlP9BJT43EqFgQ7KnKi1kHtIQ4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tthTfBN4;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=KFGAjcgsBNZUtMlZjlNuj+eLmu5d+vEUzhR99IX1VDA=; b=tthTfBN4x7zCU7oGsVV6Szsvt3
	jvEGAStFY3aByDpkFQ5VIXyHuEyyUNEGE8yGXVKQj1L8z+KaXwyg9EwFNjUaUaS/AtU47uM1fItm4
	WNYOH43FOfWuHSCwAI6seskU41IGUBS/s2Nvdv9mmSkUX2gx+A48JVhqafzaIwX5Q2o0gmOCa7J6/
	ITl+/NOqiGF+m9GDu6J2gzFRWbEEFJe8Yp1cuELMtoUWTSWgdja9ke2cHVwcb85jm09nAmp0vav+i
	UbM7uQ1VJHTBD86CwMtdGVcHr78GZTF07OnczSRjppPZmBpNj6OTeGtxnvfGyEs2Qc0UU1b69cwPg
	15mtXdIg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6SgN-004P8C-3B;
	Tue, 15 Sep 2026 12:54:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:40 -0700
Subject: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range is
 poisoned
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2450; i=leitao@debian.org;
 h=from:subject:message-id; bh=i08dYaHI1fvoon+7eeYigKp4zMx+PElqpyXpuKwzxk8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/embGYYuss6ak1wnwb0KANA/8FHnDgmX1h4
 yqoOR7u5/GJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bdAqD/9H0G93KgtP4UxtzgrruldA6BytJMy0AZ6jAhasSf8Xy51dKJbfJUkHr7TKK2A/9p/lW5m
 jws0OZ2Jh1HezfvwYd+6NvlKCOa+QGaJnDmH6HqzVpJC2ZlumNgcZ3RNcfpfw+4W+mh6vny5/iZ
 0fvgOwqc+HRut7kUs/auiQbJGbqAU2fCfUSdkKIRVUPSgw1nNzJyir+kgdj4l1k5h/xt630UA0E
 j0CbE9MU7zcmubN03NhUszPfN16ZKJTuxCjS7i2ZjLsnbWNJyzIJ16ILdTbVwPw7Fb2EgLJzFXS
 3pIug07eedNDCbACtksMxD1viJqIoeGbS8a+1ltS6rbYv06jp6kghZjmPViI+rTWQrBD79maXZt
 ZUMgXjcdw+MhWAxCbeLoreCBlQcOKru/nzd/T10zivH86oljN2CnnTDe3s/uUhVqJqmIL5MqaBU
 WI2IkZreup6BBbcP7ECZFUW9EWEGEdV4JeU02oE/OqL+tucY2LGyeurRFz34tQs+bJl7hepbsO+
 2Z7o3h3vo52+4AEnCR44nK7x6TkZSDgVEF+0/sF2ay4niRqriVVCTDeazUUcTCf2GjooHeBWvt6
 yuXaXrYH6gutAekaiv1f3EOttoKg1VkUvmDxRic4Rm1mQq5MbrIAloJxWAKRhUlKq941oiT4yU7
 LHTs6WyqCVbzWDQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: th5sndju7yju4ht6p8w7jdnrg7g36mrn
X-Rspam-User: 
X-Rspamd-Queue-Id: F1476180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789476888-274153
X-HE-Meta: U2FsdGVkX18hIdy2ANposnrJY+MbB7aKSjQ1Xv2+0nWvn8NofzvyCiMQTZ8PxiGLFayaByuxZTsnf+gzGJ8Yd1cC0G6vG5nxsFAP8ErAcsgZbFruiv0FmmMrEHDrWOojjYGLGYstDb1pXiEKG3Ncm32Qe0lGp/yK6SO5mPQSHwLgtKJaBCFGQw8eQyXFaByfBewlGO2iTuDciKoU9XJnOQ7P8+Wcv8WYzf/b2S2Ji5x4KDEWnsZjcQ/3zfFTkImRKnQQMgy3aiboOjabHIeGOsL84k8QTSZyiT+W39K0aa9zsQ+aXL4vjFdpFVR0SgRoAfpsyVfxZEMns4AHHzLqQmv8L5ENUzEavCS/YIZRXJp8rqV65iohYfvSp98fntTNG3c4T6qxegPC2t6RfKCcM+R2z+jTsaKSz/FuuqiWj9QqICC5Wkq3QzzuwcCkG/mmT+6JNh/dI5JdKct9VgJPQnBb9Uba2pIAWSWP9QrdFcPMuPC8UBgVX6F3x1iPTiQO1YHWTqhah16uoUaT3ARt1+RCk44/sWqhczaQZuJiABbIutGEbn08UweU3q/AjcCcgtikzho4sdnPgFLSREKnNIGPAIiaUp5IuVSlp+5CL3QNOfin1NqwDszf/HWwl4s4l4YanXUefbgtfgPe2D2B5Pc8yUOeHRK+D88kH2b0EcQF9QzdKkh0LfZGryFqUd3EJwayPcD693pCm0rPBNqUyutQXPifJ+Xs6rtDRCsesR1qOHkNRn5iDuwcCmo2vz4B6F9d0hwFpVB63U0H57PNl85sSvgX1eU001Uis2VPm2jL7uux2PgCL9YpMThqRQfU/Zv/osmXPDkQPhj65V2tG4Tm5jqR8m3iLYLV7yOY8VhJaIh9hwgcrQbMXZZG9vLtE4ZNAaJ7XqTZzO4RsPubk870UtdhpsPQdzUoOYiseXbvPknz3ksjxqZivXa7VaCz9gx85oVD/jEOUD2Nep3
 /YGGRrDD
 xShtIwVpIdvuYqDY1RErZ35GHIeC/GnELSSCUkgQrnLgu/Z6Glynk3OYJZcNvLnt4b8ajvqzv9a9AwGePL0azn9/fqxl4yPw3pNccBXJhbou4dxx6CwQHytzRqY/bBhK4QQEDl/rYmQDBSi0VHHYIMnQdwssosEhs0Y1GjW5xlDh3I9FO6qWyjUh8d71rKktJw6/63ovb1Me8XTrdEoehKB3B9AEb7kvezx3M85vlugonv23NIaVANBQDp2x2+AS8RGM1ggNLDTIPQ/T7QPubbH9+0mseq2SsQYsUb52iOBpJk9sDl8CPWDcmF7g+H/i5n2E1t7uR1ReNnsVkuN1zsq9zrvZUrfNrXiL0L6UJRYFIs/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bitmap an earlier kernel filled in gets in this one through EFI,
but nothing reads it back yet.

Introduce range_contains_poisoned_memory(), which the page allocator
will use to ask about a block before handing it out.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 29 +++++++++++++++++++++++++++++
 include/linux/mm.h            | 14 ++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index 847592862f01d3..4e5cad0d1b9b65 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -101,6 +101,35 @@ static struct linux_efi_poisoned_memory *efi_poisoned_memory(void)
 	return phys_to_virt(efi.poisoned_memory);
 }
 
+/* Does the range cover a unit an earlier kernel recorded as bad? */
+bool range_contains_poisoned_memory(phys_addr_t start, unsigned long size)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poisoned_memory();
+	u64 first, last, nbits;
+	phys_addr_t end;
+
+	if (!pm)
+		return false;
+
+	nbits = pm->size * BITS_PER_BYTE;
+	end = start + size - 1;
+
+	/* Clamp the start into the table, but keep the caller's end. */
+	if (end < pm->phys_base)
+		return false;
+	if (start < pm->phys_base)
+		start = pm->phys_base;
+
+	first = (start - pm->phys_base) / pm->unit_size;
+	if (first >= nbits)
+		return false;
+
+	last = (end - pm->phys_base) / pm->unit_size;
+	last = min(last, nbits - 1);
+
+	return find_next_bit(pm->bitmap, last + 1, first) <= last;
+}
+
 /*
  * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
  * unpoison cannot tell whether the unit as a whole is good again.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 274fa880077c54..b68824fcfbef19 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5387,6 +5387,20 @@ static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
 	return range_contains_unaccepted_memory(pfn << PAGE_SHIFT, PAGE_SIZE);
 }
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+
+bool range_contains_poisoned_memory(phys_addr_t start, unsigned long size);
+
+#else
+
+static inline bool range_contains_poisoned_memory(phys_addr_t start,
+						  unsigned long size)
+{
+	return false;
+}
+
+#endif
+
 void vma_pgtable_walk_begin(struct vm_area_struct *vma);
 void vma_pgtable_walk_end(struct vm_area_struct *vma);
 

-- 
2.53.0-Meta


