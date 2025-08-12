Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CD6C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79AA8E0105; Tue, 12 Aug 2025 04:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03928E00F5; Tue, 12 Aug 2025 04:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8088C8E0105; Tue, 12 Aug 2025 04:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62EC08E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91506160237
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:37 +0000 (UTC)
X-FDA: 83767426554.20.C8A52D0
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 815FBC000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="FrYMRVD/"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987255; a=rsa-sha256;
	cv=none;
	b=RrUpZ5X7oi9EHpw5rym/n6pH7EXt9R/Vcp22MsVCikGobweCGisdP2VTFNisbxPrmxMwwq
	4BtJVPbdtjUUaXKrUzMLulOTcnVD3qRwCwdkkzGlljIZ5SaBeggesMvZMUd9tgUP6bwKZE
	q6ghPzpb9P4uBnJgodvdzyMIS1lcKsY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="FrYMRVD/";
	dmarc=none;
	spf=none (imf10.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.43) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
	b=PX0NKfi64MVQgu1t32X+8SQVHkd3ywzA4Ot7Rh6ApxNsMksWyhkF7rZ2wtDTlX5VtGvRTq
	ym4RjyBcVlgKcKuTJIZk3dueQpG0QfqpxLxsk+0ojxD4a2vj6ZLVHw2cubCNroQ4lhAM6k
	wYb7V6Q9Xi3g5gDkV+MdMfyROF8z7CU=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-459e39ee7ccso50746075e9.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987254; x=1755592054; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
        b=FrYMRVD/ZkPNnHrVO3emmV6hn+54Mk9UuMpWxie9nPdES9FS0YvToV+E26lIT5xtro
         kvWpPvUe5YyzS417tigsj/G6sGMYrNAO6gNrjTxQ9HCk+Ur3MYMn1ctprT5r88Ng9/b7
         R+lMJO8Stl7DgRmv/BZNVcOA783N762LuYqjCVnQSrja8uwfb0/9S512AVA2KE4phlTl
         W/rLZ/qWtWzQHVXhLLd05JUcIaPL6iub2N1IrHa6SpDEcOpoYAu9753/zyyuQQKCuQdX
         935H/k8bbZDs+ZNh+okv0W4l42lrmnecrAHGy6v6l4dTbf1KZIWX3nac0FjJWYQbpJUQ
         7dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987254; x=1755592054;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
        b=Bz0/hjSM4F3fBluwylyNQuX+FpL20Bdc3m1dON5PARvQHPt/aV6BpwyvpXVQpTPS62
         y+nAWmFyPs+K22NFae45e55DiZ+ae5Ms0zJgWOl64AZj1kd+LRH+c/xGCozG4l7kQVwE
         3fH5gk2vl82Ue+5S47eDsmiEFVqmYuWPGI6k9LEuqglWXDBm1doVjosZx4o5hGMlWWYl
         UvloXWLJ5p40z5z6BlmHNH3Gcq1ndL29b4YtS6rdlhthlj+SsKPAc61L2QfjJAakmqB+
         hSF0nSr9d/MDoj0ZX7Mr4KK2/B+DN1H7qaCUP7q2zudnv08X94nB5jbaKgo2JVv6g0FV
         v4Vg==
X-Forwarded-Encrypted: i=1; AJvYcCWKDGjUhYxfoRsoOIK5BVygi7z1HhgFVuMHv8eZzgqtoB7QqHm4SD/yPpUTOXsG9MHrJBbrp6ff5A==@kvack.org
X-Gm-Message-State: AOJu0YyuuKy/dIpnTUreKnJVaLQLryuHdp4Np3rg3Sz+Ulr8DrsNASSd
	/9GcfXcqK9AkzMYrTml8M7zAUjYjA79waeEnYPJ55NBOoFOqyhg2Wh/pxCHFIqTWI50=
