Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01774CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E43A900232; Fri, 15 Aug 2025 05:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C158E0002; Fri, 15 Aug 2025 05:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BECB900232; Fri, 15 Aug 2025 05:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6278A8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DDF0160882
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:25 +0000 (UTC)
X-FDA: 83778418290.08.BE37522
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0BC4F1C0009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=O01OVYZi
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248963; a=rsa-sha256;
	cv=none;
	b=onBeq5eYJziqhoT3ImwM1ktX2mZPqiuqkpDouGyhooneCpUXV43KQvSbD5Z21hqM+Fb01c
	Ya/FfYOlRnVTr021eQ92uK/ah9ny87ICWBxfe89BpgOZpuTBwxEO8Yrzk6PdEI8BmGdR51
	sYfg4DlFC+rEa755Mg9EF4ysEZTuilw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=O01OVYZi;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.52) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ojzj3QqHYKTtweaj0hMdOf0hJWBOPE6yGgnAHCkCHqs=;
	b=wPNWD0ajWusSBX15dHqpYf1LEeAB+xvOeP33T6FylJCN/3t6SOczxf4TJoRGHw78l10WcT
	2LT616mhBzyEjibqwaZMxtoGP3/KqcO/wvy8p7tlaccdJIsJJO+KE1Wo3MScUYf9O4L50b
	DqRxsfdmau+iuF+PPvpOiviR/eommnc=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9e411c820so938278f8f.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248961; x=1755853761; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ojzj3QqHYKTtweaj0hMdOf0hJWBOPE6yGgnAHCkCHqs=;
        b=O01OVYZirmxy2zTu56+FU56/IaYtVri6TYrWNHHqD9t2zEosOYmFUvz2BzWxCzGQo8
         juTwYWVaZmr+bwfBVXOP6542T4oWy58m5Zw6GfRNrSct7kmGH3Lt+I98ltr0TpVpvC/u
         CDzAI9ab5PXy/i7SromKM4y3+DVESpwn96fU00qjd1KVhJ1r6ZTs9HPoq6MZoCRWGV+d
         hOCBNPbBbo/hkLbnD62LJgMBExMUbo0muNO9LXLYXJle0yVwmzxOnG46KZoH5Q5wVvtW
         8JG6YAsDWq31vlfGOl3C2YWr/9eZ0aSG09uU7yftFMFaoWzWd7YLWOlgpFPuCnGyQ52i
         782A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248961; x=1755853761;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ojzj3QqHYKTtweaj0hMdOf0hJWBOPE6yGgnAHCkCHqs=;
        b=jqTLsqhK+q7sPRNUA3lMlXZ1F2tH7i+IvUSMrDiPzNGDNH3gsH9dSQ6SGQvUG80quv
         aGavuvB1r4SR0DVAhaW2Ix8j1sAiY1i7GbotthQV9J2RiZnZouqKN84lCyTe+MaxVqD+
         MtAlJlej5W47/nDLJGuGjIyqITreZSz14JL3pYKAy8958/1awG1opTckebctldGvuUfc
         OIBZNj5L2Fwvz+urBA12EDP84mfDcxQBCdv8irGYOAm/c35Oz9UZQEr6gTCkLTpuguFG
         4E5sSSDPQD+j+k5yHRwHFO0kQdkiPeZdf8zruXnqjln9Css09p5bB7hCDZObS0reL3Xt
         uROA==
X-Forwarded-Encrypted: i=1; AJvYcCV1JGW1NgscOrYIb+uJUuK9RGi0H6LlFCuJasYvFtEA879lOP+5sSsrnyO/opoWUnbns0KaxYxWdw==@kvack.org
X-Gm-Message-State: AOJu0Yw6++SR9EiajrQwiE2QCYRf9cgyhbm0sk+S4z32lJZIYNLbs7Lr
	dun+4Pq1qvcLcRSNUBn45XldpmLnds6PvjT8NYKWkpKyEJOeRWv1+S0oNaFRY/aim7jiRaZ5FbK
	PoW+j
