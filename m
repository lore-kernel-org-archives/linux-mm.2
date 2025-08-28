Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF7EC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF79A6B00BB; Thu, 28 Aug 2025 12:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A585D6B00BC; Thu, 28 Aug 2025 12:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838686B00BD; Thu, 28 Aug 2025 12:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 613446B00BB
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C4D1B7C55
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:38 +0000 (UTC)
X-FDA: 83826628956.12.F91B68B
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id B80B22001D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=1Gzmxicv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pP5mgQ/KO2A3DwCCCQ4AUd2vgku2CtkVmWarRJcBL5s=;
	b=nmQJbbgAJBXtqq5yq8XwrFWoyP+w/ntwg8Xo5xBAchDhA/6F8RGTyf3/qRjef35r6iD0OK
	RS+/4AHTXB+Qq6Y5VjvN8h9C27apJVQlaDX5EX3o3p9R9eItasInatDrVCrf9CsZMaL3d9
	vVedVdPn6OI2uNme1mn/APuY5yw8RPs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=1Gzmxicv;
	spf=none (imf03.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.41) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396835; a=rsa-sha256;
	cv=none;
	b=Bsabt/zsisWlTZ2EvQWcyWIVGG9XxMNwBYHl8lKawmGcM/eL0mrlcCQA+sMCrfv6+ShrTz
	68lcqIr2a6un9E06K3BeiCzXlyVcSqHGs6HjQX+RhXLvB1xaKXOZ3e/wyBYSxGnWn9LQ4+
	rMmJomp8oZvyuW56QSvbKuGzgFphrjo=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3c985f13d45so792463f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396834; x=1757001634; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pP5mgQ/KO2A3DwCCCQ4AUd2vgku2CtkVmWarRJcBL5s=;
        b=1GzmxicvW3nzVEguGWukGF5DxS3lc7/4PZSbJK0mEkuQZHmhDiqHmQJbsKRqjJ52IL
         CWlkepWGLhSeA+Tqj1KeTe1jSNmDAWurvskxTswgSDdtkq8Z9rQIj0x7SZPcoNmuiAXB
         tJGKASJR0d74FxxzktzOko/PucAhsz53CUww4thZsV83qgiyDQAAUZTU4oqzuk6ClVBz
         ZAJDgHIa1iQd21eFkJubJ3LwfWhaJ9OYDOZRQhK6Ad4MgwnGJo8H/o763uahVaNJDoIa
         /Q4FP1ePrj9lgQ/ODyK7ZoKXBieOp8jtAafz4vhxn1bOUcL0QyPR4Mx9hy9zOa9jwD2e
         P+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396834; x=1757001634;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pP5mgQ/KO2A3DwCCCQ4AUd2vgku2CtkVmWarRJcBL5s=;
        b=kjchTXtmSDoRHN/Ux9CeNyMd06ruxzM1z+fa+F0rp/I9Jbvwoqo0Krd0FFzW+P8qV4
         SbDJ0h72Mda9Zm1YN0IGKT5ug8YZMFZKG6MAgFVPMUABkcjrc6RyCZripGQOEZiDJ1es
         pmtgu3qsbaf7vbIAlsGsd4+LFgira95bMELPgYrQQcd/Xtd8jAG/EZq1VRVMLr8Wckg9
         VvCbkWu7rD08a8uWtoHq1MLEjFvKEZGAUdfmE45iPlp9zm4dnJBJ/NSp+7Koqv5eNbnY
         sJ9av7KnTSUMrIdf8STr0ewPIkkWhqapI5Gun/yJ1Sn/VMh17hOZGyLS/wkX/mTqNwqG
         0llQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfVYwgjcomAIRumjvdrcz+45G9cZMxFqwwkRM4OMSlt1su1mLQPnl3NpdB51R6FyzdJQpKKOADuA==@kvack.org
