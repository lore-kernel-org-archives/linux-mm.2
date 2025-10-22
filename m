Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE1ACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C76F8E000D; Tue, 21 Oct 2025 20:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1788A8E0002; Tue, 21 Oct 2025 20:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CBD8E000D; Tue, 21 Oct 2025 20:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E77838E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2C7D5A5A4
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:28 +0000 (UTC)
X-FDA: 84023936976.13.EE6B7D0
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id C27401C0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QJ50XDf8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUTWKaAwDcLFEMDYOAPCNVz4GAFYSZN3Yq9aKSos2/I=;
	b=6sBUXT71ThQgZp/0Qzv7cGu60Nx3RMfO1YGa5/L80bgAivFFaQVdc86KWKr4wIRDpq+duZ
	REyjXDE+zLfUnmZtMPeRrZigdh9BkeaV39+/sA4xfkRY3rhcTWqAZ95e5h3mhSOyC3MI2E
	heACyorMzKmMv+POEG9OKMrCpvukEAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094646; a=rsa-sha256;
	cv=none;
	b=7xQ+FOohsrUs4gwqHPXlqARZAS0dXfIpCk6cWXpXwDYXvJULR68u/n+iBRGEdRZ1uxR1wL
	yByN00WLkXSGQTOJSGuOFg19BW5Ui0Tt4U+KV6CyxF9wIgXlQG5a68GkvsmPgYVLo1epH8
	Dp0tFN0lr6O5eKePTIm1a6sA8kQRkHw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QJ50XDf8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4e8ab5c1984so3279661cf.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761094646; x=1761699446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mUTWKaAwDcLFEMDYOAPCNVz4GAFYSZN3Yq9aKSos2/I=;
        b=QJ50XDf8YfnLMardMj9focXJh+cCd9SoqxGNg96W4FtFK5WBZm9hF8WHSYOwgccd1W
         4Mox7kAJea5CampKrfpkuJjZcTPWb/12CamFuyyJJMigs1alAOg1V6pKAoUrSVgvdjwW
         O+fMuVOVWrDpfiHUlp8KwhvUTJFHGTbx+oaVvHYh/40OBc/PQ4tveYolFzwm1KIL9Z9i
         yG3M48w56WD5DjyLnz4XSXzDyZc+VUOR8VFuVSVbKeOTXDTiV4/WfLBW7Vo5incEpFQy
         SOmu7k3ZSQpGSbNPNIVwxVmk/M+RwxMqn0ueov/71EW+RHBlnXIA+Y0xfzx7tGGMmPSI
         EvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094646; x=1761699446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mUTWKaAwDcLFEMDYOAPCNVz4GAFYSZN3Yq9aKSos2/I=;
        b=ecT53SAkSmR9mCqqgT08qM6MVqgYu3djKHfwyDdgrgN58/4kzrEj/00pwKXLbsVO73
         q5mg3yo/fbc+/PKSRFJsWOPndvuFCocWm7bPSNguVvHZl2zJl27IFg7sJ/Nb0d2hTa1/
         mexj1Rw1TqPhoCVodCgHuy5VXeuHAwYhseRb2IIedLMi98GNRC6AqhwvbhSJCOfqpk4H
         o2Na8hC/cQhP4s2Tb+qmG1Tx45KSJI0m5mlRNRvr18WT2fyF8zse7cH1pzh1P/ucKsor
         JPYXnlRI2LHBUw2ijkTIkgYCXmJwhcjZO1FqLw3r+EMqD4A0HgKrjxnuNijHp+EXtqhj
         07nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKhQCT7ocDbkK9oVvDk4vLB/j5l+milv8KQ/ib5xsAnHBQOSrlOFsSirO3K8GqHgaSff3He6Y8Lg==@kvack.org
X-Gm-Message-State: AOJu0YwYjWPr6vuJCPKUAusyuGpMGY06AsRsgFBeUfjU7YIboGHIliSM
	JwhC6FcWHXnCvKEKxdITjdk6NyhnAa578J2v9sEIUaWRkQUI3gJXgoPZkCSV9w2pW3U=
X-Gm-Gg: ASbGnctK7y//0YNOsVPOEE73CrdCUuBUsDC8njt2CEVz9s824K/mC7izL4jvgAvXmyp
	+PUjl0WQlsh3QZzvYwhS1z2LDt/MKebtHFSpYgY3cr/MjqLK7SRYjD+dKtNVmFulzZD4tw/ARSE
	oHUADKoKwIR14VpJk3yvBQQkiLtOFqlorF456LxTLijzqb1CpEY/IoNiLDoeXyLiVoS4H+617X3
	FxWlk+eweali9n3oAqr/KRbkoUkW5B6KufyiVPTmfDhwjF3XnaWavY+xVKijH3tYTmLqyac+Sl6
	v43QrIdWtU1Yu9jWqoYD2vOuAUPOxWXG68/vGYoqP2WYj36fR4KiA2/plRbzsKPm6RE5RYhe27X
	BFd17EhYVqfdwJmlZmeyqn0I4Tq/3Oac4/C2kTcMGzBJZ1D+vTE2NK2fyE49rY2DXVZDfzVyHD/
	XhoQq4051Fkmck3OacD8ilf/D5r2Td1t7Vk+GFAExkaIhlxexS4//I3g1CIYl53kniof9uoPW3l
	9QCho0jkXb0ycr+K9h4bA==