X-Gm-Gg: ASbGnctEWtAalmpq46xjwSI4rLdbGLaOwKt7YZ9GCDDWFSnpuGjOMJ/IHB0FohEqGak
	KXCwxME1pxJEB7BEknkjeFY3huXifLAJ+7YcoQXFLCQQQCZcZm19kUL4C2eHo/mGWd8vwtwjkZn
	I2Ht1MjyhK+HxORnSnh92gldNcs5xUA8KAZ8e9jWCnYjlRWNECoH3epzEoTdq7Fi46qntwBnv8i
	bmsyOaR/WiTHouKN/iqULZJIZn6ZeikGk8kuKCt1I2BhSc6s1jEKRZUwh+6M7/whMqo7s3Ja8wU
	oGS/4KCKTkLAdn7py2OWra9EDzH3E/cFQF1kHNqWCAMSqpRAdM3KcERpyt4UfGNm49q9Uc+PqkC
	Guok5yQhasnUFIqs=
X-Google-Smtp-Source: AGHT+IEIkGK210eX4oaAWTvIndQdBKgODaVv89WdHuLZ5yZCYfAUy5DwGLKFKR8W9EpKo9YtXUOSDA==
X-Received: by 2002:a05:6000:2501:b0:3b7:7904:58e1 with SMTP id ffacd0b85a97d-3b910fd9b5bmr1926776f8f.18.1754987253948;
        Tue, 12 Aug 2025 01:27:33 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:33 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:14 +0200
Subject: [PATCH v4 15/15] pinctrl: qcom: make the pinmuxing strict
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-15-bb3906c55e64@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1142;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=M6AAfE1ZYIqFZsBoDZ4O1bJllvK/6bMXFJ6Zryc+i/E=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrZaBmeISpiHCVh1NKR4JJvKfvoR7+4TGM34
 qACMSZiq0aJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr62QAKCRARpy6gFHHX
 ci+8EACxohGvZiGTBr0Y9QxyJzsEN0JDEuMPPP2/XSq+kOTHcKkmHErEtvBcohO7KLJzJuDM92q
 Iw3+IzM052WTxd4daM2zpMgweo/2dwzZfR5YEUer3WEroEGm+Bj1fVPmMiit7p1Urk63XsoIjrL
 iIqOXmtlteGyRTKCzz3k/xmfTyEyU7VBHczMECuT5uEu155Bu8nJCumD+wzbe8mmIlfgHaOMDUI
 EhNzoSXVeYCY0FHD/wqktUBCPUxVj3EGM965wJpVDJiroVIyzBPsjcH9gW4ZMI3gsrpLkKSn7/b
 B1DQKX5Md99KuFnktDMJfMeRA9VTUveqdFKrzKWO4O1PCOiNZYTlwh/00gXu8zMpM4AK1/xeHy6
 xv2CMDqxOQQE9pNYsgFWdMK5+GZYlQTAYrjZncSo6RYTzLN9weKlo0cKuhBe3wUVAZQntaTYy8i
 k/Zxwl8sT/axdwTsi8ewRtM0DJYHR7QWCXofS6dAiEDIgSKdzkZJ4mIec2cmwKInyd1Ja38qeyo
 BaUmY5FfX7ADJQDEVQD8b/C/oeUP+bk/MkxTefH5hvrw5RZW6Rm5jF7NwkotqyJwbEKJFZVea+T
 cJiJ5bAYHdIENT0OWfDZvACcGaK8OCdLW3UJoLXH1IZbWn2imkJ1JInadg5ZknF41i/olNLfmrS
 vdUH6mCryqoAAIg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: jrg6w68c43wdj1kr363zaki6h1raqeb3