X-Gm-Message-State: AOJu0YyIgtFChnVzkxSa5cDFsEvmV5QEk5qw86xhaN6Zy3fNl0rDaR75
	Eqo2DOTScvRWlSXxp0RgxxYTrp/IPDYYOD3SPhl47feIsiygcvguPDKvHRw/i+qSZr4=
X-Gm-Gg: ASbGnct8bDHLLcYx650Pb8plwZ+IzwNmsxaYA1NDNBkfzTaEg1MQbEbEO/VWYCbCfxR
	MPIfi4jUJSIHOCTCLyAYGXgiqncmumzizzdUHwD+bwbIHgyuEdzudcVgPMpzpOHjq+q2Xo0JM6x
	lsLBSNJQZeMGWDeVRiOQKLwRNj+eKbMkWw8fzP68EUAWZrzEdmvp3PCW1NLxDpTFtQvPLFuol/9
	abmLnBTwsArQRPRqGAq6JpGNFdYnzkeKIwHORZUyjIIQYSka7arHQskaBK8vN9/enjV8oI/Uwma
	OJcCvU4lRhxYM9GwnZRFpxTHreFgOFYEW6hmEKTRGRaA68gxsWCgza/oyBMtQwQ7v9xeuCYpwUs
	fkLWgyhtHXAOWwiIYTjT5NwkMI0Tn
X-Google-Smtp-Source: AGHT+IF/YEBlIMtlSjoTBlz73MY+KW34NIRH0NQO4wGYXNv8UgmP3L04Jda4NkFEAj5ubMZH+/DoUQ==
X-Received: by 2002:a05:6000:3107:b0:3c9:cd8a:2921 with SMTP id ffacd0b85a97d-3cbb15ca243mr6478341f8f.21.1756396833984;
        Thu, 28 Aug 2025 09:00:33 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:33 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:17 +0200
Subject: [PATCH v6 09/15] pinctrl: constify pinmux_generic_get_function()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-9-c9abb6bdb689@linaro.org>
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
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
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9697;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=heCL06NLwaBebVNCL7XXRfzeEKX3nvjH2Q2KMKw/M54=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0OSJ+6KxK6PbX/PACI4VH4kRB8IHR9ON9MU
 JmGy7C8qQGJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DgAKCRARpy6gFHHX
 ctL1D/oDTBN4t36cQ5paiwmObkaewu5MGDgSBBjxlCjWyR0P3OOh9Ww3ut2AjFIxdMRW9AiDRIO
 sKUASOrHKIm32sDGCahVLsvFRME3KPMFCAg4gJsg1ZdkGsazCK0jztIP0PlZh2Vg9qtlp8HA1py
 +NzPyWWt0dmwCtvp+lu0kF/sjJYLgHT7PGr04i0kNPpswjNj7kYZ+hC/AvLg56lYG6GWoI/2t9A
 LQKlz8CDWkYug23hrY5nwYFh7iqvYZ2bcl7vpOj7+1YCp7AJK9g/2Dj+g4mCybIpS2qz5bMmmX+
 E6AS7nwOwPyhrU3RUNRaOd+vf1cL/ta9I77wCKVvFLnI/EDOPYchR58ZKoRFzvND0MXxD8Aa8cH
 ZYPxoAhuXXIPrn1kjhPe2gIezgi9JQsJkkL1zmJ+5DUtKfi8yDnhoGMa89hJYTjB1g5rks0z8c5
 y9xVdgNTng6/yE7Mk0wC4szS3GrQ7E8bVU6qfz78knyJxJDGoLLewKwyJ6iQYESHfWi4u9a53NY
 VFhtWlek4KsFmrtaa2DVo6vY8vpVC6NspEKw5aA5pZRkGyS/IgxAze3MDTdttS49q3VrI1zKnaY
 lrPe8BJjf6W1KkrRc7vpOWFo4nKVmEZVwm4qtsnUTv/EMWkgvz3ARCRmVMd4x54tv+euGZpZizZ
 Js/4hXE4ZFt3NcA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B80B22001D
