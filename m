Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 019B9CCD183
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 03:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47FB8E000A; Mon,  6 Oct 2025 23:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2168E0002; Mon,  6 Oct 2025 23:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74C88E000A; Mon,  6 Oct 2025 23:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96E158E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:31:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 471D282E7B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:15 +0000 (UTC)
X-FDA: 83969892510.28.849884E
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88406A0007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RwfJB+Bc;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759807873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7z64stFRl040LRM1yj9RgVROnladG4B1zFYyNLh4mpw=;
	b=lcaXPP/dJ1zt0W/JvXY1U3M65HT+Lh/seEr9y2MxGo6xA9lG5iWi45KwKSySkwiKCpY6tv
	//1iqIukRJIVrrTJhemNcis63z3dV+BUaUxDsZAX+1Z/Bf6Ju6Rid8or9E7h2t229/wBIr
	Kdf+Qnq2YPJgYeHDGBbw90f9WMA2p6g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RwfJB+Bc;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759807873; a=rsa-sha256;
	cv=none;
	b=JLFGJtbWbS5IDtpHOa42sucWJpYJ4vQeOivRChRK9LGJI1tXmQYzgARZre4D0HKPIwQka9
	RgGHenTWIFkX8M00ZUD56inhSA1kZ4CKGT5lGgeSIEU08vt1ECLqR/EmsWlraI2OxEOEWd
	cf1nithb9Iw2s/1vxEGVLxPalvqFRP4=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-54aa5f70513so1620269e0c.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 20:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759807872; x=1760412672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7z64stFRl040LRM1yj9RgVROnladG4B1zFYyNLh4mpw=;
        b=RwfJB+BcFZZrW9amaoRhwEKUZ+wKBTFu+mlSh3NJoD+9Ge2/VCQQRO5bxR9ork5cD7
         PeFaO5vZ2kNmuNCmx0SyDZUcGD6EAeqGXZFpbqbqeCJDF7SRcTjCxgZGB+IvctNX9y9I
         EJuqVD2vO9i+aqLJdlCGS2r6okRIUewuohf39fybsPY+xjWbRDxBWrxEZrVWOyXDQTZD
         FtHEsDWUxKhx/vHqrUP3BEKKqgdtYGcmqGub7d1ENUQ97obceaiQnwEpxvkeNH7J41ck
         XzF4phOIwbQG5JPLncgLd3C/YdWL7mXR6GXMm/xnxNquFNRJUiQlnnAUNLpQAVFNW9rc
         B3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759807872; x=1760412672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7z64stFRl040LRM1yj9RgVROnladG4B1zFYyNLh4mpw=;
        b=DEnuPNRljMzIbTB9j8m9QoYgdX4huhUUK6PrkikEsiHrM2xTRIcVh7j9UXpb1Esmbe
         J40B+OJ2jDvY5TOuuETIZDDwMRNhpk7zEA3+ekI8y41bKeh4iFfCFPFiupNt6qa0JOkd
         H0SfbtkWvIjANGzfcST8RufF9DGOMlU/rp2Bg2G3XduISdMXi9dU1ETBsj6w7XXsFHkL
         5rrkdPG7SoQMp2BD4E/A012Uh764fxY6CZXtj1m+yGR/gxdzeSnR2mfD0hNb6sQCxAIs
         bK0smu6rhXIPXkpnLL8bJbfAIepZCbi3WntTNQBO8Tk0pbWLHSQkwr8t6cEaSyrEIJNF
         XF7g==
X-Forwarded-Encrypted: i=1; AJvYcCVoXUPl4M9JnFVbCSK69sHjk8TH1F6VuOM7amJEkgmyCnP9EgXBLUDsl2m3z2hmIIuaMhohTm3bEw==@kvack.org
X-Gm-Message-State: AOJu0YzsoXNUXd3HULW5jIh/edMcD4gzw66KGH3hbgbtboBnpkW8qoX6
	5WkyIeQIesieJhk/2lHrpaeBvPDSc76xKtQFkFNmT/DFnJZGbk4ZVcDC1T2LShxI4MM=
X-Gm-Gg: ASbGncvHKytJR+nizWu1RE39wbrN8ecZ0x+Wbtr9UN4AxOzfgMIdjDOFzvhj82HRcjm
	Q3wSgtK8w6plCS5xUTVX4WFvd1kz8fj+KpQOKmWPkTpKcM0Hm2smKs10uDf+virySYKLyHKsCDQ
	P1OQt8x46f4+or7lwYPAHa4ejvPjI3Rw8B13JJDUeR/YNxvPHPOcxXIPSwlFN24kh5KvUP7ttjE
	ZaG5/5AHc/7c8/x2aPiK38s54tU7m905KuStpvPU3/Bw1uqR1PmIDD0dGo+sHt3Pi8bS1yatHfp
	TPQbLKr0dQfIczSRF16xKFgOv2/I9oP+dkWUtswTiiexs6J8S2bFjwDd+ds6sfSdMN48nr/sJQy
	xdadGLLXqb4smAiOjKnSXqRKlsUlMtaXGv9DBSXfB0R5oNmrYAKVXrlxBfdl92wAnXRKkd1QyMX
	twNUW3h0JcBRgAK0F53q6TRbPJbYg2BqU=