X-Google-Smtp-Source: AGHT+IHQH5S7ZkBo/f+yTi+bMGIOL+QuMwmJCvKKYbXx1vIv8VH/9TwZ606gNIBVjYEELqz69qTPIg==
X-Received: by 2002:a05:622a:110:b0:4e4:6b32:697a with SMTP id d75a77b69052e-4e8b6e0b299mr139105201cf.29.1761094645817;
        Tue, 21 Oct 2025 17:57:25 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3432dsm84169501cf.2.2025.10.21.17.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:57:25 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCHv7 5/7] kho: don't unpreserve memory during abort
Date: Tue, 21 Oct 2025 20:57:17 -0400
Message-ID: <20251022005719.3670224-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 8nghazk7mqqkwid9c5p1g43d37oxda4g
X-Rspam-User: 
X-Rspamd-Queue-Id: C27401C0006
X-HE-Tag: 1761094646-800702
X-HE-Meta: U2FsdGVkX18Y4o323swwuoRfOHZkm5z6xTWAJdFNnHLJRu4U0W4JboU+WI7PzK5OaSj8BkEHEYV+++0Oxy7AnkAt57pVUuRydBSFNZgqiBAxVyBHH0ix0/cW4LKV4aDvk/LmcVPpreZwnk+SeFizkIkjiwWp7zYmsFlAPuRzhfE5UGHppSkO7pzQL41vyYWmgeyQxRgs78L8im8aGOY6jWLD1Xzquxd0RUgVkgwQfYL/0dWXcn5DTcmV5X8S6j+XFB1hlqhtOeeCrfRyyeX1qZyctwH/CGcT0wGkxwIw4cI/thxWQdfTJ26FqM5ABJMYk+6tdVjcQwYtVDRO0uZ99mdFo/IwntM67IFdhbLuREo/AY0qmuorPkhMOPqNfkwX8RLIIdNQiC6KpQ7hDTP5OR41KzG9vOGXw+jBZu4/VZ3NjRv/QhhEmpyeoaxlmTNc3PM60JVujkVC5GecZTFvzEHKXrm65KOP0dB0xw0PV/u3n7KtZvZYRb3+quAEx/gYkIZBhdCGgUJRmwZIcQ8kOQpR/IBAM198wOnJaSbQJRbacKqXGyEP3L7erkOU4CcREa6LyrpVjwNcJxKqK/5+M325eVsaw5DhMauNcHdjKfC6SgxQP1uRwdTGbYsFjrOCP4D+W3D+IaxydGadgW0I5qqBMwIBq1UAcDpNeXVGQm1fEcKWHzJEkBfmXBRXpEh3I7/MdTc2luN+74NmdHYPrZfo5iLSuexYdQ6d95+ue1AytuDMdhLbVqXMbxcM/9VNkwebEhEllUCCxbH/0aEmDdXpW+acR5GYxSNdVA8Va2QMUb/aXibs3cTAJ0H3XPwZ/VlWsyGyOLRd5NPyAhzG88cwFAkKComQbtXJar2BtjUo+gbuPrNSSo5B7CDmXX9deM23stwDzs+mhSfKme0F0xuMCN07m4724cOYXNTZJZdbhw6ybOpcEEl1u74FWNnvKjreuPT7+Q06x0j9DYg
 QPhLFNyQ
 PPkegY7NJK2JNA1BNuv+JOd8rX3S9wMTbQ80gDEr70q88FpnCgSJeRoRC3xZLY+0SETZh0cIMcrjxcSYFEcLl0Q0KSBmK8/NmfKMcsSr94Ad5g0tgN5Sv3jVEHpGaw2VS62WGYu2h/doqETkEofuChLjDoPDDXuBmfrSuF2Cfq5bmGumwJzFmVxn+v2BFK6v/iavo1AYrM9qXOlyL31y2EymZxwUXUBE4XLoX89dsSg0TixOYImjZ4ddOQggdnaCW8yZPSV4LR0+uqODsu5HF3W8wT8FbLdFNQaFO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allows clients to preserve memory regions at any point before the
KHO state is finalized. The finalization process itself involves KHO
performing its own actions, such as serializing the overall
preserved memory map.

If this finalization process is aborted, the current implementation
destroys KHO's internal memory tracking structures
(`kho_out.ser.track.orders`). This behavior effectively unpreserves
all memory from KHO's perspective, regardless of whether those
preservations were made by clients before the finalization attempt
or by KHO itself during finalization.

This premature unpreservation is incorrect. An abort of the
finalization process should only undo actions taken by KHO as part of
that specific finalization attempt. Individual memory regions
preserved by clients prior to finalization should remain preserved,
as their lifecycle is managed by the clients themselves. These
clients might still need to call kho_unpreserve_folio() or
kho_unpreserve_phys() based on their own logic, even after a KHO
finalization attempt is aborted.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 8412897385ad..89a3fa89db0a 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1103,31 +1103,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 static int __kho_abort(void)
 {
-	int err = 0;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.track.orders);
-
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
 
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
+	return 0;
 }
 
 int kho_abort(void)
-- 
2.51.0.915.g61a8936c21-goog


