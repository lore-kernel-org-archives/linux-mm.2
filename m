Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114DFCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23D58E00FD; Tue, 12 Aug 2025 04:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2CE8E00F5; Tue, 12 Aug 2025 04:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E7B8E00FD; Tue, 12 Aug 2025 04:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADD578E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F0B9B73C9
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:24 +0000 (UTC)
X-FDA: 83767426008.16.DB2563E
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E68640008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=h6vSTiyR
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
	b=5F9nkNeAE2AYIrpibc3SqRwNIF1JAsFMv61zoCVgLgfdxnGhvwcNwyVs3XKsqnrtYSUIfO
	R1vGa2IFVpbUnlhMHK3+//ZiXvIdhd9WHEtWRElEBComPyx5Rle8wsREy5KcMpyi8qfKv4
	mTbvh0RUQJ10wlSrckeDQxDOchOB1V4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=h6vSTiyR;
	spf=none (imf11.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.49) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987242; a=rsa-sha256;
	cv=none;
	b=xtwUtWi6vHS+2NUxS20iSZJ0pIVsrATy9rTxTaniEbI6lxhi7xIDunCW6NDKEeaHd2TNh1
	8l11bNzpVx1UAzoOddE0ahVZTQnAKlFr99iK17cub4FYyN4RGi5KOvtpuGFNTPw4M/0mpH
	41ZNNlg7d9MsGhm3IMWX1GVgzJOSDmk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-458bdde7dedso35366655e9.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987241; x=1755592041; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
        b=h6vSTiyR4K4+YKrgb0HFuD9GqRxePW/rdcbTwSvG9W4JHFmKmbhAwiKANBmftYAHV7
         2SNOVQNRFVGdC6VWOThFbBN/MK3bxuPTo4x77uX5ppcZIMlCXKfCYvYpptGlYYMlnUMZ
         0baljO58KdHvTng2pQ/eMIdbOKKoCFGru2oZL6mywEcHynEwznSF3Izg5kWfOGE0/s8c
         aVcvGkOaJ/w22MU6H5fF8vj68qkC4foXfSCTav+zE8OW5xyJsVgtf7ezUstNMr7l054W
         WozD/xabvRqqCXt1t0YBEbASfRfI2CKRX18pquWj02eVo5a3A9B0or3JcPXEJvhf4FrY
         ctew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987241; x=1755592041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
        b=HUXOjckZ9OR2QZQvlQMAvsS8PcwgONyt8tn4huxf/Ch/hOJtLncxtzhhZmbz8LVxLO
         vga6Zlhb+T4SfX6Qu7wKuMbLx0sqdlOUxRfQU9crpWqUVBIUdwEpmjROsjszbnIr7pJ3
         evH/Kqz8TwPLZn3XII8Tj5MY31G6qNDWLdfKQ2ru769Tja+QYsX1yFtGf92xYMbOBdoa
         JF/jWm82htaafynW87fPhe97bCYXEc7S4Fd/+uiP3oljkLkVR8cqWJ960ZLogAoJn61v
         0+Y6mqBJ2RfYw0MtfE9x/FBw0oMrZXelbZ7DjhQlP3jygev/W1fSJKHK0C0Yg47M0TEA
         vcSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU49XOrt4dPq05m8mVgRVrb+jhGTpNH+ZdIDSjHBLxU0O8WJIZJWuZc6FmfdUE9qQ8ptM/y21h33w==@kvack.org
X-Gm-Message-State: AOJu0YwAhwQgIOOPlI211+y8mO16vaMCSTTOZkkV2pKJgTK1LI/qja0N
	bRL1S8Tne7xzmtMcOFaWoCXjL4UuiShciPKKoalfkTCwMB2p1N4u1Wdn5LOfsws6wV4=
X-Gm-Gg: ASbGnctvNYuZvxLgh1bn1eJHpXuK7IlawKXb64eQ290XwR/EBL4qxWxJ6dJ4brIkwvz
	qwhuor9VNLZptf6040FTmodYkszfYi6KWpPqLYPpB7saXTbNbANvLc/1ByFP4VB0YdKchhwP/hi
	S2bYtZYVXusp+3TsdJ0UW3RI/U+GHd3TyEQa5/UUWRQMYWxuwBWNHhmSMYCd+0zdxLBr2w2yla1
	wm7izuEeNUWseqzIb/Wlr2uvEh0Z7w7RC1jXHTmISFuABjUJHZv8RQqYZHuAapB563gm20EN2EQ
	c8FW+HHiEqK+RfH3lOXkhlfhNO19ksgDBeSnb6RFt8+ypWQafBr8EgyWpEQdHJemXAJFMYcpLw5
	2WEfJSVl5lBndUn4=
