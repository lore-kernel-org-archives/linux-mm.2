Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B26C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74BA5900095; Wed, 13 Aug 2025 10:17:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72328900088; Wed, 13 Aug 2025 10:17:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638C6900095; Wed, 13 Aug 2025 10:17:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 538CA900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:17:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B9051A03A0
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:17:20 +0000 (UTC)
X-FDA: 83771936640.26.FCFF931
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1F37440017
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:17:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=u4SYqayv;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755094638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=xFS6u4c/Ebcc668GacdL60NXtwjSwFQiJomUL8MmBtI=;
	b=CUgsicB+2W4tb2UplhZKy8y7rc/NpLIdCNb8ljWfHkkIsuacDwmuiqSuIUuKg/ODfJtCB5
	fWEPZA67kytuqvjGBskssaj8vCSOqtZwUjjU7cZPeHnpBQ3Y8iTSnJ+8haG81qEnxiLRke
	IKW/r9o6eUoaV3lWzLMHcGOzcEVv2m0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755094638; a=rsa-sha256;
	cv=none;
	b=d/aJ9oXd3eZuZd7d6lwPhQrXNl56spoyuWNIkl2B/VqOn3j4K8vNYkAXe1zBI2BsW0YKbI
	nC1vCQcbMaSzTLpW8J9Fjes1aATEBIorYOZ6+efU/1nuwPIFFzLGovpdiavC+eJ5awI7T4
	05bC0YXiDHZdATZVt6QV9j2MYmE5gCk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=u4SYqayv;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a12b3f4b3so14626205e9.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755094636; x=1755699436; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xFS6u4c/Ebcc668GacdL60NXtwjSwFQiJomUL8MmBtI=;
        b=u4SYqayv2LmrwvFZ2v7wwIMVRw6oyq6ZNrOR1ggzCpdSuXGHtROs6kYhMH/MlDp/p6
         M/JgR3bIin0R1qPoEO3xDI52TlxXsX2UEmA4Iilu4x1aJNR3UjA2gEItON0lINTdmlEU
         1+U3ZHUW7+Hbj0+6cV7qDczTrOF31AJELH+EeZMMQQXMcmL3tMQcA0Z2n/WpUGHWH82u
         bb2tH1tyDPS69dThEntdaCdgDHyzA2sSCko0Y0Sp/WaxYn1n0c/4kjoqEDN17VuA26SD
         HBVe+QGdbTD+QLiL4uP0mLDTnBPGskubev9FkjDKftS6YWO12NGmaQRuZKOPDQODlngi
         6gxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755094636; x=1755699436;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFS6u4c/Ebcc668GacdL60NXtwjSwFQiJomUL8MmBtI=;
        b=sAZFq4IoDr3PU2JevRzz3o/8kbfMFTIGsDvQhVExFPgUvBcRJYcWTy1FHsWvQqwibd
         1BHsbTn/uzrMckmi34xDrYGeDpVgFfi7q5SiuD3peZ+tPCS/fr3m/ihGrKWhVWR0FzEC
         aPKomNtAQcHTA/FDj3zlwESoZk/D5Lw4fGk+6KuwIvpGSpjTj/IPLdup/wdQUN7Vzt1y
         IQlmxtCSSYMFqj1ZmB09F4c3ppB2jG5y8Sp53QVvBlNvCcrnyW9Sas+9XOG+2UkGBwsq
         tXw1LIrm/vUkVPxLMMc//UfVKBvWRMRJgdbGhH76gow0Asu4wfIFPZwMVM/TTayETT72
         Dp9g==
X-Forwarded-Encrypted: i=1; AJvYcCXUEI2xmq8HEnomRx+3Xgna0NgoPL85W97nZdefSd3k9Dynp/9GMVMZ6n0eJiDE1bWn8XMX9Ii86Q==@kvack.org
X-Gm-Message-State: AOJu0YzuZyeUxq8dHHNc+A6rrzaPGh/3vK7E2SONdfIKiykU9pP3AmEy
	qfNEhVdz4jm8pHeavZcVvQ4xqNXODq3lFk6GWLHyAQ2RiGT7qOCVnsvRtHlRB/1XlU8=