X-Gm-Gg: ASbGncu4hS9W4Vkzg2Q0MTQn9rmPzdhhTvRG6/OPr7KLV/hQrhon6ddDLMZTJ5KZPRK
	uUov6LvUMt1mv0Buhb6vYp/Dfr0a9tBgaEQzN9EVR1qqat/aWIy8QRWlkIvtQ2RBzBDOJlg8hdp
	Nssq+g1b2rcMjw5QNbuzFJlOyex2dm4reNpHlG2iPhW8CXOlYsLY64U/DuNvdb/ACSS88VsyzSU
	K9Vd3Nl/trnfg3XmLznSDtHoPNHC0cgtJZToTTucJaWpzOyJAHy3LHqepuAwUCNAdXajQrZdwhs
	w4v7pCGfVlu52b82PIb//McKuCFqQv3JKYbTCviEjy4+rXCOE5d4qVP2m41ke15ZKD4EKFB9Nk4
	yNBxqqslVgSvtWzKRjQ==
X-Google-Smtp-Source: AGHT+IGtmJEYn4U7YmpLO/UnNwJ6EK4RcP2OJYWSbB46JlVxedVPjM8m1PM2GiWKy64gcAhtC/Ebng==
X-Received: by 2002:a5d:5d07:0:b0:3b7:9c28:f846 with SMTP id ffacd0b85a97d-3bb68fdd74dmr1039764f8f.44.1755248961432;
        Fri, 15 Aug 2025 02:09:21 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:21 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:05 +0200
Subject: [PATCH v5 03/15] pinctrl: airoha: replace struct function_desc
 with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-3-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2038;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=Q2YZTvBFgTu9mhuvELDYkYIT0089SG8/1kg34izHMkM=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk3wzetzN7ylJyavj+6V+c1QQuTYpigZ2o4z
 l90cHMgWUaJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75NwAKCRARpy6gFHHX
 cnvxD/0Ve0I/ieyHdgZy9d8hX4H7/zjce73ldaR9BK31igi4keB/jOhJI9WaD35KudjwoaUzGzw
 jgISznL+LSmsieGquZ8+gBRfeDFsk/QkyYOG8K5axtVVBr5cN6yvlPqE/3RsS+N+YTgyNuGbLz3
 3D0Kvx0W/BbHBYyiXduuXF0w47ZAanPPQIeTTrF2XJiwoFinOe9POqsFSEH1DnmaToCgV45o6uv
 XSFDNLIp+Xagtc/kXU3cGEPdgSqKK1eYR6znpNollDIzo08v+FU9a8dgAshxGM8OzP0F41sD1oj
 uVAI95wnWjHnUI+ljFBaGnnfo4fBgC/HqrxNMWogKyTUPZLR7IA9jvGoNOs4EEBDGL8GRCUfiMF
 KyL7e6DpCArbWK2HEuBRlZKngzG0Oa8V9FSW8EmH5qdI0soJjorpMeZXpmlMeRELL/NOoJZAhY2
 nFfZvCfD1+NjIN3pugMpjt8A/DRMSOLMoplZdIiG0tpHth5Qz+TmjQ4o642CundaDH99bRBb7yo
 4JM20LonHqzGzEqmyQ646wKUBqzowVpaLSC34ilA9XcwWx+OhyylRqAsH4mQf2VQEB0iko2OJxb
 X3jX4SHTXbdKXaoel6+wXODnpMTOBXpFUcWMHQLRNdqjv7BRt25Q9Eq+BqDBJtgXr/2udIPVNkE
 dmGtDLVs1fKVjTw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 0BC4F1C0009