X-Rspam-User: 
X-Rspamd-Queue-Id: 815FBC000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1754987255-261679
X-HE-Meta: U2FsdGVkX19v8aj5iue8t0YqxLYMCw4eGGkI/XHYWSs6ml7U4lKU4trjdALdMRkZZ/7Rp1nODqM+af9ImbSV3jnHpkk6bwgF5z1jqAU/wWdAO0vIUXSGRXXYA+Sw7lfuEJd/A1UtznZmnJkfT6uswhc8IvAdFIGNICqOWhS5n/VcgVOxyWjfBqlXcoR8zjV6q9Pk8u1E7+txL1R8oDNsBjTxalQkt+7gtETmHCLaIqi21w3AdiWET9xsgXiZs9PHe2eHCuu+0iZ/Hi9V3/9FUlobez68hhuvRPSNSD49n22Si9bD0hdTkhS7dwa0lRc2pXN8drh454634NKF2EWFXxGt6HRDfnT3SqOm9FYZS85Ob3ZQ8cbl8IvipjcSHgyx0fHPwxCPsgPh4ZN3sd9dGlys0SNyCCuCHeCJH0Ib2GR8Uhl3VrnkpWovteOYKH48Qx3OahBpKcgO7usc9TrX0Ji43CdsNc+hjRVCSYp8y+Hyg33HSc8MZdIxbOsgVy/5tOnfUufbg07TXFDiPmavGJW1RdkFSUIhSHHoXeqwlbajFZ+Gaast6ShwqxJ/K1wz4JFFeaBWhqfE6VELQa0gptbMCJnYaK69Uqo1i/Qm3hj3fh68eZR1wlvTIUjv9bxsFqDRA+6BAuSYXPhM6Wx1V3TCFTjVxGau1J75w4AZzpIHEIPGpY2Sp+z0Ow5rxNGvafK4DhMzj+MAUYuniEPpKlGNnGhC4qE+LyyosRfyPcElJnx1ozwZsJETnNE1CpWAcFPS6pqVmkBrxha8fuyRYllo38MfeJ5g4mtd9bUYJUPLX92I7UUPrLP7XJddGZha0Z2hjETDQY7yQElQvFgJFyfiOODqCsXCkCcs8Bk1gWHtVSxMhXpOxHVg9ffOSlZsXpk9p+SxZNLT/pwfi3VuqAjQEjHyxSGulYcVxu338cSjtoMy6EcOP/VncucHpVDEjFdKBEQWNFn/pfOWDrx
 n0oUj8aX
 8XjkBqtyWAj0kS5HAg2d6ZDnVxGtJDQvSyrDT4JDu0QB7iTgeHuV7mxnxrK+8yLjdUkgs2m8510IDfeTGugV2ENvzAtd3n7x7FcWHe64aTkMqryf/WNGUSDEoRHsmd7bcqPENCgjd1BeNs4T0X9LKBm/fCCls4NqUHtukuOuXetkQJQ5BVlAeioTdfGROPphG9djQ0CE2mfHcdWzos8tNDk+HR0qC7zpkSlZi6mzKOwAJLmlcNGR2UCS0AjaAXjbhgMIfBmSlZlRZvpHpL6qVo5b8vk1uAu42uj9KcH0aHc0hVIV49qKGehFLLkx7tEo+/3teGA2xigADiiyLoxayMwP+18i48Z1bWzVNJrL313UvCDisL83gBDIevZCjVwkPjz3X2rBIRCJEmq5I44dJHAC+hvnh2CbNUhxGjG68JKMua5qFrF4t0fhCNZd+ToiWhpFGD6oioLzO0VGzcLlYmIoPgQ3FCO+ThZ54NVvXyxiYChpCY51S7R5hiuY0uNmyLlMEFVHwOZKgkIMmcaFe6k5NTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

The strict flag in struct pinmux_ops disallows the usage of the same pin
as a GPIO and for another function. Without it, a rouge user-space
process with enough privileges (or even a buggy driver) can request a
used pin as GPIO and drive it, potentially confusing devices or even
crashing the system. Set it globally for all pinctrl-msm users.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index a5f69464827119dfe2a7781b558094b283fca215..1751d838ce95d6138c824b90098f74891dec7656 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -268,6 +268,7 @@ static const struct pinmux_ops msm_pinmux_ops = {
 	.function_is_gpio	= pinmux_generic_function_is_gpio,
 	.gpio_request_enable	= msm_pinmux_request_gpio,
 	.set_mux		= msm_pinmux_set_mux,
+	.strict			= true,
 };
 
 static int msm_config_reg(struct msm_pinctrl *pctrl,

-- 
2.48.1