X-Stat-Signature: az5q5ejos6m54g6pqsuq1ingf9rimikh
X-Rspam-User: 
X-HE-Tag: 1756396835-826318
X-HE-Meta: U2FsdGVkX18wdpnX0m3S8dPBGwAmH12wju42jEpzMJ502ZW4dalONYg88pkCu+wq8iUySJ7oXeSmeQSrFwPqfr8wQwc9kwnFYFcJaIwPTG1UcMt0JkSdOgwzAo07dFt5U9fDF4Rd2oTU0t29NhUqh+F8x0Dpuq1R/WkwvOKaJqDpIxehJYuGZLycY/CVAcK6EYn8AIHzJUTMF4gnaE7n1ecjQQgtFFA/h8iXVlOkSin1ZSniVG8+Re7v8gMPorgQ9KQNuJuSmr5GVVkwpS1TZzxL3EE2XQeiZIacqE82gn7femPK2Vs8UEivDQLncrzf4gNeUN/WeZKYn5F+fE+eiuim7C7mnVp0BQw/TwjIskdzndxANElwl9DLmstrJqdtP1Xp0Lu2DBX4hWr7s3oax82V4F5iyG6QuZirZttCCjECLMYpMp3XNFPpjZnZhBm8kqUyA9s3w3SHKzwIBLZdgdtHGoJ0KOxnNTuNDudMOwyAQyJnP77txnr4gJh9JJIHCdOaN8RtoZQmq2eT1aZZxVbHA0UdL15JliCInKMMPPTIK15Ic6CK7ljw9JLfln93hDDIrp59NOj+oB4Rl3+wbE+51ZaX2SQIyqs9GLumwsy5dbyR6UrR6dzl1AIfplEkmQww7h551EIXVvLa1SbLY6azATNX2gpGP2ze9pAIOXo634Gv1upOZsluPbYW8uIkYSRoL9X80r55V5Hvry04wPY6EYxNOb9TOmAhwB/hxljK+liSz/26t/DkaixLgUFhunMgbL6AEkTfrxJlLIaHCUJbXwsuveAksACwTsm3P0jhJKhdN6PBHoEyjV6lwTndnZfcsqNOaZngfJxMXNkMqq42LxjiCKCOwunP8aKGMbyWABa3JPpzhg/hKwLYaaR9kAWUZJrl0I/FnZgjTJ4jmVEa1bDQ93kL7kUQSJ4UaUd75HOLHyodPcf9QrmDqDk19hjLZvH/4DtCcmuEUPd
 erMy94ib
 cZeQSxHIID+YlN2GzzMeBx4yTla1saUDTa+hcRDWBdFnJpBSCYJHSO5nV284NuwsDiklMzjpzdfrRuOWSSPRovTcSZQvFgGCdjt9NFteMKSdo9q7S6KYKxJEWWkBCiVY9/ZOU9nbHvmL4v4MnEdJ6EUAhz4YQ78I8Pxupaq8HWSvY2lMm7VxSdaCLZ/JbWd1zdUw9Y9UZwWrVXIWgOG/DsJgZX4lm/QQf6a1uk+JezJOuZbMK5Al/9prJDT1DQIO+qplr/uq64tN+66ZXSiBeV12FISKPBL30O6cnKvHNnUzzhG1RY87RuDVpyqZwx3qAJ/+oSQaWvY+mgU/XyJoIDhbrv4EedD0NRnBhlSofEF5fCHysOike1o2EJlQpVkqHABhiYv6aqCx2tSRWVQA571D73OV6NtusaaD3xZra2ZV/wBLnvpQMbd3s/x2BQBC50glBiosFZdLJafcbdit/7hJtvjqHz6SIEKrOIFDEUm1r3Nvn6AjRqCBAmWHP8f+QevmtdQ0AIPYADNS6Kw5iqePZjfy516icLXyB5NUVGVfZBxFDExDdZQFmtJuXSF7n+vUI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