X-Google-Smtp-Source: AGHT+IE8fEgiEn9lwBjUv2uob+aBCzOy3kH39g3JVI8xm0JYVluln+IusGsEv24A0i5bbeOMk/kDAw==
X-Received: by 2002:a05:600c:4f91:b0:456:29da:bb25 with SMTP id 5b1f17b1804b1-45a10bf510dmr21937425e9.19.1754987240452;
        Tue, 12 Aug 2025 01:27:20 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:20 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:06 +0200
Subject: [PATCH v4 07/15] pinctrl: keembay: release allocated memory in
 detach path
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-7-bb3906c55e64@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1867;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=qPaUa8oAewMMgl8vCYU8JU6h4WrDoK89nonD2PTBKh4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrYc40u0edePr0EkIpRoNV/l6AhxW+gy+qoJ
 DRbu/5uoWyJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr62AAKCRARpy6gFHHX
 cr0FEADfv+WVcmzOaStfsm70mXUw69iAKQ+QB7ceZ9BjSwzet76pU/4gtWAVho7oelV+euRBcs0
 rI79EvWGS9pbM7J6fBEPxlORgTWjhZ68KXqcPbqBLiBSldQTY1ZILTMVi18urPLCWQ3mj+w+Kju
 4MbUSfSaeCLqLiFFCETd7te4vFDeDMpKmDmKxpTtqBqt8ZFzShFGXV2vxVtYLR7ztkmE1QAI3u7
 DzjZ7r/jkB0IfHAG0G7RyIfDdVHgRGGw/Luhe0ppGZA3Q3qJalbn0K487GB79PLQT36ptT2Ey6C
 kcr9rYtt9kyoaXybtesyYcENhiUdkUSP1StOc7c54IUPOjlZ6EDG7fD72/LrgzRnCtsZ/WADH0G
 w6u6iuLcYQdpYxtED6m7q6rfDBsuzq6tHiZ4w3rvfvjep0xGXNo6s3bwioOPlDCh7ldFD3AEAUJ
 Ulgn9cufPkFGzcCwVnEc0mRvdlTavOeHzjQIt77zX98T6+AGs9rBsIDvYazO+jzAIU0TRSy7QqQ
 8cE/3vgeDgTOzpTxfqdUm1HKwiHEuebwYuXdr2mI50EV4MjJbX6RN0C7XWKJjcLl7Q0l7aZRt4x
 MzKCL1YVBkfo6txurpQA3wRqXkgDFUW6ek8GoVdzy0LtGZirWgtY2Q3RAMVsBav9S02diTip1P2
 w/nGmj49yU8wsew==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 1E68640008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8fxs8bnh1picuwizozr47ijejfwma3e8
