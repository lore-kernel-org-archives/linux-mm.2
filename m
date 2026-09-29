Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E470DCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E727C6B008A; Tue, 29 Sep 2026 00:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49716B008C; Tue, 29 Sep 2026 00:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60176B0092; Tue, 29 Sep 2026 00:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A73D06B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:03:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07C10803D4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:15 +0000 (UTC)
X-FDA: 85265454750.23.F9B064F
Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDB714000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=MibuB2LS;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf11.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.214.228 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1QC7xolz0zAjMGBpXSuPAgwwtLmlzIMyVrA3dvqh9k=;
	b=H3rfiHrsGWhrSmcTl+qSrTeAIyvZNPN/u+WIGDQnjJawsrndW2NWkHmDLt0aYALhUpd3Pp
	a19WHsi5KNx+A4zRJryk8WuFsIeF+aADg9lIEjjqMmA6yAsJhM3g1DPDN2QXTQEPEEVDhr
	MnuKH3qrxxf2JI3wddRUmK0FWWfytGY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=MibuB2LS;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf11.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.214.228 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790654592;
	b=NfUfc8ISpXWTjUK+LZBzfddTAR+/xbRVGEl+It/hjCzPiLp8k6B0hJSor2xUAPwO7vkk69
	ksxAz8Ve4jvMIDxrtAJe3rq7KQghhoL3UZRNaGZ7I0bfxKCHtBm6F/9irH0NMfv/zxThP0
	4cAaPLcMpgoIFNTaXcCzL4/4ue5v8SE=
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2db80fcdf8bso14566685ad.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654592; x=1791259392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H1QC7xolz0zAjMGBpXSuPAgwwtLmlzIMyVrA3dvqh9k=;
        b=QtdHYGO9yclNpUJpTJJlJ8WZwx6m6NaUT5pucvw0y4DqNg2gwfKjxIYSbhapgxHu4a
         q6ql1to8F2fJ4oDmw0R8yP7IvyU7Hz5mK6F785d+/m50p3VFY3uwM+/5JRz6WCqzylrZ
         suFNX39tMMjMkEIi1uBvzl6g4V2xN2GPbV1E42S4i0sKgtam4pSFShGR2rl1xRGudZ0i
         HWVcFWbmgbBiC552r85/4izAakjbf7ze9LKHpmkVkc+m1JMPfX9XtSJ0JwwfPPXsxC3S
         pnz20zarjdts/b/LqVMZoLWXUT6DyjvI+hVrGBAw5uQ/msQJpqDGJG5/S8o0usgqgyxA
         gaMQ==
X-Forwarded-Encrypted: i=1; AKwUvBwyHEU6pO6Q9houmv8lSqqd0myw0p8CubSvLIME2TFBwbETZ02z8cDDBNnjo/q7281ImK9423OQgQ==@kvack.org
X-Gm-Message-State: AFq9FYIM0asB0Rog2RDmTBz7NztNUtwM7X6iIZ99pgX/w/dys//499BO
	OKqWgNrqFukRZSbFhj5QjWvRczN79g5heNUWg/VDKYdrZhnWjUJBqty0gl3tS8mIhzcVYDO4ejV
	mQkbrXlcCjv1CT2Lgv+o9dyKoQ/+Iov0ZxW4vX0KJ+Gr2G0ys/OfyNOPfYoDEFUcYoIEnf5J82u
	QMdv7ngPUX6cyYS/6QVNYIs2e6WebDEoK03Y3CZvH7wVVcLI+SONXdGH3IypoAXew9Kvphl5jVX
	mg=
X-Gm-Gg: AYBFou3mm2MH3JSnCveanDadjw7E4HM5Pzk6U7UdZJ9J6fI3grVqeLbdOHr/h8n5W/d
	mvIoIA6eVD3jVr0uIsvngkOZO47wxyU+yedRdACnif9vev/iJDmIY/0al73k7mWaWXxYXAGnWQI
	P1BXi0wGInzPdcfUyRtcPoDuqy8HmW9qSbuBxelmFQe9qRvon0LoUq0biBLnZ6nE1rUrwVyPLoY
	HLrePIyjccBPHaeBYI0IDNUj61Vq/AdMYH6MYoVTD6QFXYe00oyiLZeXMafKTv59SaqWQ1wnTdm
	KrVppBwwlnpiaNwz3bSSpmgiELYdqjQz/ktKpnlGxvPC99SuQNJE1/CHnbfFJu91R5BGPle0pdy
	AIcFc8Ia6fW4/XXsveMcsxiKd+CO2s0e/M+YjK9OtLfECAQzDalcNEyylt3/hiFUKOmJnAwnttx
	1MdEnwTIzJBBNlcC3nSujqIm1D73JksfmrDwQ=
X-Received: by 2002:a17:90b:1d49:b0:3a2:b036:ed64 with SMTP id 98e67ed59e1d1-3a2b036f457mr3158705a91.39.1790654591533;
        Mon, 28 Sep 2026 21:03:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a4a69271desm146454a91.2.2026.09.28.21.03.11
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 21:03:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-342217d8d53so12162269eec.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790654590; x=1791259390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H1QC7xolz0zAjMGBpXSuPAgwwtLmlzIMyVrA3dvqh9k=;
        b=MibuB2LS7MMb4GBQ16Eeg5kpQfDYyUcuZAEaUELTBqilNlpUEHy/rQzIYQukmgRLML
         muFOX5kMLFlaw5zBtZiZbFl6O9cGEux/rmSbCDJc3fbH5rBTRegTHYyoED7TyESplOB2
         Kqu2ns9Wp0jSv8hREWnGkAtcBSvxiTkpoJ7k4=
