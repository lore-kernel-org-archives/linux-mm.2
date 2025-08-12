Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7D2CA0EDA
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBEA8E00F7; Tue, 12 Aug 2025 04:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD818E00F5; Tue, 12 Aug 2025 04:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75538E00F7; Tue, 12 Aug 2025 04:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B54F58E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 574DB1A0232
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:13 +0000 (UTC)
X-FDA: 83767425546.10.033B3D7
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 488A240007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=RLdlizFx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTgIYPzRiaE3tZSZCUJbaKi97GRLZz5syZCli9/nEr0=;
	b=0TkfJkMkUm/n/rlp3k9bKgblIKhRIdf/mtLVcXFWR2yYBdOr4W0kjwXrfeB81kwwhNK0tj
	CVrUXeJHFe8P2FTiHhpyN+nN34IuS48yzYBZ+hp290tQQRqcqkaylH83VEaHPIAjbGTciU
	SLRBwXwSBpwGLwco9a0YRwmGarCsXdw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=RLdlizFx;
	spf=none (imf17.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.41) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987231; a=rsa-sha256;
	cv=none;
	b=ruL7GgsDj3JnDbvdRpbnXZpw7q8RZsLKtO/Rtan8Fgy8Qry2hPFNLC+KgPhchtMo9fEAQ3
	1P6EU3yJ7WMX33zsVx4pKctVd+z7det2GkWHmQ1cqboA/9KuP8FSf8hoEPtITMvjO5rvc6
	qjf7+mBGjEGFt7SA07W9eb3rZBcEAK8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-455b00339c8so33164945e9.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987230; x=1755592030; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HTgIYPzRiaE3tZSZCUJbaKi97GRLZz5syZCli9/nEr0=;
        b=RLdlizFxX8NsKAAkPPL4pGhxNOT0A7Qlt69PuBb9kSOkJqhvCpawhCl5mgsGzQa5Ub
         Rn5uMABzt3h1srmwpjm3mu7o/imms5UFiujW84/IeROTZ0btlHv4LOwQ2Go2hd7+qei6
         kUOHyERThhBewc73myoioM7/BC6viLDtodhI+quuAbCOclQV+e8MpF4HoWgxiH2ybZtp
         zBrK+2qVypzQfHFFNtfrQNwD87eYKA/6WGuiyGdvhPmSvbamhVAakChG/dYgthqjg5nw
         oEcs2XFG+AFHT5DwZnyYLUeGRq+vgvWfA7noEE3Yxl8yuUC/+du+T/ErLEnzPl6W1IR+
         a0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987230; x=1755592030;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HTgIYPzRiaE3tZSZCUJbaKi97GRLZz5syZCli9/nEr0=;
        b=hJMuShY+364Nqar1bTDqx+MvDs1cbXKVouM8o0nDypD+p3WQMfnq7saRaMwxjGDXSn
         9j1gJResMfEfX/hVvohLhSbmCPGiQhRj0sAXn5im19bJJDsfZSTBdEUM12atES+wJOj1
         Kr7/m4XCgyY54drA7f77mD92ocJkn7/Ro36tzc+GakPd7FdkUpDGNT4dwlCxVmE3XwFk
         EnK0dVYfn11d3poedWAnspXMlT54O9YTUknSNnX00rSMuxrfApCvIEWGUcs8L5GI5FmT
         3okV+R+syWYEoPSAHmJ+wHG/3MYDwe5+vs0SugtOU1hjEA85qtcpoKyUDvwNELL1AO+B
         0K7w==
X-Forwarded-Encrypted: i=1; AJvYcCX/1yE9KinEHxU1DTDQxrjVe7KEOrUp+xJEA42FgX3UoSyZk17dK3pDZgTvzzSsf3QT2CG7gM1g9Q==@kvack.org
X-Gm-Message-State: AOJu0YxuLY24edlboOmY8yjm8ydBxSpFU/UI5NAT/MiFFM/mtIIvDHQs
	suiNpgpMWjPD1bxsBVX60VgiTrPLUX4LVdnxDTx06OGGyGqNCPZb0W6AoI/4N13Ffqw=