X-Gm-Gg: ASbGncsTD1BroN6dp164o8KbInq70CBPf3Plr+oxh8q1AU3Ol9Vn6xOrqr28brC0YaC
	LkPKm9DJjQsSLvefjIErrJ3+vX9eCVqat5tgFEQOna5n7zE5ng++aWJTM9N3YVMtU23u4pS5Vgx
	zvIXHQesD1v5P2asNg5TAqTxhAwiwYnn2HmqAe6cJ77Y8wiMxpt8xiwYj+HcyEMnBp2SwAEgAXJ
	QL2uoAEToieVbECmiLLYT1P8AllNJJCnz6AtEMgijD2SeC+lzg8G3OfX0YAaGWisDbL6AoVeewk
	SoWMBpxKt+2A1wPW014NXFtMnJxg2iy1h4EPMllw/eQPwmJWDDcNn5JDd3xcNtZN+9gJD+xzZ69
	R8Sa8I3fjYL1t8Ks27QIkzTk746HxUcfo4il27s4rAL8=
X-Google-Smtp-Source: AGHT+IFQVKMSuayh/HxTBQ1FEx8ZnIBjMw+kNTZelmm0ds2gq+mUAt7QOMh3QsWj7BFZNdcmdXCzEw==
X-Received: by 2002:a05:600c:19cf:b0:458:bfe1:4a91 with SMTP id 5b1f17b1804b1-45a166350a2mr26900635e9.20.1755094636463;
        Wed, 13 Aug 2025 07:17:16 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c4534b3sm47750500f8f.47.2025.08.13.07.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 07:17:16 -0700 (PDT)
Date: Wed, 13 Aug 2025 17:17:12 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Bartosz Golaszewski <brgl@bgdev.pl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sean Wang <sean.wang@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dong Aisheng <aisheng.dong@nxp.com>,
	Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
	Jacky Bai <ping.bai@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	NXP S32 Linux Team <s32@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v4 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
Message-ID: <202508132044.XYcvSpm4-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-12-bb3906c55e64@linaro.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F37440017
X-Stat-Signature: jg864j9nb8ftsfudkfxwdic48iqmx999
X-Rspam-User: 
X-HE-Tag: 1755094637-547895
X-HE-Meta: U2FsdGVkX18+d+qZLjLMK4kBiqxCBJKwo74Gu5qjGQCnplW9ZGVs7vyxNT2I1W31cbQuhU/OxYyBmL6rG9x8EMnTEjdCfqDot2cR+/u0XUXY3j/VIxQuPwFAB2tNrSfve7D36Q15ZZGNfKNHMMt3SVZzT/B8YlAA1cfZbcwL5Etr4Kj3QqSVTtdrl/FzOQxxX/Sk9QPYM95OWBYhXlS2enNQKB7tujxutZ13qCNnQVAk2mMq7hvkGVqLDViP3iIju5CkXCtTo+e5nMFaBHnYj42mwOQbSPW3WnCVZthsft9zdBgEqSzViEH3nCfaUxNg2Tf/3B0ccMfPYcSdQ8orFYJzS/KBejtZOs/MN6dNQyCog3rExalto2NNAixX7dmaypPBFBsN+f420L6P+1FbUMYx8jGbyNrcgy56UBZkkTnkFzXjiIqlKkbKBURqyOfA2mle9Nnk2FT88CEnr2xhbhxDpcUMXJNcxMX28WAY8+lA2ZLvInq1Y8xxFvweO8V+tS43gvav71XOfqhOR8YdXcJH2caKMFhNz3Q0jFxMwssIcYxpCw7utQ/LfkWPYv+qyA7FtfPMLafnOmqz00p4PQsQomyd2hnVZSyET7DG3nuL/qsZddd8KTVYjxuXgxlUxHB5PDolvK5vZUSO8MJyvTnByVcBpLBt/1oRDYBI4x8lcpOsoH8im/EQhGZ+q+k6VVo5dPZ1HuqQNJXgHNkZ5XNsTCJ/GT61rRv6LgWrxedMV1/+VdeJHnqmo56AhTfFnjhRqRlclUkMiJhdEp7asCnLSy960tQu0XeXsBOtWDbmtbbfX7jRg8OakfflxqU4nWBv9sUhSgzoaqvDE7s+MZYRIwc4/lFzQheQOux/55uypoIV9ACpLNNym7nvWS2sVhi+5w8RSEA098W+XghjMXVGQWHkqUMtCjBr+z/4mIvopOm/B0ypK0C6NQVrbysBLKVoTU6FX3A4A8fYgLr
 4+4o6cpQ
 +nAFxES8uFPFyZ3UX2L5lYZgLp3KBh15ITTKVSyCX419sK7vF2treN/qTa/Nr7hw297oJh5jLb30yY2rDlHXfQlZcEKlgy/BwJsVdbgUYWXYPu0UmDTQFdbFsxuGLffQ1AzJkiZoID80oYhs6WROXpL8D/KF6Zst6USbfygohDKuRS10FeWcbltl95ZGxdjM5Ved7rYt4o7iHl4gRgsFWJF2FUzGaYclHq4jf4dUkRbiGRhJa0IrNbLSJbKQJTxY9uVXAHYbQI11vzUbnlNghZ/NLEORLgXpKB/AsjGgdJPK6o/Hv+mGMP8iZG4Jbk6COWVLXigE/P1bWkkSs4S7cBcVwok84HKB/FjSunIoudONEg/JJ+DMpPa02zgK1aHw7bfwiWt43VP4z33I0LJzCjHZs+MYiduu8ll/V6ll81j1KSBhpLknX19hxQNpwnfBCuP1yl6RY+mFNFE7y5rNpUm6SwJbay8G2GZyPT5FKfOzz9JGsZqc0yKZSbYmoaKFfjuM2X5zLlop/b+bIa1mYPBzhYgI6teli3NNmB4+RyQ19SPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bartosz,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Bartosz-Golaszewski/devres-provide-devm_kmemdup_const/20250812-170336