With all users of struct function_desc limited to only accessing it using
the dedicated function and never modifying it, we can now constify the
return value of pinmux_generic_get_function() treewide.

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be> # renesas
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be> # renesas
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c   | 2 +-
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c  | 2 +-
 drivers/pinctrl/pinctrl-equilibrium.c     | 2 +-
 drivers/pinctrl/pinctrl-ingenic.c         | 2 +-
 drivers/pinctrl/pinctrl-keembay.c         | 2 +-
 drivers/pinctrl/pinctrl-single.c          | 4 ++--
 drivers/pinctrl/pinmux.c                  | 4 ++--
 drivers/pinctrl/pinmux.h                  | 4 ++--
 drivers/pinctrl/renesas/pinctrl-rza1.c    | 2 +-
 drivers/pinctrl/renesas/pinctrl-rza2.c    | 2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c   | 2 +-
 drivers/pinctrl/renesas/pinctrl-rzv2m.c   | 2 +-
 13 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 3d626d8c9ae9ebd5f7eb76216924c46b34233749..56bfbf4c3575355bdda59cf7471bbf5b9babff4a 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -245,7 +245,7 @@ static int imx_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 {
 	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
 	const struct imx_pinctrl_soc_info *info = ipctl->info;
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	struct imx_pin *pin;
 	unsigned int npins;
diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index eb6cd27955fbe462f479fbe92c785588caee5ebd..2eed83f9f209cad79580082c274d4056231bd421 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2443,7 +2443,7 @@ static int airoha_pinmux_set_mux(struct pinctrl_dev *pctrl_dev,
 {
 	struct airoha_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctrl_dev);
 	const struct airoha_pinctrl_func *func;
-	struct function_desc *desc;
+	const struct function_desc *desc;
 	struct group_desc *grp;
 	int i;
 
diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 982b9887521d036538f67e9919de444693c458c0..17a08c73423fd089066e4894d2307c852bbbb661 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -43,7 +43,7 @@ static int mtk_pinmux_set_mux(struct pinctrl_dev *pctldev,
 			      unsigned int selector, unsigned int group)
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	int i, err;
 
diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index fce804d42e7d7f9233b2da0fb26e482170629424..18f0da58c96d4f0fad6535fd88e69fc8acf96a94 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -319,7 +319,7 @@ static int eqbr_pinmux_set_mux(struct pinctrl_dev *pctldev,
 			       unsigned int selector, unsigned int group)
 {
 	struct eqbr_pinctrl_drv_data *pctl = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	unsigned int *pinmux;
 	int i;
diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index af9d2f3081859bc4b22f6820f3b3753eba36f959..e13ef07850386e70cffc83011589ceaf70a70a41 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -4000,7 +4000,7 @@ static int ingenic_pinmux_set_mux(struct pinctrl_dev *pctldev,
 		unsigned int selector, unsigned int group)
 {
 	struct ingenic_pinctrl *jzpc = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	unsigned int i;
 	uintptr_t mode;
diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index e78c8b3ec245aad56e3e74a26d27c41ba4a98281..30122ca90cbef141ec456ca39ab4eb6f8bc334c5 100644
--- a/drivers/pinctrl/pinctrl-keembay.c
+++ b/drivers/pinctrl/pinctrl-keembay.c
@@ -935,7 +935,7 @@ static int keembay_set_mux(struct pinctrl_dev *pctldev, unsigned int fun_sel,
 			   unsigned int grp_sel)
 {
 	struct keembay_pinctrl *kpc = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	unsigned int val;
 	u8 pin_mode;
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 5cda6201b60f53e62f3f50b8641ec894106111e0..c9adf5fcb1c76445d4812de449edf09878771a46 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -336,7 +336,7 @@ static int pcs_get_function(struct pinctrl_dev *pctldev, unsigned pin,
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pin_desc *pdesc = pin_desc_get(pctldev, pin);
 	const struct pinctrl_setting_mux *setting;
-	struct function_desc *function;
+	const struct function_desc *function;
 	unsigned fselector;
 
 	/* If pin is not described in DTS & enabled, mux_setting is NULL. */
@@ -360,7 +360,7 @@ static int pcs_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
 	unsigned group)
 {
 	struct pcs_device *pcs;
-	struct function_desc *function;
+	const struct function_desc *function;
 	struct pcs_function *func;
 	int i;
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 79814758a084570adea0ea1a3151d186f65d1d1f..62bd4aa53b2b22cb09eacfb05398205f2fe391b9 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -847,8 +847,8 @@ EXPORT_SYMBOL_GPL(pinmux_generic_get_function_groups);
  * @pctldev: pin controller device
  * @selector: function number
  */
-struct function_desc *pinmux_generic_get_function(struct pinctrl_dev *pctldev,
-						  unsigned int selector)
+const struct function_desc *
+pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector)
 {
 	struct function_desc *function;
 
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index bdb5be1a636ead9695410824b5557937c5baa89a..549ab10f7afbda32fadf4ad151401180bed2064f 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -152,8 +152,8 @@ int pinmux_generic_get_function_groups(struct pinctrl_dev *pctldev,
 				       const char * const **groups,
 				       unsigned int * const ngroups);
 
-struct function_desc *pinmux_generic_get_function(struct pinctrl_dev *pctldev,
-						  unsigned int selector);
+const struct function_desc *
+pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector);
 
 int pinmux_generic_add_function(struct pinctrl_dev *pctldev,
 				const char *name,
diff --git a/drivers/pinctrl/renesas/pinctrl-rza1.c b/drivers/pinctrl/renesas/pinctrl-rza1.c
index 23812116ef42682d8ef667525d4f4486c286b46a..70f22e0ef307a02d5b11d6626d297a619f5b82e9 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza1.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza1.c
@@ -1120,7 +1120,7 @@ static int rza1_set_mux(struct pinctrl_dev *pctldev, unsigned int selector,
 {
 	struct rza1_pinctrl *rza1_pctl = pinctrl_dev_get_drvdata(pctldev);
 	struct rza1_mux_conf *mux_confs;
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	int i;
 
diff --git a/drivers/pinctrl/renesas/pinctrl-rza2.c b/drivers/pinctrl/renesas/pinctrl-rza2.c
index b78b5b4ec5afd9879373b406e0b8c391912a200d..29a9db19759906598ac55694439cff8a5ec2c8aa 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -442,7 +442,7 @@ static int rza2_set_mux(struct pinctrl_dev *pctldev, unsigned int selector,
 			unsigned int group)
 {
 	struct rza2_pinctrl_priv *priv = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	unsigned int i, *psel_val;
 	struct group_desc *grp;
 
diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index c52263c2a7b093fccdb38e44ff3fbba0a86d4def..a9bcb3d7c45c269046df0a7d0088a1f48d089fd0 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -549,7 +549,7 @@ static int rzg2l_pinctrl_set_mux(struct pinctrl_dev *pctldev,
 {
 	struct rzg2l_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 	const struct rzg2l_hwcfg *hwcfg = pctrl->data->hwcfg;
-	struct function_desc *func;
+	const struct function_desc *func;
 	unsigned int i, *psel_val;
 	struct group_desc *group;
 	const unsigned int *pins;
diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index daaa986d994dac15860d328c81e28e2c9e678120..dce68f93d2d57f6a6c9b1bf9e1db27393ece8e44 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -162,7 +162,7 @@ static int rzv2m_pinctrl_set_mux(struct pinctrl_dev *pctldev,
 				 unsigned int group_selector)
 {
 	struct rzv2m_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	unsigned int i, *psel_val;
 	struct group_desc *group;
 	const unsigned int *pins;

-- 
2.48.1


