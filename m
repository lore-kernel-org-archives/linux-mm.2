Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3A0CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A156B0096; Wed, 14 Oct 2026 13:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC716B0098; Wed, 14 Oct 2026 13:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5836B0099; Wed, 14 Oct 2026 13:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21E6D6B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9714E4072B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:10 +0000 (UTC)
X-FDA: 85321990740.06.B483969
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id B7D5E40007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=goZe8rOG;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000688;
	b=G17oXqGEUrAvTTGr2kCXKUgacN8KfF9WfwRRmr/DGgz69Z9T1AiGcS58Z01JzJgw9Ty7IX
	mj+HOwZIM8cScFzsh66MfepGmeV8EXFjXosMpfe/TlVjS3+ja9I5AET4wEzn5AG+T6T3Da
	/kH4KQx3FqXOBrEUnMnNfxzhMRHj6gg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=goZe8rOG;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJbFkHFq6Y12l3Bi7MpiC5ltuWIc3jdeP3hN8D/FbRY=;
	b=xYlgPDT7/YK3VSYM5pesShwmD2FL7p7UtiQ14A5q/HdjFdKr5nFxn0TVnLWwGnFG7/AB1S
	vrNdtqz+PkN5qT6cGX7X4TVWZm7armPeYttR8w3arMCbi7ZhKCTWHv7OaBsIDfvcuqikdT
	oOPYX0o6+drkYaXlRzyEycH0gTpZNDY=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5339173489eso47954561cf.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000688; x=1792605488; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJbFkHFq6Y12l3Bi7MpiC5ltuWIc3jdeP3hN8D/FbRY=;
        b=goZe8rOGISrqEjuyhDBqXXoCkPO8te7gETIdekDjC85xaa+FLiGmYlKi2BPepI/nTP
         C7Lo2GohQRcu5EwlMMqXSc8l7jvPilkaMn4GC0lhUhjVVz3ZsnFCB6af8u54o9sldeIe
         d3O9qtl2yKjhHWcb8oqdKWec0ef+jdbYwZ4+kCOxO3UtR7yOwpTJp1qW4fjOt607gm/j
         lnLTkSUh0ojG8RXFVQ4nnv8Kozg59iQT1G0d38jPG53ndX4tosQkDbftb4uL15l29+CU
         RRvFfhF2OWhR1gxd7AEq/PcDaarWIWx9eXR3wLJ0MRRN92Un6Cz7jA91qDQQZa5kSZli
         HF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000688; x=1792605488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pJbFkHFq6Y12l3Bi7MpiC5ltuWIc3jdeP3hN8D/FbRY=;
        b=hhG8aQCftW2Zajhjld2DGa7Oiy6nTw3XjPn0GaUKaVVSaNh75FTcpp8oPY6Nu5hm66
         ez/322xckz6JAYnr5phA4uCPnxUCxD91rgQ2dlrJNqwiiMuCnESwH8Mxb2202N4uXOUu
         htQaNPUtsM2mBi7Wp+jFLwbe3fVBMa9r/OV+2jvUk0tFYBly07pk4vnFlcg7izMzNaFh
         DTmSmCNGNAOZOZAmbiJ1tsuE+WaPWWQmAnCJ87eq4cXwL3kcNDFCMqJcJ6XR6NFV1mHd
         IMELNRGCfhinl4w8fUHFvn+RteljzrZOZ5d3ODVSVeJlIQuCXTiolLJz33Pd8fjIRVFv
         /emQ==
X-Forwarded-Encrypted: i=1; AKwUvBw2FBM0z8O28ArsgQ4XNSOGhBXzZih/Rj02a+kyOf3wPbF4a5VE37mSSwzfdD0bWzLClCGpI4be5A==@kvack.org
X-Gm-Message-State: AFq9FYJZe8+XJs4CSe2eoZHaMvPMtCjhK/fLSuFy8v7fXzKjJc/cm9C3
	a917w5B1QrsuoOvU/Cy6dDhuKKyDFdcQUh/Un1V8o2pThU9H8rQZbnAYGpmAU6KYzprG2BZvLto
	ZmBkyWe0=
X-Gm-Gg: AYBFou1kQBhKgW4TPZ4kAt5omP+BQ2dRIwcUUZ49Adv/xGMr/2w/kfxA8g7voDNe1Z8
	tMHv9yuji6vujDKYcCvy0ZtfXiGF2MpRz0E4WkwaxHj6eyADD1oN5T7N19jPJNcYxkZ7NltHUdL
	KnbWk3gvnpj+egIgnqMSjcWyr9eNwcCphvOzvXd9agBubCIAsk1JlqI7HY4ozy7Aznn5hEIzdwS
	DZV78GDo08bOBMZtV3nBl02pIyXK9tig1ClU6uW1BCtF8P0tJZG3+iK4qw+/SSb7Oo1cR3qZ6np
	T3fWILPQAjRt5S+yCEbDKvrkl1LDNuFFz2g8XZfScKvhC3+LDA9yRRxVo5RRG6JiG93S89Bnv3L
	IB04QRJ3S1LzojRoytKTtnj7I2TtXeo6fR6dKUh5ZbBssHSbt5xqLjHMAFthT3lsRnQgSI5QobZ
	NwvZJ+DoPywl3mGcDyS1/I2XObga68pEbUeQkU2mzq+MST1/cW0LxTzK+2sw4BSc+Ewz7uXba88
	wahgv/ABVHs3ZvOi8HVXGZituvMzqz+Dt7lpZStwQxSHEHEcNXlL3DNXshvP617H2hH5wM=