X-Stat-Signature: sbxiqw85d881x4tztnink81c4bt7nnyy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755248962-625085
X-HE-Meta: U2FsdGVkX1/MjFrSU3s9ZBMZg7wMzkGnmd9NpRKs1AqmQ813YduZYwRVBvpIi/aCQgZhV+LDsfPlM1/DBABM05BrUBrSc0j/2qdjNkDP7gsnuJxjvFBIYksg5uvJtPPqxdCyTi1DyTHzjHmheHufRXigEBToaJRAp/Rwr1mUV2tyj1HGKuDoxjktC93ypX8c/qeJ6NPCHwQiEiGDBTxd0uwQhPEZzAjp1N1caLgeH97o72oQMwHEzSot4uVfxyMI56cQauWgtd8FpyU7Di+J4KGVfAyO7Ike1tyzrYkFoqMW9YXFE2ventiV6FTh4qlBA3urKF8Ano1gVeg1HaDRq+hPzUKaE8zJvgtGQnLFIdIOhONMmiD17MnzejDc0pA2qitHmCPSYLYrvrGQ3Vl97tJzvAsQ3hTpUJmVdXS5oRRzjm62dMPNZ6thg9VvJiC5fZi8WnqFOD8EUrDpO4Y+LIHF2ZA73mpbCSUWS7tsc8gxPnq0BR9cagFiVuSmyCBwFHX1Do5oSn4VJ3NymVPiZ/Vq5R+DxKFxtbG3Gbp5lqvj+HWBQ/xPjxUyCIzv6gc309sCXCHsGpCd0xm2GekCV+3NCNxl9TJXmr68qGigH7XatBgBs3rE68OgAHqdHY84NJ7wcmk0Rv9PjOFsTzRZ+Hs1XD2V/LnsOuBxHYsdZKjn6HGxOM27FzXSZfkLPfuMiJ6anCXR9nBnv+bzpDY90E9yczTjJ4e7lmkxX3WB0Nl2lKDcuWQ+oisH2DOuA3T2kTwU7NIovy33igjGOrZLpoGyuP/ZiXURrC/EDI2BlVb3vdyrbcESRm8Y8nDM+0dgkhMa6VfGfN/37ZWTaGtN4aF5FgA2pGzg6XOYdEROJcpuniLlWzwd7niVHcEp3SJKqZSZY4cwRvzwBtPENmXXW8r28Ljy08A3YCt9kTiR1CAgecKGIFag7+zmJrXNi+kHHL3f7jU76haQqjZi2J5
 VQcT82il
 IGCWTzUtfS7jZ2oFg4zjfTWzcV9uZizhLlGR1IOJKgkVyxv1xi0yE9SB6ih3Y+m94r+L5T1RiioIfR3VhzTiXzd/H7Zln2tQ3VnTMKNCwQeO+KW/5VePqjKCKlA65Tku9k6wwlMvoPAtx3v0Ryo7X+h3f5oMMsXAoWIDGMyg8sxkZJj3i8ExjfoYpqClN4q7GaYvzVysUJOSAWsWmcGfEhVQszQe2HxSP9inB3ldyMRmZRMmc3GNOCYScBaT9Fsg+QnwmprDHHTJlhOKzYMv9/BV+squbCzlaB9OF76pNYtF+nSfaz01qf/YP9Xcio0cbx5/oXm4w4BE/QmvoahWY7nMEH6XHFlYMYuY56tkoieBAMPu9QojeISNzIPnidZdP+TBqaTpgmcRoRBlREueNFcryG6lIU7S/Y0qAlzY4FTU3Jp0t15teuD5+QDS7aPQzpwZ4Hpa07zWc5h8j0eHmYhLHPWxHsjKomC7uYJDbbgBmo1bEFqiVANe9fYGkYq+znV7QBE750/cir9LH1EnkCOXN43nZZfXPWyQURFHzh0B5IqhoGxCmjGD0qvqzvYZ/Sx4dGOIpj1P8kfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

struct function_desc is a wrapper around struct pinfunction with an
additional void *data pointer. This driver doesn't use the data pointer.
We're also working towards reducing the usage of struct function_desc in
pinctrl drivers - they should only be created by pinmux core and
accessed by drivers using pinmux_generic_get_function(). Replace the
struct function_desc objects in this driver with smaller struct
pinfunction instances.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 5f1ec9e0de213d587b68f41d3458cf504ee1b21f..eb6cd27955fbe462f479fbe92c785588caee5ebd 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -35,13 +35,8 @@
 
 #define PINCTRL_FUNC_DESC(id)						\
 	{								\
-		.desc = {						\
-			.func = {					\
-				.name = #id,				\
-				.groups = id##_groups,			\
-				.ngroups = ARRAY_SIZE(id##_groups),	\
-			}						\
-		},							\
+		.desc = PINCTRL_PINFUNCTION(#id, id##_groups,		\
+					    ARRAY_SIZE(id##_groups)),	\
 		.groups = id##_func_group,				\
 		.group_size = ARRAY_SIZE(id##_func_group),		\
 	}
@@ -334,7 +329,7 @@ struct airoha_pinctrl_func_group {
 };
 
 struct airoha_pinctrl_func {
-	const struct function_desc desc;
+	const struct pinfunction desc;
 	const struct airoha_pinctrl_func_group *groups;
 	u8 group_size;
 };
@@ -2908,11 +2903,11 @@ static int airoha_pinctrl_probe(struct platform_device *pdev)
 
 		func = &airoha_pinctrl_funcs[i];
 		err = pinmux_generic_add_pinfunction(pinctrl->ctrl,
-						     &func->desc.func,
+						     &func->desc,
 						     (void *)func);
 		if (err < 0) {
 			dev_err(dev, "Failed to register function %s\n",
-				func->desc.func.name);
+				func->desc.name);
 			return err;
 		}
 	}

-- 
2.48.1