base:   8f5ae30d69d7543eee0d70083daf4de8fe15d585
patch link:    https://lore.kernel.org/r/20250812-pinctrl-gpio-pinfuncs-v4-12-bb3906c55e64%40linaro.org
patch subject: [PATCH v4 12/15] pinctrl: allow to mark pin functions as requestable GPIOs
config: um-randconfig-r072-20250813 (https://download.01.org/0day-ci/archive/20250813/202508132044.XYcvSpm4-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202508132044.XYcvSpm4-lkp@intel.com/

smatch warnings:
drivers/pinctrl/pinmux.c:96 pinmux_can_be_used_for_gpio() warn: variable dereferenced before check 'desc' (see line 92)

vim +/desc +96 drivers/pinctrl/pinmux.c

7cc4e6b0e4ddf6 Andy Shevchenko     2023-11-29   88  bool pinmux_can_be_used_for_gpio(struct pinctrl_dev *pctldev, unsigned int pin)
472a61e777fe78 Stefan Wahren       2019-08-14   89  {
472a61e777fe78 Stefan Wahren       2019-08-14   90  	struct pin_desc *desc = pin_desc_get(pctldev, pin);
472a61e777fe78 Stefan Wahren       2019-08-14   91  	const struct pinmux_ops *ops = pctldev->desc->pmxops;
6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  @92  	const struct pinctrl_setting_mux *mux_setting = desc->mux_setting;
                                                                                                        ^^^^^^^^^^^^^^^^^
Patch adds a new dereference.

6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12   93  	bool func_is_gpio = false;
472a61e777fe78 Stefan Wahren       2019-08-14   94  
472a61e777fe78 Stefan Wahren       2019-08-14   95  	/* Can't inspect pin, assume it can be used */
6ba2fd391ac58c Alexandre Torgue    2019-12-04  @96  	if (!desc || !ops)
                                                            ^^^^^
The old code assumed desc could be NULL.

472a61e777fe78 Stefan Wahren       2019-08-14   97  		return true;
472a61e777fe78 Stefan Wahren       2019-08-14   98  
5a3e85c3c397c7 Mukesh Ojha         2024-10-15   99  	guard(mutex)(&desc->mux_lock);
6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  100  	if (mux_setting && ops->function_is_gpio)
6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  101  		func_is_gpio = ops->function_is_gpio(pctldev, mux_setting->func);
6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  102  
6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  103  	if (ops->strict && desc->mux_usecount && !func_is_gpio)
472a61e777fe78 Stefan Wahren       2019-08-14  104  		return false;
472a61e777fe78 Stefan Wahren       2019-08-14  105  
472a61e777fe78 Stefan Wahren       2019-08-14  106  	return !(ops->strict && !!desc->gpio_owner);
472a61e777fe78 Stefan Wahren       2019-08-14  107  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