X-Received: by 2002:a05:622a:418c:b0:535:a5f7:d585 with SMTP id d75a77b69052e-535a5f7f25bmr272204631cf.63.1792000687747;
        Wed, 14 Oct 2026 10:58:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:07 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 2/8] selftests/mm: check that MADV_PAGEOUT skips holes and swapped pages
Date: Wed, 14 Oct 2026 13:57:50 -0400
Message-ID: <20261014175756.2035176-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B7D5E40007
X-Stat-Signature: tmkukfs16qom66mox8sbk5s5j6f7bu4y
X-HE-Tag: 1792000688-142170
X-HE-Meta: U2FsdGVkX1+Xh/BSK8u9GbyuAanwE4GElEcL4XUC9nXvFl8l9XxPoyAp3r+xlN+c4Uc2B1K6LfaFHZ8ovazTgPyAqCsrxU3+McFJpSo9Bo+KnNRtsGrDbWEGacWKhI0WjRi1F8X543xbUciTalSfoE5r1rFMGI48oZ7dzSZ6+/xlQKKz/SK/oaCcH81DrUz/RbUzgMqn9USgtgeZqkeb+w9kaQ8E5t126IiIr75AokWh8hsHa7FfuHrJLxUV09y71QAHURqUeJsCDXWFe0cCwL9iEn6Su2vgIljGRXjkwfl3ADgdiMWHMrgfO4W4YGGFs6m7VtAiOKISS3PZ+YHA160FIphUMx70JSr+jr5FlLxuVqZQOizj0iCmqxdfzyg5mqxl+VIkR4vS0Zeq/cAhJrxFFaXLTse8oooLoCWJyXllMRRqcfJO+afIYIuAh7xtMYHbuacBkVxod4dix5ul78OBqRD2aEMcaLofl44J08LNbmnPgo1hpuAgv7ITWeJ5GmVAz83/H+6DAwSAHKjrZQCmljn0KxecrW1lSdgzW7wmvj5f01XEzZRKv66BO/5zEZvkMeKH927gPgDN8YZNEpxxJUVK4sAvE3XB1lgiSuvEC3m4kJfSfW8GDJCPtHFRNzcUdhPscZsqki76yMy6im9WU0Z11w8fXkKnEGJ9mLU1W6aVVkC+XA6+CXqY3T+GOZpzBadgiIAa1BSLxGGignzcZ8PCKQ5jL2JY4k4/tGLQSjFXjwDjvNZNKuJezhL7CRZQPCqzJPV3DaLyVuZ1SnpwcYmgiTBYl+9p584zgv7Wq0UYz4WbTJBzAPfczjniNIz9pA4YxNURagROFjVGt9TwoVkxRA2v/LzdOvdhGlmyOBE3k76IYY6sW+OB45kSCTBdGBpDfIlKGIlDkCAP0DhyqFxJGHtWg7gJiHozFoT54yoEKTalwJ+iZpmRM2EVNXkX594I7KZqF+OsrcU
 SR0UtFt7
 YgDl75dHVfcHsPhunKT11LI25d2X5pl9/bLcNHJZTfYn7NgpPJjGZpZu3i0ClN3S2IftESXZlKtNzKh83ZYhj8Ry/S4rJqS/amBanZuWZeNnxSqnqZ6ORv2wGB8XAtNnW0HT/Y/ImHhVj+CJoP93rrWkg861CW3Uh0wu8hWcEspi4kEG54nf2t4dOPrHbOu6pMJdb6dVf+/Xi2YqybLSC+/kOcqckyVAUhZ+DFNJtfFVk9ZvCHeH0Jq9frQdreDsgP+GJK8Ba7VKB4bGxhq0wo7R5DIoihdwoPZoekE6QeLJNh1u/MW68c3jiknUthzUbug2nAVz9CXTOkWyAaKQoiJrWEU47OFDRbIeq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The contract tests check that MADV_COLD neither populates a PTE hole nor
faults a swapped page back in. MADV_PAGEOUT makes the same promises, so
check them for it too.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index bb4efb92e6da..42cc08fe45ae 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -85,6 +85,11 @@ TEST_F(madvise, cold_skips_pte_hole)
 	check_skips_pte_hole(_metadata, self->pagemap_fd, MADV_COLD);
 }
 
+TEST_F(madvise, pageout_skips_pte_hole)
+{
+	check_skips_pte_hole(_metadata, self->pagemap_fd, MADV_PAGEOUT);
+}
+
 /* Neither hint may be applied to locked memory. */
 TEST_F(madvise, locked_vma_is_rejected)
 {
@@ -131,4 +136,9 @@ TEST_F(madvise, cold_skips_swapped_pte)
 	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_COLD);
 }
 
+TEST_F(madvise, pageout_skips_swapped_pte)
+{
+	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_PAGEOUT);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0


