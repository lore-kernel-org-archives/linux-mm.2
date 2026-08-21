Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70E5C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A846E6B009F; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CF06B00A1; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998E26B00A0; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 753F16B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11D3D1A03CE
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:40 +0000 (UTC)
X-FDA: 85124847360.28.42ADC04
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3CFEDC0008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JpgEkXdv;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSbfStPdbr5U0zykVDsBNKewNVAMS5oNdmlQT4Yzkm4=;
	b=qHwPGaiV+R3y7Gk4wnt/5JBM/N5pTb+4mKDvMawaggIqrW+fsLE7+HEABcrAln0pM0+p2U
	CV2touAerizWbwcSgeitBjzIl7+eN6rpJxbbDzxwt8a7/x0fJAeWkp6tPftezD14Lp/RNZ
	sR0ZadaG+MwRZprjz8TjEYNTnXzbz94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306798;
	b=5LpvYffBg/AVm3Iw5BUz6Y1HDMQkST+wfUUutsv5zIW4eEzizF0lNwYoXxFYr++rVGXHSj
	hhm+Bmn1iGCkNbgMTzxGZoYQOI2XIVr7JE7h3j7G3B+hKzFPJIxsoejjXkk5RNl0ZSXUMt
	Q22TMnATkowyWv6B1zrmc8XesKuvE88=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JpgEkXdv;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=uSbfStPdbr5U0zykVDsBNKewNVAMS5oNdmlQT4Yzkm4=; b=JpgEkXdvDryDyqfLO0w6yqBV2Y
	po9ZYmBcuuqI6K+8Bngw5grb44nVueQqJqyMib3N12wBXWSTP3kfjJpViJ/KqsWS10+pKLtQXroux
	3zs72OdNSfraFY5tvnzRIMOPasTACbKrv7irFHssTWRMwqkrZqxqF0MgtrFDskCuCuzMiWDGyv6n9
	11trmB9cEpvrFyXbSHx4T5gRUqghgL+4kERDaojynRBBe69+Mh5YZDRTMfp6hEMJx1f42y+Cp4faK
	Ve9zBMAX0DYXQaEPNx1lahDGe0fDgiLNriggWzRHsW40wDi10ol3DFJsI0eC7vYI9TeACJDS9Xezb
	OgZtd8zg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM8p-00BGBE-2w;
	Fri, 21 Aug 2026 10:06:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:01 -0700
Subject: [PATCH v2 1/6] efi/libstub: add a helper for the top of usable RAM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-1-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=3412; i=leitao@debian.org;
 h=from:subject:message-id; bh=zsnCaEJjr4WDYRVIG0kIJ3bs7R9uvNp2xzudAoWoA6U=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMa+W8jcyD0u0SyGOn1kbwZALutc1lA3Zhhy
 qAmTakDK4KJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bT35D/9SVn4DqMGqAj5kaAZRL6R7KVMcpYT4xdA1bnQ36xXLRr6PlPIy3/U/Avm8oLzAWW8h0/T
 dSpko6t2GqNkpZYSY8IuELnOGbhlzMtTySVLrEXxcH4gCWWYdxgetVxBTgtJj+9bAiLd3dUhji0
 hg7W+VVaskZGhLAenosUqpF3/mwgIO8JWuf55/DrJj9ZY05EBcaU/eWyyZqDvRNX9ENWezAHfYW
 gDXz2Ib7cyRJSknqb1J0FAFM+xUaiV2P0X0wq2+jyk0COyMd5wWOAMGUc764hQXhmEV2MlVr+Qi
 LXWEpp9encGy7VnT7uDYRXg8kWsAK/19ivwcBlYO+tuXOmRb7RiB+OkURRv2nqb7Azd0XmlItJn
 CvbWlmSOoS06/vNZhmzAIFuJ5yf8tZaJEmEkuRa1q7MMcNJtIdA0YDceKm2kt/bbf+hoDgqJz2K
 qNYqHn1BWMoR4VIbM+ZrpSSTAr3OCpuXF2le6KrbP0PHb+SG1MPSGJTPKIr5TMJAUR+/jrX04xV
 9WUeW4FasYe5O9C/izHkbKCql1JrHv2/q2cUPN4rCwjPhPW9QA6eVgETQ/8hXeAf7V/YxYojrlY
 GkMu0GuBk6f3sfjOtJfAKfXRyVu6l4ljhLKWQ3v54aBtxVD8PKnUSLn91ZD6FH6E6PwfWdVKIYu
 kW1eajB8O7w2lFg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: gux94fqci6rgw1r1816etwri5p1rzmer
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3CFEDC0008
X-HE-Tag: 1787306798-380234
X-HE-Meta: U2FsdGVkX1/e8pSmhZBGDQ22h9TUU4UQRA3yXL7o4cgR7JCiUPEA2lsyYx+3BI6nu/0U6JoqNydpoqnW2UW42B05kkTjeRsW9XTcW89yYT7+Qp+td7iwUcWUHu9aodfu2uRXSHuAFJszDYIPejPNZTQz37TsCv4MXmIfCg7YC5+VOI3dpCuUUdRwuRs/W+ZdQkZWIatuxf54L81FYmM3oyNxnNlgvwQumygcqxB384SDO11pUqDipDPs+NZKXryhq/T/vWBOElB8ZhHHh728rLhSQKZgibww/LV1SIRxnWl0bml3skTMmchSMIfsXfj6D45tbUf7J4N/YwuaNy3AYbq6h5yweuTwx2X0+qBiLaMHVlGrXU/D3XJJvlqVESKbUshWvf5APRHEHHQ3/ZFc20GKy0L1hLus1Kx+duf5hSiDP74M//CwQZFzVIrmqz2IuzoWa3fQYxn4rwyrKY1YgfAx0h62rKLM38MUuiupVeF86QikOR8g+/sWKwxLuh2ty7Xt/vDJKCAbSrMGx0rbxW+1ja6svPiV1LEY/N3tlutg7nN4chO+XLSgxO1BSfZrvGFuMoDW1XXlXaZCo41kuBOeccVEJhRhSWtYxxUbYWAK7qHmdqMMhmKWdnmyEY/k3rfPEPu975P/jZgt8lQ9tV9OU+tJX+EbstIYtOrF0gXNjN5J911Pu+yR/WoR6qBeZiycolob9IKFGgFXiJV3EbKyC0J7Q31V5rSa8iVPqqkZqOIdQCpUdVDQOW70UxBkHSDJT4SRDg71qBBPVMsI8FkrZEAoqeHZ4kc1mWk/gqPynSATegw8idsjf9hhpv2CvnBTLUacAbqI2/MVJu+QGh9PHI0Jg1vYLBhsz9+uMGb7wnLlMG7alOZ4kaJuWB/35IxtQJxLe1rZlwdgjWQd5gLps1npqnnWEQk6pxP6VjWhl/jhZl+Z2NlPfruhXD3V3xZS/nZvpc6m0+QqnCS
 3/6R2LAy
 EGfY4O0uGadU/5w8ONIdszB6PZimm83r1uF5+2LNAgNaM8uRV+MWsHFw8fxHqsB/yC89wgGaR7ve2wL7M7kMkv1nt3vuiHWJYf06Vhlb+or7/GOUTdnFzhktCMTfTHiY66po6vGRYzIfHWqRGLmIErnDiToH9LZeq3uM0ZxilJS9KDFbI5GtifaoxH2xI4JnLye9c+0FZeI1IgyiTjC0N53BH13jh6SdI2qQjizU1fFuXiK68DaBtO4uRU97GopznkGTPfJA1f/7idbIJOy7NJD6fwqj4ViinlsvGO05Htcb//5cCbGud7A76Wc4pbaCHsitS+O0h/jidYnh2VV5zzNO0Gq/A7bulL87Saa4bBU1sgVcdSJIEnPmM+cVr9+LYjgifZ5lf9fuDU81SAYI94nmEBo3Bi+ViNhRg9Bz7AAKUKQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stub has no way to ask how far RAM reaches, which is useful to