X-HE-Tag: 1754987241-120242
X-HE-Meta: U2FsdGVkX18YMwzSkZUQ/SF7kJKfv8dhJMRp62jf0W3iW/vvytn1lWAogVzW5OzPwu+Z1ChWI1gMHGwsdO69JznJlMvg8RB6UiPpmvr2tAGgRxTJUQ8mgDAzOv6w+LBm5VFohhy5VbAoon2ajmD8j/fbhqDUkRzDV4JfJBVbKykf2wxri+1pCxOxEcEJ7EQzUrMQr9AIRUp7ya3zexaDfZun4L+2dgqAdEdfNMPfjZY/8Nx2KfaBugXss7SfiKxLNgLkDlBEON/4Bgmc83v76AF2opkg2/S5vnwb/Ps0U/Ge0veCLw6YuIrgKnm4ReTGERS+q91NtB6TsFQt2Vfwm/JpUf/bBpUEQrKBWh0syhETQSQDayCAFG6kJa89XhNwZWmZnNNAFaUIh5kfLMz7WX890D+l77/InSDxKGModh+ovhO4fAV1gg+/IrZ0AIBlJSi7Tip4geWGA86/qGLuyHI2W50SYaUdIAYS9BWSwfUTXK8wsqQ78/MSbbHFidd1/U6p4ifM7LNTFQ6DrO7ZqpZTqVk+60mZDHRXKHT9FrsakKZnYiO+CjDdUmOgId3OuRxXt1iaO2SnSdUF5ISneSLhoyeviFq6VowOhksSNpKE6k+N6FQIYmb8fC/oqnOUMKmpnpvpo/fiKZN1FYNK1oDHNWYOayKxU3iEqMcYkONZFW/CDiXNbYmPwda94dISuxkYu5/VhT853WZ6WEIVuqc4vEXi2FCOSBSQTM36+cu9qwNsDhtlWcISnS79wYIPKBTWQFEOvKPJw0A68CziAHQ266CBC6ylHrCkGJXAkOawQjF3SJrQFLVk+q2l4xGyN1InNKvhL+BJv628rqc736uUI9XlMRAg1BWhqGQFKGhvjwgDD5psTrC4GoCJXgBq850Z6UizhVTg9WaYB99VnhBa3iIyOSE3GwglHLD1hGxVkhD8+XDQLPxVYQs5qYcddU/Ss3OOUgFjZZEJOnE
 4xuG4/YP
 9nRaz0OkKWETxSgPcbzUxjV5VCEVHbi3Sh5pVe2DJ3IEjiGFwxaBdKdKj50jRfdQDYNwGiyRVv4Yy81kN2AvbhaEFPqBFIc84qi42XpEjrqfwRjCv6kT7JSI494p4M0km5bpASe7rbFGmrWqrH+AGKBVAFHE2gM6CG9Y+sleqtzTWHMlnm3MB3hYtBXsDksB2mddAnCcJnwhinpLbjr+dzLfp05T7iFesT26RiV8szq6OT3XTDmYcTBSl1TRdppbbFLYfyUC7u0bu8PmlbRHknU74bOSLthUQHIxb68wSc7K0907UqhX1/wMFMKsHalKqmiMy/ovmLGzAAjuqnWoiDhcdps9GU73plmuUS56/ju9A/vpT5k8i2roZOHs5KEQdcUQSJ/xui+jvYXfECitvdbglU0W1SrWLB3brLQu12sSiCpwGqk4eOTvnWdnrrR++tdHhvOzAV1/0zXxQOtcO4QrzRyUuIxvZa7GiAOGolmGTCCIz+bU/+nBMMKWpUmijusr4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Unlike all the other allocations in this driver, the memory for storing
the pin function descriptions allocated with kcalloc() and later resized
with krealloc() is never freed. Use devres like elsewhere to handle
that. While at it - replace krealloc() with more suitable
devm_krealloc_array().

Note: the logic in this module is pretty convoluted and could probably
use some revisiting, we should probably be able to calculate the exact
amount of memory needed in advance or even skip the allocation
altogether and just add each function to the radix tree separately.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-keembay.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index 60cf017498b32a9f36a1f8608e372951c2b8f12a..6aefcbc31309995ec1e235416b40aab3e4a073a9 100644
--- a/drivers/pinctrl/pinctrl-keembay.c
+++ b/drivers/pinctrl/pinctrl-keembay.c
@@ -1603,7 +1603,8 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 	 * being part of 8 (hw maximum) globally unique muxes.
 	 */
 	kpc->nfuncs = 0;
-	keembay_funcs = kcalloc(kpc->npins * 8, sizeof(*keembay_funcs), GFP_KERNEL);
+	keembay_funcs = devm_kcalloc(kpc->dev, kpc->npins * 8,
+				     sizeof(*keembay_funcs), GFP_KERNEL);
 	if (!keembay_funcs)
 		return -ENOMEM;
 
@@ -1634,7 +1635,9 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 	}
 
 	/* Reallocate memory based on actual number of functions */
-	new_funcs = krealloc(keembay_funcs, kpc->nfuncs * sizeof(*new_funcs), GFP_KERNEL);
+	new_funcs = devm_krealloc_array(kpc->dev, keembay_funcs,
+					kpc->nfuncs, sizeof(*new_funcs),
+					GFP_KERNEL);
 	if (!new_funcs) {
 		kfree(keembay_funcs);
 		return -ENOMEM;

-- 
2.48.1


