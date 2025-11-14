Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72218CE8D4B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1128E0038; Fri, 14 Nov 2025 10:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304778E0029; Fri, 14 Nov 2025 10:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDEA8E0038; Fri, 14 Nov 2025 10:54:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00E208E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6426140428
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:15 +0000 (UTC)
X-FDA: 84109659270.05.B8B9E2E
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id F31D4C000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=auwvmuBp;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWYmoe6n/rjfMRyVwGOHWBt0L0ANxnxo2HoEY+1LNsc=;
	b=rlDJ4iOjeBSgizvJX7nlLBLSllRewCKvUcWWZy3am5qmvzC3lEr1iy5VQyMFZCKw4YIQTK
	T3pdaev3vFG/MLgfsiEzWy+ik05f20iqxh7kRzXEk/negye0QebNueYbtKxF0E0xd61n75
	mPVu7dfC4D1ezjSCG5TbLNP1kYNGEHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135654; a=rsa-sha256;
	cv=none;
	b=TgUAgAsCgbVFKy5ntboOv2MI6ZZvqo4YlAtH80xhEoDsvGSZ8GdOu+zHcVQdRzdpfkNXU3
	vsghPF4YrTps96xt30Q3M9LQ1ZyUz+iXSfdHuIL+Gy5auj/haZ2YrQKxe1j+3avW2rYUDP
	CcRik5zzUADWu9DQEsfChZyZ/YxhhaM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=auwvmuBp;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-787d5555274so22048187b3.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135653; x=1763740453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWYmoe6n/rjfMRyVwGOHWBt0L0ANxnxo2HoEY+1LNsc=;
        b=auwvmuBpPgowkOGzRxUwQ7nH/I3JseUELMWm1bSFi40Iu5WLnevoe82eZKqefMjYOU
         bxTKHqRLu2fLaYqZswDFL0IsG81G3EbIZa9Opd2bTWT9BTnlzYy9H7/sBL8LWEOo0kgu
         YRbtDDnr6ymADokak9SgYR3QFXMgzvkwrmF3bfcLKHH0iUNcwyWEqUJkqZNA34nHF3kD
         vOfe5qh9oNmdO7PvgDHa+8jirYcHT4BuSWyo/wHN0c6uo8wL62dVdj70+Km8tF76X015
         XgAOc0tbBEBWdOOn/g7rASS9f38YGdAjacGpplNIPchUGYK655zyXbOkH7SaLuHSTJg0
         +O+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135653; x=1763740453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jWYmoe6n/rjfMRyVwGOHWBt0L0ANxnxo2HoEY+1LNsc=;
        b=B/VdrlPgXVUEZ/ND+0/9Hsb9UhBZaC2NzD3EO0EceNQq9uTPEHS6wJytZvsC4mVxo0
         DtTqD08ETz8sIy7l1f/6bYRp1n6vh4Noa/8dwXo1ObfG+qVbGogc5oYTxT5Fm9sjJMT0
         uDCIhgcgCvI+3AcnWvt43R1cTHJjlvRhfNciR9KgkOt0FLbHefAajVwMjBpqNDHzdBkE
         4m1xQfcd8xTBHIDF2aobcEDqFEHAmSHXZMHA+PYfWFwPC/JpE+QVmGAFxmjJReh9ovKa
         1F6UE+GPFYsmLX4qZSL2KgFHjT+jY88pp9UST0Oo3rit4Givn/Mr8pAef/14W3seCqpn
         AoHA==
X-Forwarded-Encrypted: i=1; AJvYcCVnXY7bidjHV3VpETIWJAJLmmAImUZPP1ynrbFxjzjf+H7q86QMjkJf85FfuiGwO4UQ/GUkrN4sNA==@kvack.org
X-Gm-Message-State: AOJu0Yy8Bk4q2ant+VUPSo9FWn+RqtT1qdYM79tHCtqXK7w+mT1K3a4s
	JGG6ElT1WCj5VzaYIJTbMoN9LeXCCWMkiDbaAq67utcvdUb1R1+uKLdcTQ2McqEYiAM=
X-Gm-Gg: ASbGnct/Xc6Frw+TQ5bYXPASUYWs4YlBJTJdZKW5nFX0G0cy7eJknJEyG2MqNLxeVRc
	vMbAr4P2/tqnPu3SUhjhLiEabOvXFfy9DcMGonAMPZBy9vVhNHxu4WKPwDuR9KbGNLZDbnv2wxF
	+zPXxMC8dxtrLW9AQeubyvIVE1CjaVQEkB626CldHVw44oABqsrm7g83nldaVnwRMlPboUb1FCe
	4M0mzV1/mhltlkvSft/tEwzofENwCLx2CnPYIQQgdfa414LVbmRZy3WDZt6xjO839g4FzXhg70v
	cNxk9MqfLzUDJSo8NJlw7K0taQbBmHzR6VEN8mO3nE2dY1yfmxQnHwUow3voTMd3QwJ2eVDasXK
	U04fv2wAEmbxGvj9weZe+AETNp1syzbQm5UH6P7EvcXPfMO/oAo5QNubsHhj8ZH5PTphegwMJw5
	gUTuOOeGhT7h3M6FWksHvXxctNo4M+pbtCYy4293AuvwFFEyPEx2hdNxXrAKxgKCIW3C7Q