X-Gm-Gg: ASbGncuAWElg6YgcWrWL900uNKchET4RcKHUh/0Mz2i5Ib1EMYQBrMKesDi5KLxH8nk
	2Bt3SBwpNcO2E3AGsrJSPvyO+9k1BvkX2tGpxvhRigKPEBIUp9bXWO0rLJki9vtbothc/jGBQDD
	VnMThQxIqjT0Km5utBi/svtDje1UZMW71g5jkYN0AP98ukwLREf6ZfW6VkShGUATQJQF4XZRzu5
	+sgPHlbOWmy1XN6BKhwHPBQSv+hjQwLg3eaYXUlTXJHAI9d3b8M2ASZWNSWaMbfxyolS6WYTL+c
	KWWj4dqFhVIj2wWhQ2H/n1X5RCrNtt7TInVtCpNafx/+3Oz5p0wzUe1XtrlO3qtWmIp7NzWT6S5
	qTULDmo+zT/jKqxE=
X-Google-Smtp-Source: AGHT+IH2gcGBdQpuT3RXzrIq10+dePuK4J44tZFpcWvxuc+mjI/75XhCe1aSLOq9Ow+V0+SkeWNRig==
X-Received: by 2002:a05:600c:1f0d:b0:459:df07:6da4 with SMTP id 5b1f17b1804b1-45a10b9b16cmr23623335e9.5.1754987229745;
        Tue, 12 Aug 2025 01:27:09 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:09 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:00 +0200
Subject: [PATCH v4 01/15] devres: provide devm_kmemdup_const()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-1-bb3906c55e64@linaro.org>
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2063;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=Igk+yDN8BP1JkTjLlRhKQ7SRJ5My7JH94ZAwq+/yocg=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrWHo270jKNT7TR30vMTLvJtquAQ8DkFhjQc
 ewt3zLD8DaJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr61gAKCRARpy6gFHHX
 cjXuEADPonktCGWYlKywp9d3HO63lp5DL98Fa5df96en6tECd7hEXtS99i9LAByEf9gB+XIzpYT
 bn7HKsMznjan6cqY/js2/PmDrnfrTaS8GMTWnnVOxndSGotuSFmQ3zk2ssQIvblDxvtxEK/VfWs
 Xorx6opZLXirGk7awxEDwydn2R24ZBfAv4HNzCaPxdZDR5jPuBK3Y2Sz9Z7zxOLkgCA/dFSI/VC
 EiaB0QwENlBXLbDTWm+FBJKFkgyLBaaelM7rRmgWagtEkB6QDH4aDB2BeQn46Fwrx5thDVEjHzS
 fyE7pWZD/eVoSgnClKMYjtwFSECf860vmV3a0SYw2OQWjdtR6GDu3H9s05ASNdUyHuSY4YiLG9n
 JVpnETaTHpb9lSDi3vb0asDKaLIcBMaBkG4dWOWsNqs5Z91/qSP1KRMVbnpNI91WMeQ2as7u3Cd
 m8zJYNga6cC9JfwhC+54Q4ijTmVTGa6tqyxkNqWlsEm7M5jjCpIRR07fAODaqKv3MIgXA//89QS
 iCwpz0h208VuntqHpkRusRFTEDihMX9aqBRpvGkYLphyCcDXTK5bT1bOhByWDi4UnlmkZGRK8C5
 Ciga46g5hgKGVQM1Nkkit1mjBI1xoc0CaHoC4+KXTbzTIormwWsZBSPMKWcYUwOzlpENKo0Z34/
 nBWlmLjGY27IFaA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: bky43q6pesn1qf9jbp85yj8dg7rpm16s
