Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A21AECA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24E06B00A0; Fri,  2 Oct 2026 05:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5046B00A1; Fri,  2 Oct 2026 05:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975826B00A2; Fri,  2 Oct 2026 05:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 680AE6B00A0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC4CC160656
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:51 +0000 (UTC)
X-FDA: 85277116302.14.445C2CF
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id F059B80007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r7vK2Bgi;
	spf=pass (imf30.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SdFF897J19vB9gXlitk0PJAT4sCzBncom/C0yG9+Zg=;
	b=sI/0jChyJLV+LTsWB0YgHDyKu4aVoE+UnxjxeW9fedU3UFEMWmbAjyaDhWlpfxuUod4I9E
	zCl3Nyt7VOzD6ajnWdcVN0pWgBqKSmzybh3vAJcfA2NAwq8kXv+ebEDirHIAJx4Hs76/nB
	wsKaPk6E+M3YZwlDByscq9WkIj+hXno=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r7vK2Bgi;
	spf=pass (imf30.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932250;
	b=qYldzHAAhzFqZYec/L1DAEMsx4fGHTZNKCrGGwgGE9VhQgD4kqQslrBQCiYhXjvuSzqcqi
	ckFB4pPHjyGVfoVMr7Qr+v+B5jfsvu7l5mKjWW2HDodgj98LXpaCvQV5UPsXnQWjV6oD5t
	LWC8ya/XtRZn+XbI+UIn16+goubZDAw=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2db1ca069c8so35838905ad.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932249; x=1791537049; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5SdFF897J19vB9gXlitk0PJAT4sCzBncom/C0yG9+Zg=;
        b=r7vK2BgigNRLJRZoTIURL//l1S3HgEgySFc4Ky6PpVsS3vxOb4cROzbyrS3g4MVR7t
         D7S6xEODd2opW+ue5yInQ0wuAGPnYqVmBhjUOD7kHCDIqozJZ5GqMx7LvlHybQpLWFmf
         IpsXIT2EFv9peFqPwwE2TAtXfl5l5Jy0asmE2d3gD2UUDv5BTtVTVNkekKQ1PlAJTmLL
         Tdz4hnjrNLlUorxAfhQGMO1NlchsQ1lbev/aK6T0N4oZexN6P3ai/zIRyhHBBKvRgwrl
         EHkdCLEI3BMLRdA6jm5fTOKCvZg0SyYhUGisS2Sg2b6e/5dfdBA0uatzIEkWn2SQlASw
         qPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932249; x=1791537049;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5SdFF897J19vB9gXlitk0PJAT4sCzBncom/C0yG9+Zg=;
        b=MO2sztmHdF0DRtO3T20Aiau75q9R8GKivGFFUacTL0lWKbhmvRutGR8H4tElebNL3Z
         aJxtVobhoQH3EBQ0yZNeOeVYGZV0rjy81M7b04e8kqkeoyspfuo9VUFS2HWhHweZjnET
         dsgrWMK8CwQFR8N8goIKkF4TQU3m79/prHR/xnmKHuVx2iCa5dMWrpkNfT/4wI78651i
         9+rNd81pKHGC7IiK4h7oksMVSDVYEqEixxtdWcSQ7xprh9KN3YWbZWD8j9aMPD0Higf4
         YZ6Bcj/HinswKUr4vpnZQ1nqFvjEQHu20MYYTuwLmJ7CndXBXFViYXW2KlFAV4bFuaPI
         sYUw==
X-Forwarded-Encrypted: i=1; AKwUvBxuRW/AcF2gSdBWNUfvQeSw/Du21jWxcu9cKDHZL9RG9Y865zDu8Vy5R5EKoLYkcgGEilRp+79zXQ==@kvack.org
X-Gm-Message-State: AFq9FYJJ4p0hwsLuO+ee0M9DN00tGZe/mwBW+QHXOMSDOQYL5D7VcMTB
	kleQ4G3Qf1xpyKcXTePLmyOh8LUL5YYPr3uPMg/mvLW1X+QehduC4/eB
X-Gm-Gg: AYBFou0ObO+fT+EOrue/vcn7GDV0sF9N0eqG6Iuiyl0TeyrYmbRMZowt0bnu8uOHXP9
	x7KiiGVo1kQeZ/U6ddTOyKrQUm5hqfcC6cuIAEITPQrW4sHaCx4+rTaR8aKBzfh9A2DcEVGgl2G
	abgkCFwbSVuHtL2lOgYn8FBZshA0tzTU89Rrasr8oDvpIo7G8XM9vsIylejQsG714Ez444wP2VJ
	wGjLl6gjrx7vgUwCQ1MV8VGKqFX0VvGxUaMOP+Xdqd9qA3FTREkkbJ4CI26EvyHktV57c48jNas
	uIz4kLZzOq/qxJJFO0IsGxrylwZpYls5+6MgpEJ19g6/YEprWssLlv0QTEGX/dVDH7z2T2ClW+9
	IdEe9Twto7Kz1BKXpKK0hvhsiZHOdXJScs1Csca853NOP+g4QgN/f57p3o2/FnRNT1A8OXzUfaS
	8EwFDYam3S0rnSNZi7ZJ2pccn2Vm1/RemZDLobyIp6WoE1thpKEwn+v80yHdYF6m8KFGobud2OR
	GQtZyQTlvYmOfWQVEE5iQ==
X-Received: by 2002:a17:903:b87:b0:2e2:f379:82b9 with SMTP id d9443c01a7336-2e49b821f87mr17258575ad.61.1790932248559;
        Fri, 02 Oct 2026 02:10:48 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:48 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v10 09/10] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Fri,  2 Oct 2026 17:09:46 +0800
Message-Id: <20261002090947.869220-10-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F059B80007
X-Rspam-User: 
X-Stat-Signature: fdsdti6aprx1jc1rh6mymcm4cmopxyxc
X-HE-Tag: 1790932249-522699
X-HE-Meta: U2FsdGVkX1+QNmjAmmzZjdHXMLZ3xzCcQZMqFQzI9GBgWl0lMgIm3SwfFpqdkODCar6Ev4rPAD1LpB9S+QqOLCiTq2jWew5Ck9edtJsbFv/Cy7Q2C8/QnSqDDxNBhNbKWz9GXVxLWOlICce3q/tho+XDgUGI2jdRUDxEYFCDcOj8ojM0gV3T8e/ayK24ONLSRNhsYSM6BSbM84TSzrF1Evxq1hjaLiCxtOX4GhFLSzefCQ6ibvFDQY+xsOOkMvJVF8yhKsC883uPrvRKIFNmwtEkti6EWxI0n0wT2ZuiA540ZRgpL4aIMb5UodMxEMTAjE9eQRJGUKag+cs3IyE4RROqnZnSLrqR3dj/AKG69DKmWCWN14c1xLbWcYll2fNHfVKVpESTnQrUWFhX2E+dc4H1qbISvmKM0cwSHYd3nVCzeFhJNAWyFTReMFAXXzf9CWwUQz7WmnXeiASp7N6yGL+kG+EQkO7N8EXe085dn6keT2ODm9dyt9PlwnPcaXaTpC9QH18p8PWpTk8ZvOFjRaGSeP1yKOJ88g4p26rUOEQv7Ionk0VB75sAAff8v4qT7Qel6EDsoDjb9X1rXdZM7TmVJPyda+W6dlH4991AxuoK5cgDyM5ETHVJ7myZL+4Cs7Dntrq8JrqlE4AzdmIJfdxjHYTV0+chOqA55Fvxo9nxX7Chl+mvbrzxRwe0MMb6eG3GQoPtIko2tkP//doP9ZiyVKuo+MiadpmO465XRUTd1n2h7+ZWIOOfwHYSN0hyMahzgdVgX2EstdKigtF/Gp93ziC062crJ3Fzs732ltAWdloc2UuQn3AwW/+3PdzV/tht40/my4FCr3jb0uYDaYiowmSs33sAggdeNrESQU+r3wLMXbBRYzjyx9I0FS/pVndo3BViIkcmDIy/cVCUvTHXuEkK038Oay7lslsdvTfoq3AuoDsLSHREDZucPLePWtFdfSQidKsuumVB9xT
 dqnmOusG
 CspVELv6X581aXEGsvFEyQWedkwfE9qBeZTFJQMRvASSJZgVI+U1IGdZL871uwY0dPb66bbdZnk8JN4hlVNdftH6VsD4SJwAN02g/sbMXdi6qqlD+UzaqbpWKj4xTp/eUwfn6O8f+MmSD00vwYJF3BppRlGwIuvHAzCY8YU5uNtn7rOSAHTnXroQJP0pcFlYYbhlTzSfxs4ydu09+cCBOttOYUyI1BIfHijQ/lB1LSFlEgv1OiW+MBbNdB2Ef1OpjncCVqB4Nj5e6sb/TfpVwxWJfCFKR2DszI8BHI7PUX2uzdSha6UkC5pmWNCVxpt3JCqxvGxNachMOwLW67ZXWfLvWwb0NV8pXeIeoqEgWfSV3uR0SKup1VUIWYCt4unVDh9cOLqpCqgPlJuUlUkErS1yBW0gFIdGsGjapzG6H92mxSgSf3MM/9pa3Z/1zGrj0FqbMdcqKQIA2Aeyi79feRXGsTW1W+Dx8VdFBzin56TiatdWjRA8ZFLjkLSOiIVVieSJ/INFStee1570tHT6wGkkEUwrf0HpMPgji9yFRbTObGTYF05Txh3XUybMdt0XMiVMa7qQgvJTudvvoJjoGc9b48Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

In many cases, the pages passed to vmap() may include high-order
pages. For example, the systemheap often allocates pages in descending
order: order 8, then 4, then 0. Currently, vmap() iterates over every
page individually—even pages inside a high-order block are handled
one by one.

This patch detects physically contiguous pages (regardless of whether
they are compound or non-compound) by scanning with
num_pages_contiguous(), and maps them as a single contiguous block
whenever possible. The mapping order is determined by taking the
minimum of the contiguous page count and the pfn alignment, allowing
graceful degradation when pfn alignment is less than the contiguous
range.

Pages with the same page_shift are coalesced and mapped via
vmap_pages_range_noflush_walk() to avoid page table rewalk.

As users typically allocate memory in descending orders (e.g.
8 → 4 → 0), once an order-0 page is encountered, we stop scanning
for contiguous pages since subsequent pages are likely order-0 as well.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index aae6141aaebf5..4acd1ec27604b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3576,6 +3576,85 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
 	return arch_vmap_pte_supported_shift(size);
 }
 
+static inline int get_vmap_mapping_order(struct page **pages,
+		pgprot_t prot, unsigned int nr_pages)
+{
+	unsigned long pfn;
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return 0;
+
+	/* Limit nr_pages by pfn alignment */
+	pfn = page_to_pfn(*pages);
+	if (pfn > 0)
+		nr_pages = min_t(size_t, nr_pages, 1UL << __ffs(pfn));
+
+	nr_contig = num_pages_contiguous(pages, nr_pages);
+	if (nr_contig < 2)
+		return 0;
+
+	order = ilog2(nr_contig);
+
+	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
+		return 0;
+
+	return order;
+}
+
+static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, batch_idx = 0;
+	unsigned long batch_start = addr, batch_end = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+					     PAGE_SHIFT, GFP_KERNEL);
+
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < nr_pages; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_mapping_order(pages + i, prot, nr_pages - i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
+					prot, pages + batch_idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			batch_start = batch_end;
+			batch_idx = i;
+		}
+
+		/*
+		 * Once we fail to batch pages, we expect to fail batching
+		 * for all remaining pages, so just give up.
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
+
+		batch_end += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (batch_start < end)
+		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
+				pages + batch_idx, prev_shift);
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3619,8 +3698,7 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.34.1