create a bitmap that covers the whole memory.

max_pfn answers that for the kernel, but it is only set in
setup_arch(), long after the stub has handed off, so, unfortunately we
cannot use it here..

Add efi_get_ram_top(), which returns the highest address reached by the
entry types that become usable RAM. Unaccepted memory is counted as
well, as suggested by Kiryl.

Memory the firmware hot-adds later is *not* in the memory map, so it is
not covered; that matches max_pfn, which is likewise the top of the
memory present at boot.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/libstub/efistub.h |  2 ++
 drivers/firmware/efi/libstub/mem.c     | 53 ++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810..77ba576779aca 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1094,6 +1094,8 @@ char *efi_convert_cmdline(efi_loaded_image_t *image);
 efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
 				bool install_cfg_tbl);
 
+efi_status_t efi_get_ram_top(u64 *top);
+
 efi_status_t efi_allocate_pages(unsigned long size, unsigned long *addr,
 				unsigned long max);
 
diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/libstub/mem.c
index 59f3f83de50c2..777f1f180c66e 100644
--- a/drivers/firmware/efi/libstub/mem.c
+++ b/drivers/firmware/efi/libstub/mem.c
@@ -64,6 +64,59 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
 	return EFI_SUCCESS;
 }
 
+/**
+ * efi_get_ram_top() - find the top of usable RAM
+ * @top:	on return, the end of the highest memory map entry that becomes
+ *		usable RAM
+ *
+ * Walk the UEFI memory map for the entry types that become usable RAM, the set
+ * setup_e820() maps to E820_TYPE_RAM, and return the highest address any of
+ * them reaches. Memory a confidential guest has not accepted yet counts as
+ * well, since it becomes RAM once accepted. This is what the stub has in place
+ * of max_pfn, which is only set once the kernel proper is up.
+ *
+ * Memory the firmware hot-adds later is not described by the memory map and so
+ * is not accounted for here.
+ *
+ * Return:	status code
+ */
+efi_status_t efi_get_ram_top(u64 *top)
+{
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
+	efi_status_t status;
+	u64 ram_top = 0;
+	int i, nr_desc;
+
+	status = efi_get_memory_map(&map, false);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	nr_desc = map->map_size / map->desc_size;
+	for (i = 0; i < nr_desc; i++) {
+		efi_memory_desc_t *d;
+
+		d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
+		switch (d->type) {
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+		case EFI_UNACCEPTED_MEMORY:
+			ram_top = max(ram_top,
+				      d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
+			break;
+		default:
+			break;
+		}
+	}
+	if (!ram_top)
+		return EFI_NOT_FOUND;
+
+	*top = ram_top;
+	return EFI_SUCCESS;
+}
+
 /**
  * efi_allocate_pages() - Allocate memory pages
  * @size:	minimum number of bytes to allocate

-- 
2.53.0-Meta


