Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71EACA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41641900230; Fri, 15 Aug 2025 05:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3789E8E0002; Fri, 15 Aug 2025 05:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2A0900230; Fri, 15 Aug 2025 05:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 040268E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FB9183948
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:21 +0000 (UTC)
X-FDA: 83778418122.06.B083816
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5118B140009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=w5cQS6hS
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWxB7D3jJyBkITTYt/u8P0qX4HLXnEbcjEWeuCzP8c8=;
	b=AlXxrUqjTvBjDwnXS4wzBf7p5pDP2/H6tiibdzovhgeEApJIvMLgezprS0mslcG7HJBEgs
	Rq9TCYxX6yh4mosCW1fMySLRIfOYBkGlMGT8T1SQHKLLhaUxaoS4XUaDL+jWqV0E1wrYxa
	Bn6uzf4TdMGKNLbZY5g7SEVEEGq3Yk8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=w5cQS6hS;
	spf=none (imf23.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248959; a=rsa-sha256;
	cv=none;
	b=dIA6VKUNCY9dPglYcNVYuBPch17Gjbo104EQ/QumNDlKGqmEbdbl9kFCZ8uJFhriCJQ5Ut
	Cj54js+sSj8oroPWr57A5F5O7A34DjShN4RmLqA5xlrp+ldZegjNogwhNYg99QM4Yp0Leg
	/hR3s5XW08SHRUYcrHVpfoDMOeCPmQA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9e414ef53so1544959f8f.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248958; x=1755853758; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWxB7D3jJyBkITTYt/u8P0qX4HLXnEbcjEWeuCzP8c8=;
        b=w5cQS6hSC5BJUMH9qSNnvrtFi0p4RjFrTUHcu4qBWQqNEq2Hw8fiQ7Dfl6mNCCsM/e
         zRAbyvB8ibaop4ZwGS677W0zip6MYdVeQLC58ls3SEk9zkoZr+X8PWMyPSa1yRzS9OiF
         gppKe9CPhThYO7RavGNisI+QTsuAH+/XdGiNCvzAD1gpBOskUA7vDEkzJlHiVZejW9s9
         RGZxoI6gAVS11tMt3FmvkUrq/Dce/rJYngY8DHcRI0EFZR+1m74mPbh2ik2Bga58O71J
         gcyhTlb0cftOHTBPKi8Rx8Erja0S5+RTgzj5aTRv5BXA8jVRKtAqHUgBKhz6nl3r9vjX
         RrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248958; x=1755853758;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jWxB7D3jJyBkITTYt/u8P0qX4HLXnEbcjEWeuCzP8c8=;
        b=jXpIGJs6YHocPXIlkg0ROFFwuQr9NdlzsGwwF6Epe9ZGLAYHeRE7avGzoteMROM8hx
         rHwpT26GFMJcR87NMO/o7m1YulO97kjVmjW3zmbUUZwL1S0VCDJNBPVM3ZssTntHhSsC
         rpzfQiNp3HUR2q/SOK4DBNCeHG/GktG4TTIdX2V2dU4dOXNh+2RFZraLUSd+qURDSEyn
         5y4PSAyr7w/CqxsFkVHu/8wUj1eOHW0RcDpsFhd5WWFNCAFSG86S1NS7GfZjX6wPpXK3
         0m7FgGsKU+cEArBsqWOAnXD+xPR/hiU4pNyF4RRdjBTdrDForJ7OhYnM/HZgxm1dpQiK
         Ying==
X-Forwarded-Encrypted: i=1; AJvYcCXvgdpkiqVChVwRyPyTjJvneO42z6MS58cS1AtP4Qxu5c5vt/XTJm0Tpv2OraOtSXITxCW+KSK2aw==@kvack.org
X-Gm-Message-State: AOJu0YwywuOs9HcoFpn2z5ZQ1wD9ff8kMCFNiyGGslgLps0urL7f1h7c
	frM4IaERQO4tXFG1Zf8MgVn/uAJwwkjrI6NDMxqF8M3NaXLz0T3zyh+ITDI1swDwzCk=
X-Gm-Gg: ASbGncvbeviTub6d6qj7bZSNCzNzr6xGAJUrfILYRCkjnGjkXkqOW/a0Kivh1DbP0R1
	tAv1SuRFT8TRucdnJcpIO7lORfNVuj7ONLJJ8kxJAXblozr+fh27+E65fxE6sSH7/u/mONPdTES
	uostEIMFCaB5A6x1qnNCbAtF92ZzP9kMkpkNN+lZ/yMqbi2yTPCaDXl6/2jvX9+0/9JvEfdUc74
	5lwQrumr9dbA2WKk3X4HuGO2dlW9e4dt7F5gX/G11JF7Iz8SrLtJOTk7iufOPHkCg5MAJgoDDWB
	DlDoHSwBTJy2m+dHxiXyDVHuZMP4iqQqmr/r+1GcvKk7rNGv9MEIUZgW+n8Y7Yi9PUDQZ9vaRuT
	/IwFgJcA0XdJx8wtWAg==
X-Google-Smtp-Source: AGHT+IGnCJeDOqE3G4r581ayfk7huZyQHMOX+PmOKQXkUeS7zf7iEj9jqH6oiGPuorRj19lkyqveSA==
X-Received: by 2002:a5d:5d11:0:b0:3b7:810f:6caf with SMTP id ffacd0b85a97d-3bb68a1874amr1166149f8f.32.1755248957733;
        Fri, 15 Aug 2025 02:09:17 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:17 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:03 +0200
Subject: [PATCH v5 01/15] devres: provide devm_kmemdup_const()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-1-955de9fd91db@linaro.org>
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
In-Reply-To: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Alexey Klimov <alexey.klimov@linaro.org>, 
 Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
 Andy Shevchenko <andy@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
 Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 NXP S32 Linux Team <s32@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Tony Lindgren <tony@atomide.com>, 
 Haojian Zhuang <haojian.zhuang@linaro.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2111;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=yGM1a+aC0va5PQYzRl7VigwSABEcy8VUGQM8wt+k8EA=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk2b9jhbpZSR4bPSrpRtG6g+7NeYTvJmeHom
 mkeMTq5AUSJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75NgAKCRARpy6gFHHX
 ckzrD/9dpMT6eFmPjEdr9qjjRqAOs5l02AiDkl3dHtrzFi9yMxxW2FtEtRuxPAhpHPVWiHPN07r
 0RROaKlAKF++hEfZYnZedgxj3QWia5uQqkTZGIk1C6yktsS//GQGe0diPUrRMbSsMNANL6SA3Nx
 S4wRM4tUkMPqKt23QdTH5TWkZhIsNDbuDR8Zj4iNO/Oe9tiVLXFbPOslY91hsYRIOx+29AVkUu0
 nfRh3+Be+5nBAQc73pr8bf0gR8TwhJtXlQ4oMq6OGzCUWMZs0cTeSGFiQdzL6oP9De/SWcMCMPO
 3XA0BNI12lUneQ4UuYedE1N0KElf76XPTEx2UrholVQN+5KpqruqPKypec/HgHGhpMQv0ywBWUO
 kkjEJiumlJd7SzYJ+Cl7t9foAdOHlVGbHrSwhNNAsZ6NP4umioBGxWb3qFwna55mgCL1R1YynSo
 KPOx6RPkda84XsjOzlOwSqAPBufV3AON+YIKuJBUmKqGk5ba2nja9OqTYjlQEHBOeN2QmF05iUK
 z+4I82/CtLqSGznLLQbzoJu3sRwnPRgEc1iZEg8oYC/4IqFC6/noCf4YYYvIA7C03q+RTCyPCRn
 z465BIQ5H0TfkwTOj4sYbbMsTcq7N2mrfE+fqMp4J4jUxTAhjOXedXvSYOIXvvmYPQxWMphF+EQ
 nh1EvmLIpVJ9QHA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5118B140009
X-Stat-Signature: 3fn44atqc5pfi76ra1mex9aejbahpw9f
X-Rspam-User: 
X-HE-Tag: 1755248959-450026
X-HE-Meta: U2FsdGVkX19W0TqoC1Bn/VWwkFXJinndWd9py2VVdm/6N6cAuL2b6ib/LMdMDjEQufLlxEHDWpa246cmJ00phn3AGQweIwTbbRmYgHwiJCUXzsRVCKtINZ4VBwRKBxcCGqW6ipvhtkjphdHgDiIlgk78AWVxU23/xl1FntuPs1QS7MdRes4VHZRg2DSw9ud3fafMNCF7j2x4ytr7EwNPuRwmX80RlijIIR3A0hNlqvz2QCAWcrYnnxuNmaVLZZM21EQ2AbhUNOHZ4lxgsJn8ApEygSa/yNdnWVOzTsApmi9k8iDXO/uNk+Zu2ZUPKfOm02p2m25GXIwgoB3IzOoDFC5zUVbKr0slZmHlQLdtOlD2HPts/0muRiIEEz9NLnew9EAysSdHm4Va6h9ad/9LNiMjMpJ3VQtwKjTTRw+aFhI/Mtv0sUTDgESsJfpdo4crkC21hLXB9NmvnUPgHC3e9iZKQpX1ZkN3Yt6qygFYAdP+nBXAFJTTDmvUEkY9UZcWfqB4yiccizpx1PR/43omhlqcD42CLuIN2YRAPahYSumfmEeJFUphGXu4bCu+AhlsSQ+iJf/f0MUcunrA+h0wxlm0xNM1yXEkhoG5ufckSDit5E8MMtgMU/8UJFA1ETmWbSToLtWuxyoJZMzEMSzl8qOwkQjXvSSORvdqde8k0UtMdXgft0tVunmII3XN4MIlYAkLy761DP9fyFtpQCCWeIp2+dRYF5676r0Iq1DTkROM4d7bQIQLzz822lJ0xdDXY6ixFQwtLiUWOOB8ob/7Mqx/syk67yEnolMQXf8Xl9TXffR4M+7VsmS/7axh6qJQo+feDiDzYqwamwWe8pwO7sexZfxgDC9q9dVu0UYfgNp+R+iIe0VG0oZzov4Ln4gDWAoeDFWe+kdR5mpkh64Z5jLIKADtSgTwMNcWtlNgIx+QQSR1Be2Js/nM4t/+U+jV5uT4Pgw2ZJNlb8axNTo
 YanS8Xbd
 LCeFBjgx3tPNEPdvHkXSWLFfCK5ZWqxuxBqMzWoLeG1V/xdOSFPWAEEPtYeU+QH3I/bkXJMDEpH5pb+o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Provide a function similar to devm_strdup_const() but for copying blocks
of memory that are likely to be placed in .rodata.

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/base/devres.c         | 21 +++++++++++++++++++++
 include/linux/device/devres.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index ff55e1bcfa30057849a352c577bd32f1aa196532..c948c88d395607ff511ffa6eb0a75b7847ab9239 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1117,6 +1117,27 @@ void *devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(devm_kmemdup);
 
+/**
+ * devm_kmemdup_const - conditionally duplicate and manage a region of memory
+ *
+ * @dev: Device this memory belongs to
+ * @src: memory region to duplicate
+ * @len: memory region length,
+ * @gfp: GFP mask to use
+ *
+ * Return: source address if it is in .rodata or the return value of kmemdup()
+ * to which the function falls back otherwise.
+ */
+const void *
+devm_kmemdup_const(struct device *dev, const void *src, size_t len, gfp_t gfp)
+{
+	if (is_kernel_rodata((unsigned long)src))
+		return src;
+
+	return devm_kmemdup(dev, src, len, gfp);
+}
+EXPORT_SYMBOL_GPL(devm_kmemdup_const);
+
 struct pages_devres {
 	unsigned long addr;
 	unsigned int order;
diff --git a/include/linux/device/devres.h b/include/linux/device/devres.h
index ae696d10faff4468a41f37b5d5fd679d4ff11997..8c5f57e0d613492fd0b2ec97dd384181608192fc 100644
--- a/include/linux/device/devres.h
+++ b/include/linux/device/devres.h
@@ -80,6 +80,8 @@ void devm_kfree(struct device *dev, const void *p);
 
 void * __realloc_size(3)
 devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp);
+const void *
+devm_kmemdup_const(struct device *dev, const void *src, size_t len, gfp_t gfp);
 static inline void *devm_kmemdup_array(struct device *dev, const void *src,
 				       size_t n, size_t size, gfp_t flags)
 {

-- 
2.48.1