X-Rspam-User: 
X-Rspamd-Queue-Id: 488A240007
X-Rspamd-Server: rspam05
X-HE-Tag: 1754987231-855716
X-HE-Meta: U2FsdGVkX1+VfgXINugSo540NjpOr2uTJtirdcAFMTCowDmKjXchOtrwFR/t1oQRSxqxhi4Pb0YBirCEh56did9fyUVHLCcd/bSiGuVPWLRI6d48NdM7R/Ylz1JmBdC3nDz9MEjAYqC1m8IzbhG2bFRML7O+AhAxOBnC+0NJaC4X0O74/uZWVrqSqPeqjdcDAWz5puwIcAoOQ0mjmhCplDlf1g0IItrxq0K/PSoscsV/sYqloTlgb3QgJm3gFtdOlORnQST7RIiiySFFe8BWL7zdq2FaVAnIkoZFbjJA4cpYswmsgFBwzLURCIOByPNBWsdrjfmQOwK4MwYTW+NTsK6HigN+8D2Uu7Xb6lggxbYfKu9+wcQm85Ks2dy30LYLjUvXZiVTTVVTxSHwGAjnEThlJUmq8ZIdFM1E1q4L+TeZYPO/Eyh/6hYZBS8dKDKEyHwufTVXI2fAc6KmRN0t2MAb4a1Crmj4XzzsCDRvSAX11+FQiAejyOqgMljzOkBVs1QIelw061QlJCjgrjZiYu2Yk2fIDq77JOLIAiFUVchHa+qYjAz2riJv3ODLW5X44sM7CWDKpQn18J9Mm1Q4dbC5qP72AIWBQrFqSSEJHpFmrKqAs/vqJnfQ+0ctRwHbinpQTlsOQiA41VsMBLDnFpY6UEVbrl8BqF6JZzGBL3SQZgcpu43tH2UpyvD34nswQQ0XVyzgs97mH2ujGjMGSmBbxBCelaYSGjRm6l8Izt28HaLJB7HMYyOL5DNAZOMnCY3sJjSbC8uzgdjCUt1v3pljfkKVR9JU2AkH9hQCfHEKFbj7wuwTRHMHa7SoRMn35h1pN0tVndjmRFCvvH1bABx5IvOFuCQtwzwzDFhaDSHbWg0dgZOyzQ9hWnC+t5cWhQhAEG9d10ZpwbUssTjX7XHHtu3WCSd0/Gkv1xuPFB0ZGSx+qDK3W1LjfAXq+/PC2GQ+BnOoX/W1eSxv5CQ
 kn7gKs6M
 78Q8UbJcVdiCWFMU1t421VKvOFuHPb5JIC2eL6Ivn+tPO+U1YNUf3pYf7Gwf/+JmgeMOXiqRN/n4uh8RxzHSxRrN+m1BxK0PtB/K4dnA821gCm3IwvzAXPK8suqUG9BfJBw26Zsqn0F50LMO0BjvT2uZThW75VnyVoqO8w847yR50ZWnOntv6T2s5GKAhAZb/m3FM3Y7hMhs5wb5rarEJKLHCKrZ0khqEQ6PfirlbkPG/Gm3hhlCPNdKp9tJoqvo1WAEDG2m+bnEr7+IeWP32kCpq7fVr1dlpVGRTpYbX8sVhg0EF1NigOnFdMx5e5T/bMOS9sdEBpiiZP8Y6985fQw/MRRIiqunfD4F+ziltORnhOzaFjVs/MMF+TzlE13SYQTSvoMXE38gcuWfDm0ynRdFzV53sXxSZcTekrYYXQs1GOoaW7lZo8u6CqYY2l4ZrO16wTBgVrPwMy4a5mKu6j++aN6pVBqN+5Gk5ulLM9MFb+9Z9avKCf7wBhUAaUNaJkIIOdSIMbH3WQIrFBmedWApuXZEM8/HxO2T16BsR89hnRjM=
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