X-Google-Smtp-Source: AGHT+IE4EXqWZRhl2HTUQHS0IRjtbgPekpf92eZABSKl8jPdM7uErllIFBlkrwrXfARb9nmkBXCE5Q==
X-Received: by 2002:a05:6122:20a5:b0:54b:bea6:a226 with SMTP id 71dfb90a1353d-5524ea29092mr4456170e0c.11.1759807872536;
        Mon, 06 Oct 2025 20:31:12 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-552ea335f07sm2446030e0c.15.2025.10.06.20.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 20:31:11 -0700 (PDT)
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
Subject: [PATCH v5 5/7] kho: don't unpreserve memory during abort
Date: Tue,  7 Oct 2025 03:30:58 +0000
Message-ID: <20251007033100.836886-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
In-Reply-To: <20251007033100.836886-1-pasha.tatashin@soleen.com>
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88406A0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ufkp4s3auk13w4uch15k1zgjmnaju9ht
X-HE-Tag: 1759807873-711426
X-HE-Meta: U2FsdGVkX1+gd9icNnchcz2DPfQuLMCrP6Rtu+7/05/BuBSQgdKtQouYz3xDIlixLudbGm57lA6DCsYhROorPzzeB1NOh5KM+M+TPiU6k6JqdBGn8eOpanGv8X5ECNASkfRDA3kMW5XzUvQztpfNQmLtXb3ueH0UReCJ1xN9M1HLiS4wYdM2SKDgJS1HAdMJKvnYcRGa+jaKVj0UJjcTPiyOA8DpEVI7ufPLVA7IzBVuTZXaNRCdNqFw6XQbc/+PrJM683fZPoJXK75ykX9nN3ObZGn02EZhLrJI828pXpXDHm+0KpkKIxhJO/q3n2cwYco/nUyrpMUn9/g4jEIPY3OoZYdQ8U+JKTVsFPgaS2JF8RdrwkFXMzkIjj9HUUjm1OROlhTZdS9dsRjWXAE7loCYb9e+xp0rkhlIOObPIDYJOFTVEvBNMGIDWrNgbqFKrANHSBdShxnGZVMQ9Dttlo7SLxrpAaw8kRvJn/44V/aiL3+yxv0CdZE4PBMGgadUQk9ON3sHB95qpdjUxZj9qJTuHeJhVnx9VYkM3zQa6kSxgJGDNhQWsYW0J0AFcb+z4heF8cm6HxYJ+zxw4MB2yeVeL0nXJLKL6PCXbYtFtotnbSXjlMBnIaIqDC0ReqLXhuaAAZQlSDS6+n5LLI+vm37TGm4XTvvGM0iu5k6sac5MRZjkutyO8Zwx/tHFwmj4oh1moPe9hE8YemtgFGoWtTlJ6NWpJANY5sWPpUZf6/Y8UR5lg8B4s3dRDZ0F3UkfJyzPYYKjwwtPAWwR+++T4jmgxEjf/IJvqPA5HtssBFa1p+/5hawYDLydRKzJCpLAEwBcQL3rdmJohg/mBEaObmI1CCHbPxBVa4aQubNAbBdCZjHmHpJmfzuqPFZU+FmgnMXHAxPN/DPVTqByW1RTqL6ZWmquxjwFj3ROvVeDTHMUT6sUZEgeAzqxvP28sAd2cQ3GD8LdBWwiDpNyj+5
 DbrIUfP1
 Bt1kr9ArFP9xkz/tEnmJKAqGoew1I/sDECluEDm5AlS+WDg4kWpI+WJdMBClj98aMc/7u6zJFNnrgnupuaSc/l5Q8jTbT0FwiqtOLOFdkYCDQY1VPrJwVAxwiMMbw//Kb1BFJy4IW+gvwvma5L40oQclEfIrlWD9i6DEzH5LVSbg1MvHuIn/ksvJdvMqOGPVrzZfSYopWWE9fCj4uLHkvtFktUBoX8JQYamPdDgFwv1RvFC1Wbf84cU7LFoonG8ls5lqJ6k/Ky5SRHooSlEXdfbgx5ZddfchxP9TZ
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
index 77fd7dd991d2..902c30feae09 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1083,31 +1083,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
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
2.51.0.618.g983fd99d29-goog