X-Google-Smtp-Source: AGHT+IGJaOAJGksp5OzW6VIWGJ2oj2MfQScBcshD9izy6AP7xHUYC50lOdqdoRgMNZveVGy2Y0wOug==
X-Received: by 2002:a05:690c:c047:b0:784:8994:297c with SMTP id 00721157ae682-78929e49844mr28762387b3.24.1763135653040;
        Fri, 14 Nov 2025 07:54:13 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:12 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 10/13] kho: Allow kexec load before KHO finalization
Date: Fri, 14 Nov 2025 10:53:55 -0500
Message-ID: <20251114155358.2884014-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F31D4C000A
X-Stat-Signature: 96j9myxn9yy8m33ehox7us8hq869oy4g
X-HE-Tag: 1763135653-178596
X-HE-Meta: U2FsdGVkX19JEjrKLSxGSPyeezeAHCv8HNbHadoKjbqR0Kz6yoKorRplkDH3EycrXuSOqMTQu2FAcXaoA6pWnk4eGqP+9XYGp4Oh0/NO/pmu1mtlKrlUydbzNLK2hjAv5GorLj877okqNAL53LVuBnp7hoO6LxJ/eJ4Tvz+BeppWxjoBE+TDTAyC8y1Gh5/0QS4YvpSyeQfcACCJgB5EdzyXLERYBNBM1WKtc6GwdJ6wkpYeQGcnN2PQYTdHI+4eG1n0GinPfGHkEWVQoWmKzTCjpGR/nS7XT3EAuZK1+eAZXqcEdyZmUUDy1LobTrtuH1p7v3korJXNrDeG9hPBT17Ncambu19H3VbTH1dLbKC5TY9BHa7Fz7iunpVQuzlY5ekQzoNfAXmpQ3mSV+aulCF0p517D7ly/GHXO2ll1XZSQh/7T0B75SNkXQntMuKJDTZcaxTbRjDybvOVHIkbirLeISyaCm77ACkUvMNc4KRbwzsVck7FN4KusuVELR7NZlG1A8VfHJ8lmkCfBJRmDI4SBZyrTuGjjBgRsX1/Y4ozNdcPVES2eaarkZsk+PB13eGTNNhsxPQ9Szi+CvilZo3G2Jeaxxp873jl+C1jW7gUYIhRYuCIbqkdtnwi5sPAw0GzlvtTqd2V8FaizFS7drM0/cXsclgxrc+n8jtLnyD7NA0WRD2fSnWiMU9QCOdy66zIvYFhf1RUkX/+UuTkYjI81VmzZQdPkqvcw3eEcBh2q0DLaG3Rc58XmMGiicwMie27niTUq9OrjbQGahGxGfNqutc0SuRH82r32rJAPQcnHLgmBYxmVdc6jz/fsmAYibTGdJdlEQLkkemHP9Om90puQ630yva2uLKTPUcPUSUvmmb1bZ07D32FnVlgb+sKlSl6KRgOn25S4C60W28KaQ6XcVlhiocOPznh0avuV7quDxvrSLndetklUyVB4QAY4G7sNegkqOIRqtckLty
 cmYW1uU3
 LnZ8+YyEU9epUJDlfivogp14SUGm0ezZjdFGQOaqeGhKYZBXKwLHeCMvrQ+w9hxkUVrRs3PUmt/x4bSy1fc5tf0sfvfY2UIeGIUc4qo3SMDYeFX+eLYmirjMLz2X6JWaA1Tid0CmJpcKO5YqcA96BjJzl8+NciBVsi/rYSRLMLR+nin5DCt94fCUU9VznWO+nQsk8dElv3w1CKAMxJBqSgBx1S7ngvD0+/DA7SWy7IB2u7lbYjlAKI9V56xYV+ZoCQcGyJhTx/OB+dY1bEF1BgAjLt6ZSkueDpvCW/bwmlgIOwNCEfUEvPtb0nwd1ZPIPFp8FV5tIa9x0y3gxyKRSA+lZzeftVK6QNyO4CN+CA1BWXgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kho_fill_kimage() checks kho_out.finalized and returns
early if KHO is not yet finalized. This enforces a strict ordering where
userspace must finalize KHO *before* loading the kexec image.

This is restrictive, as standard workflows often involve loading the
target kernel early in the lifecycle and finalizing the state (FDT)
only immediately before the reboot.

Since the KHO FDT resides at a physical address allocated during boot
(kho_init), its location is stable. We can attach this stable address
to the kimage regardless of whether the content has been finalized yet.

Relax the check to only require kho_enable, allowing kexec_file_load
to proceed at any time.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 822da961d4c9..27ef20565a5f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1467,7 +1467,7 @@ int kho_fill_kimage(struct kimage *image)
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_out.finalized)
+	if (!kho_enable)
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
-- 
2.52.0.rc1.455.g30608eb744-goog


