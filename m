Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D1FD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD5E6B0394; Tue, 20 Jan 2026 04:19:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AD86B0396; Tue, 20 Jan 2026 04:19:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFC66B0397; Tue, 20 Jan 2026 04:19:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 705E76B0394
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:19:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 122161401A4
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:19:37 +0000 (UTC)
X-FDA: 84351794394.30.77ACFA9
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E50D1C0007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:19:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G374bfE5;
	spf=pass (imf21.hostedemail.com: domain of 3pUhvaQgKCEY0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3pUhvaQgKCEY0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768900775; a=rsa-sha256;
	cv=none;
	b=0vzawTOezUXW7H2khDq1dMG8yov5O/s1fjk01F+yJU2OwYifUqiiKt+j7pBgX4r36sYO31
	BW3FW+pMsk6BmJib+TG8WituzTaL7ZIOPft7VizCRlHbBBseFIMrS5IxTR/GULRfev2xrJ
	7M34UdRfbCo19md0mdZV8Z9y+gWUMnw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G374bfE5;
	spf=pass (imf21.hostedemail.com: domain of 3pUhvaQgKCEY0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3pUhvaQgKCEY0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768900775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AU5Nlg7dydy9DysYi/5+drcb7JZfuoXoKO5f+zthvtA=;
	b=aGW443cpA6qdgmT0IfTcokw1mv8MtxRnrIlZyC2FXWJh2kNb259wqiW4OKP145EzPQBR6W
	xOhyWxUAvXzVnJHnZoPU1ReyTeldpikWCBCwNKZZJuvHuuqwQknuj3Ua/XUeeGHjg7JSy5
	XFruGMp0JGCiRkimZebNjSPQwdxdkDg=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-432488a0ce8so4240783f8f.2
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768900774; x=1769505574; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AU5Nlg7dydy9DysYi/5+drcb7JZfuoXoKO5f+zthvtA=;
        b=G374bfE5P+m63RVDsv9xSQJgO3913BrXUa8eJQx88PpzxgER2xIpoqzMenT+3XIPU/
         gyMala6U1SQ4ZNItnsKp3ZgGlA6UVkLZrNG/R69Jr9uDhJXazO0esl2kfyp8KihsrDVT
         w/XJaSUHl8UKUdFCP0CoKHbqkGYeQpm+KwKPsPjCt3/C9Vr9qviFWf6bXmqRvTFONqwR
         97pFHePxvl5Q1BRMzgLbAdeWIKloI2Z33gcvbVvNoYrWkAySVXGs9G8+m20dfcAgLyDv
         Hnz6lShnWh56EZhQJikM6PFbJjJOc02PTMpQhLQen18bGsmTjEp/GaFdjze4mszAt/Mw
         FUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768900774; x=1769505574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AU5Nlg7dydy9DysYi/5+drcb7JZfuoXoKO5f+zthvtA=;
        b=fqMFxj4EjEzYcIKtFFdbWllIS0STiSsdHCSy4p+Nuuu36e0fCYnfJFFz5qGBkw5gJc
         OikJj17uy7KljGeRpJu0oISz30pN+YXYJ8iSY1PleAP2hFLalhYOA8rr4QEBsZ1yHqLS
         WTtillLqOXVMuWN/Fpx1KfqxmId8B7O1JduiyZ+w4psXYdk2m7cEZ6McwZay06peCrKy
         HG3hLzDnJEx9VinMeV6hFbNdci2i8zX8BXiGHTFTozx8VKqi9xzJeYe0p0cFKx2s6hpC
         B8J57cKD/+s0CK9zPG6tf6nxwaGnF3uD+w0gEVCSvOw90tdCPd2pVc9KKXWhUlKWH5zw
         kD/g==
X-Gm-Message-State: AOJu0YwXWJRUzdKWGfhv5Utam+6kUTTGCCCDCSw3b1VykVbT0rUaICkn
	ObEgWXS/YK/bxkjS5kQjYhW2bA/c8282ojvEdCV3cZY4Ex6923Z/vBLm3+b3YCUelRTgwxoqzES
	fJXQ8YsmD8MmLBC5v6ObNTVBjo7JHKQQM+XGGIBozbpI3qvG2a+TW+pgRvJ6AD3TDQirVrhdX2n
	lO8hSfTuq3kOVOroeKw1Hlx9ImqkPJhlCVLBLhmMl+Cg==
X-Received: from wrbef5.prod.google.com ([2002:a05:6000:2185:b0:435:8d79:2bc8])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f90:0:b0:42f:bc61:d1bd with SMTP id ffacd0b85a97d-4358ff62652mr1802129f8f.45.1768900773611;
 Tue, 20 Jan 2026 01:19:33 -0800 (PST)
Date: Tue, 20 Jan 2026 09:19:26 +0000
In-Reply-To: <20260120091926.670155-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260120091926.670155-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260120091926.670155-3-smostafa@google.com>
Subject: [PATCH v2 2/2] iommu: debug-pagealloc: Use page_ext_get_from_phys()
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E50D1C0007
X-Stat-Signature: 894szjc9q73kc7oxhhzsibpsn9ujyfbk
X-Rspam-User: 
X-HE-Tag: 1768900774-86980
X-HE-Meta: U2FsdGVkX18rp5PoUFnUo6d2zr8KpEzXXKZN4DtD62Gxl3GkXsbgEUrUOXMkoHjn3N+5dib8yzTTEml5fDNm+v8A0/VODgcx5l12v7BYifMrXq64XrMao6djAAA7WneGqMz6iZQhJXBgQwXqquk8sbvp1TfGzyEOkPbGOnTLbgGOucNdY3u2CPgQwRRf8QJHFYSDC1x77sVcHWDawnQgcb8/vx/WTASPGEyKGJBy9GrTUSinQlWrZjnLDYtYgoc1L+vsFn0ECqFw2twyJE4gdbN9g6ZdekBxdE7rZJG7uZXHDLhCVr33UmYxx0QGFGjOpnqwrVkapk9VXPVVvbYELsBO8hBQ+x6LfG4J/Qnmb0rgnkztDCJD3xHyKRJE0XmFTDfz2f9kS/77iOAxew8lQM6EVPubmGVTCVJ0R8dC9z2FdTlGeROx1F63GPbmr0kCQK8a+y2jdcKECpxk4xKls9Dd+mZdc+cySd6ZHN3NB4DOAS/BKqqMXbeWruY3wUzGsAPH/Gc+F+snOmLN45NaOYWEw8vtDzKg6bpFlpLqWfJ9SsEtQJa24lGNZdx7i18/6ZoaoJ4U/u1obkU8ZyPs9LJ9/ZzXi/OrJIsY3GRYu69gSlnqTCgrolzdl2HN3fwLljVmS5Kb69iSHPZHoQbctNs1KzqorqBSBRuwcRdZ37CloWempOUAqzCGw5T0DeluaV6sLOy/n6AkWgeyhV8BfN622/z2zlBoTKFPC9e5GfwDElaQ/b2jKDFFZYxBsqw1RZuN1e2V+JvrA3k0XQf7lb1LwdLGyremU5BB0HbL0wlnhihDup7Z3AY48tZS1BMtIwv2QAdCxXVBR5Tla3dJq6wMXggWXeGdb3CitOdyU3TUOW6UcR6hHdrBsZddE0m33EleXGmTbdOcXqtO31D7D7Iuew2D4wb/inNup6ZT4D7B5r3izcYVvQ1OYb9IDW+1EEm7H6qd1PdcpQDFRoq
 RLQnvFko
 UiKi/A/Qwa4Iep/FB4Oq71jyp6lV0BPAG1HzssplmMkC9gny1MPJl/LA89aVUAQj/IimBPce1m2sC3v4bBgJv3NrmVLaVDwXAwybUDnbOMKG8wSIztW6D+mHUqHGsPbEgxLYDY9IPGdHsvx3SoJNnpTioXRGOfmPBDro8I2oOrZBlPWMALlQRnoK3AA+zva5c/n2Q/36vuYiCaHwLfJhDU4PTXIVdsz6G2ovX7AymcbEfSo4Ofh5PRWBnfcVzQgoaKj3BIGn1GkAb6R9CKCr+EHg2TJMUCFCyO6TaddnTFy8x8CdoSdJ/3CTBXpRTyw6Kwa/1wowqLE0w+2l71mVNgMDJDwN0xe8Cbtjc2b1/Gz5M2jFWMQxXPCS+HaY5PwaygFiQGV+F9uOg0j9/OZhHCGK6tLMsV2ZhkeQzanZHhfWFRa63eh7gVFKonnnOJ8CFM0LdzHpYBHUDtF7APHy1kVsGPefiBB2WGFwBfLcF25TUNv4NKQrb2v8K3VBen+MKkugzmvpQNbPla/Rp03/ObqCUIYFAF2esjJlf7CXnQjBoCSM7/xTeTx7ixtQxZPAVhfnUuciA48S2MSmP7d7CwL9pwp8rlEhUnVhz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of calling pfn_valid() and then getting the page, call
the newly added function page_ext_get_from_phys(), which would
also check for MMIO and offline memory and return NULL in that
case.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 31 ++++++++++++---------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index c080a38f45a4..80164df5bab1 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -30,14 +30,6 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
-static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
-{
-	struct page *page = phys_to_page(phys);
-	struct page_ext *page_ext = page_ext_get(page);
-
-	return page_ext;
-}
-
 static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
 {
 	return page_ext_data(page_ext, &page_iommu_debug_ops);
@@ -45,18 +37,26 @@ static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
 
 static void iommu_debug_inc_page(phys_addr_t phys)
 {
-	struct page_ext *page_ext = get_iommu_page_ext(phys);
-	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+	struct page_ext *page_ext = page_ext_from_phys(phys);
+	struct iommu_debug_metadata *d;
+
+	if (!page_ext)
+		return;
 
+	d = get_iommu_data(page_ext);
 	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
 	page_ext_put(page_ext);
 }
 
 static void iommu_debug_dec_page(phys_addr_t phys)
 {
-	struct page_ext *page_ext = get_iommu_page_ext(phys);
-	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+	struct page_ext *page_ext = page_ext_from_phys(phys);
+	struct iommu_debug_metadata *d;
+
+	if (!page_ext)
+		return;
 
+	d = get_iommu_data(page_ext);
 	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
 	page_ext_put(page_ext);
 }
@@ -104,11 +104,8 @@ void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t siz
 	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
 		return;
 
-	for (off = 0 ; off < size ; off += page_size) {
-		if (!pfn_valid(__phys_to_pfn(phys + off)))
-			continue;
+	for (off = 0 ; off < size ; off += page_size)
 		iommu_debug_inc_page(phys + off);
-	}
 }
 
 static void __iommu_debug_update_iova(struct iommu_domain *domain,
@@ -123,7 +120,7 @@ static void __iommu_debug_update_iova(struct iommu_domain *domain,
 	for (off = 0 ; off < size ; off += page_size) {
 		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
 
-		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
+		if (!phys)
 			continue;
 
 		if (inc)
-- 
2.52.0.457.g6b5491de43-goog