X-Forwarded-Encrypted: i=1; AKwUvByak4SJL9Pgi+34ZiWaYjw05gEZFIbufg+vnAHcm5TgtlfS9nmB9oDsO6VELjYeLgnrttVdlFDxJQ==@kvack.org
X-Received: by 2002:a05:693c:88d7:20b0:344:c0fe:19ee with SMTP id 5a478bee46e88-344c0fe1acdmr7715283eec.14.1790654589566;
        Mon, 28 Sep 2026 21:03:09 -0700 (PDT)
X-Received: by 2002:a05:693c:88d7:20b0:344:c0fe:19ee with SMTP id 5a478bee46e88-344c0fe1acdmr7715216eec.14.1790654588762;
        Mon, 28 Sep 2026 21:03:08 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-347323f5a7esm10952571eec.15.2026.09.28.21.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:03:06 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Kiryl Shutsemau <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH v2 1/6] percpu: Page-align decrypted data in UP kernels
Date: Tue, 29 Sep 2026 00:02:50 -0400
Message-ID: <20260929040256.543767-2-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929040256.543767-1-zack.rusin@broadcom.com>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Queue-Id: DDB714000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ja7txtfkpimagncg8ry5kzauah1h4wda
X-HE-Tag: 1790654592-559978
X-HE-Meta: U2FsdGVkX18rvJpVWIbEnVf4Vhd0th2enEfLWfkCUUd7lN1kRSTDeqPBA0WuMnA+v6ZLtiLscPTmyNAaxK3h3l44Jnllha1ZX6X6r9HLDgtxGe1tnDsu6Np5YoQbW3k5KFfm0eh9GhJhiufpIGKqx3Hc7o/XDX4DG0FdNiHc8eJATZE8kqAzkDWzZfChWNhqHq2/1iC1mXtAPqRYVnoW6oi/hg6PSBHTl7kI8WhnsYzD7Zj+xgkfddWshSwuGR7/VvybhAFjtBCXQJympmBTKWoXs+J7hb/yjwiVn48tLDbQaHLetqRyIFX9pHXPUJwNroJYLSwp6fD5UiKAvGZSY4PhOH9IshV8bETAhfjhhVO2uVE965QxsemlQ2/1vq4S5iHXJPi9cGKuUTV3mnsgqkKeEKEtbvwn14Hojld/HaHK8+9IfUWpFS0EXcxvXD9P1TTBzm5l/z2pZsGARgEBxFlrPQTu/V6hQZjtS/49XBuivTfEHTgDWkpaDtP+LODkM3fTCNDshYQ4fRNKUKwIC8RD9qHDiTmG1emyaxrCtwIqXNM/OT0MsSrEOVQLJWx3frPp3TnYtJp7D/XxHkN80KA4JG2DpBRpcZ1OxXpAAw/P4MQsSYaCWgSoTEC/FWjtWO8z0sx/YlAR3Doht+6xzPEF/034yZTLisz8hMtxnG11RQglDk/CHNsQVi0g2dGYifhFzDi5VHRu4qqXoL3mXkCl963/Fe13Gg27OVdN63Su+dJusugG9mJpljdq/j05xYx/NVoM43c7zxbj/HgmfW6b3Ydod+yllvsktkbCnbnOHzQO6Jnbn+9uzmkAFCV4IpX3u377vq1EsC4GFqIE3GzWQTftClsUvMF3HiIyV2DEP1SbQXshnibd2teX05dfpHb7nLj6+tAe40dw2O6IdrzZmeAtmoSWc9zGZqhVk8x8IpRbJjGQieDKESI01BqU/C/wVl/59xoJ0Hm4jdN
 y7q8PEj/
 w6mHKoInFNCvdNvowisyKpg1h9cpvbEzr4k1CnUPzbWNmmGAvIUkHUjzgRCYGL4wXMFGPWutiwCCvLVgqAgjGHS+l0FXqV5meSIroCAs80Y8HwSWBU6BI0lHPmS74xpL7jkoKM+MDCK2f7qdkFkcLVbVEkW0zR6EIS2UbB5rqpRDs6yH4WLnO/utI7gwhFChHyON5n98whUbxJ9xK/UAF4GLxC6Pu8++O4VQPl+/0tNolWEhyDzkCJlAJvDSVtDo5WjA4UB0tbwlmnFlVRVVxMepcJcDfQUIA1ye2lkDgcOJvQDwptGDMVSMzh9/3xADpie+onOIn8cqpkpzYGxDHahWtGWTXG7TYKkBxgzOYSzMYv4b2Dxo1UBLOScYkkJBTOtsh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Without SMP, DEFINE_PER_CPU_DECRYPTED() places variables in
.data..decrypted. Align both ends of that section so that changing a
variable's encryption attribute cannot expose unrelated kernel data.
Keep the section in permanent data, where UP variables are instantiated.

Fixes: 000f8870a47b ("vmlinux.lds.h: Fix placement of '.data..decrypted' section")
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 include/asm-generic/vmlinux.lds.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f66..64bc2bfdd2ec 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -368,10 +368,19 @@
 /*
  * .data section
  */
+#if defined(CONFIG_AMD_MEM_ENCRYPT) && !defined(CONFIG_SMP)
+#define DATA_DECRYPTED							\
+	. = ALIGN(PAGE_SIZE);						\
+	*(.data..decrypted)						\
+	. = ALIGN(PAGE_SIZE);
+#else
+#define DATA_DECRYPTED	*(.data..decrypted)
+#endif
+
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
-	*(.data..decrypted)						\
+	DATA_DECRYPTED							\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	*(.data..unlikely)						\
-- 
2.53.0


