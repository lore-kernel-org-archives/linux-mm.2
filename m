Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37205CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7558E0028; Tue, 19 Aug 2025 05:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878B38E0002; Tue, 19 Aug 2025 05:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FD78E0028; Tue, 19 Aug 2025 05:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5919A8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:43:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08DAC1A049D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:43:31 +0000 (UTC)
X-FDA: 83793019422.07.37F9214
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id C15F98000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:43:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=PN2lZBs8;
	spf=pass (imf30.hostedemail.com: domain of neil.armstrong@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=neil.armstrong@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755596609;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRnvcJ2f2fPQ8sZ2OC8GktyRnLPTrLj3Sq7t/FTrOnE=;
	b=pOZzlcgng+iEaNoB/BxggbamiPNTbM9cXgZYdmxn5XfGrAmYdZuuHfC0i6w8MPyyMubxlD
	Zj80XIZHHcV2Ad2MPqgBw+U+/L+bLvqZxQtjLiZMiFiIex1c5yUxmnTsnrSsxtpZqwc0iT
	egwafck/zGN+FtCq5o8hZmN8TxFgIUU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=PN2lZBs8;
	spf=pass (imf30.hostedemail.com: domain of neil.armstrong@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=neil.armstrong@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755596609; a=rsa-sha256;
	cv=none;
	b=CmO52ht/Toem7Q83ALtwLOZAkBtu97l4ZkF8Bcglcp31UoGz0EOqw3pr1q8en5TsvzhCRA
	Jj9U0l88nQ7Ix9ZShMavnFA3LygyTOti/sOAL2fxA5kjQMy36dEIxiFUr7XNTswb7EDCo9
	g/xOKOHRnPFCbCm+0gcyy+XnqgAeFQE=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b9e4147690so3361266f8f.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755596607; x=1756201407; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRnvcJ2f2fPQ8sZ2OC8GktyRnLPTrLj3Sq7t/FTrOnE=;
        b=PN2lZBs8+JG6P29VRpoDSh+sga7sTjWuFRBfBdEYAIrIQsiR3fSxE5I0HsqY7FDYPU
         7K9VqE8YQvPvf9PaKnxmgghuycvGyRdZ1xMOZLpOYpcx5/HkiHcg+6wFRe+kS6mWTaAt
         gVhDsTUCMWMU6t70/RNpIdpIn7oK36thZXOzqmoweqEsAQ9EK+3LcPMtHVGKliY6h5MW
         DDZPzYZkpfrds83w1rvc/YMw2i7N7NwO3nhIpRyW80n9B1ljzvCRDb46ON/+CKRJiQRE
         ZsYC9nHYscFgZoTM8nI/NUmtgcmybghOrTeDDDNbx8MpgcQ4rfERUwriF5Hd77I4dFUG
         /9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755596607; x=1756201407;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rRnvcJ2f2fPQ8sZ2OC8GktyRnLPTrLj3Sq7t/FTrOnE=;
        b=NfIpawDdNrlUiKMQJ7GGCuCMDWRCjFcbRa/eJqQ/CcXkIwaWUF+kQlGFGo88WTEeGY
         WX61INxkqqyUC/Bvp9jFCDQKJ8A/A7bzRIOQSUwFMaDKwP6vhjmBS+IcO7FYLv7qIfJv
         KEW/UnD6kOUp2WMvwB90BGAlA7+WeW8e9Kxra3gA1mdfLSbRbV7yKh5X3s1DgrDsksCB
         HmUH0rE1pIFjqUEmGoyb1ljkJI6EzK/lcLMTNMgllAjCE7mf2ygSzCI1535ezVWzq+yB
         ahvUCd3BQPjdwKnNlzV7QoeTyhUiPJh4XiVLYCHCDgOTrYQhaP9aAKq/DLrdnDIeuvH0
         iDXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfMp73f+cT9gdjtbalb8BmTJxWZZfqtBhu8lZ/P0A4/XQIRDNgNR0z6FyghBeFxMKEuwqBeqkwfA==@kvack.org
X-Gm-Message-State: AOJu0YyYU4bWy1tJ1pxenx1trhN2SqKmKucbf1Zo1mkee7OvZVflCPKv
	H+M8P6OQwSWR7O3dlmHF5i/nZhJDrIosEtdGlzvQOHy1+0iMP2f5AVYCUOOVH+zD3TQ=
X-Gm-Gg: ASbGncuw59Q6DRX4XE43irLurkuJr85zSUTJE1wd4UEggZN6vbcQd7flVGSbzXli2p0
	Z4W3h3ZhGbGxvsVpB+vosGupjhwl2tvb1zAcHv2HAnbzPWr/BuL/tw6vkVthDcWSmei1h7gTQ4Z
	vXqYVEBRUcvify8IiBdS34/ikZkfhRsSSQG2Pnatg9psc5Ln7dGd+BAUn6rTJz6tCFexR6FKRv1
	K9Z7EgLPL13RtPNB97yMAqEgXDTlm/5RZO4TVFEwwrsZyy4UkDWqpA1yepFO1QF4cHjkSKvNTdv
	Qe0QQ4CarRSfJUYoIOL1j+fzU2ANFnzNJFCWEBJw+pWuYmb2sPhKf9ZFF3Ok9Hfdci/+lilcwCA
	vTpw7hSEoncxQ+rzU2Kowx3qJIO8b6etEuK9blgUv6dsHW6WLmtRIuGM9/u7l2M3RNhMwNHmohw
	xCQoed22w=
X-Google-Smtp-Source: AGHT+IHJcbfoHziYmKYumTTSzX3HBo05hfHJRAHATRASlvGKTD+Scv9wCOw89lV3HUAzWsOF4xrNaw==
X-Received: by 2002:a05:6000:2909:b0:3b7:92ca:2831 with SMTP id ffacd0b85a97d-3c0e028d43amr1435457f8f.12.1755596606910;
        Tue, 19 Aug 2025 02:43:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:e7a:79e6:53ed:ce35? ([2a01:e0a:3d9:2080:e7a:79e6:53ed:ce35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b437862afsm11782925e9.2.2025.08.19.02.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 02:43:26 -0700 (PDT)
Message-ID: <2d576dac-0f9d-4f04-8aef-b3df5f88c926@linaro.org>
Date: Tue, 19 Aug 2025 11:43:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH v5 15/15] pinctrl: qcom: make the pinmuxing strict
To: Bartosz Golaszewski <brgl@bgdev.pl>,
 Linus Walleij <linus.walleij@linaro.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>,
 Alexey Klimov <alexey.klimov@linaro.org>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andy@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>,
 Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 NXP S32 Linux Team <s32@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
 Tony Lindgren <tony@atomide.com>, Haojian Zhuang
 <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <20250815-pinctrl-gpio-pinfuncs-v5-15-955de9fd91db@linaro.org>
From: Neil Armstrong <neil.armstrong@linaro.org>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <20250815-pinctrl-gpio-pinfuncs-v5-15-955de9fd91db@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C15F98000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 585kybgkjktpqpf484pmzhu3bf368c5s
X-HE-Tag: 1755596608-957700
X-HE-Meta: U2FsdGVkX18aGM7fFrbLEX7wQFaSS4TyOSokNU6HbJBcslnUhtS7XYMOf3aFliP0YxTPRXejeMApkrTZXv9IzA9u2IyMygJMnE1Dh2ayj6PWF+5cUk7BBt989Eas/dJdpnXMm1spKdeYHTmzGDkGV9UuuLWYYdMOL7SvWFFcRcomMH+lZCWFfdKgVU7A93kN05cr3diu1KAbZenjrgH3XCU+n2QAlCM2Jy9bokAVN+5bFjOn1AyOnTPjMGZiG0go6LjTLv/T8LbNPefEhW02amBmllxwz0tqKx5TsBORe1e9SzTbTXxL/6ybViFclQEwQZrWVlmY8f4c2UD+WGMXlVuWLM6ZI/9BaJN/9oEwtsmJhTkF8GHtfv9bTZNAlch9hdZSvyeDtCyBb8FIYnqhSaWK/xc1EOeAq2wM/1PgiPJyIEEcm+4zbCUN4qehogf0VQWdXJeNxXy6+ubozmAW+fMscamq68/wN32uxDogrDQhIUV5ZBGS3rW+rPf3Eanuzpte4LRFbG8QSDQaunvK02z4Y1wwwt0IvxjYDdvO91kaYpgTbKYcpdLjdIuqQedYWXWP+93Ho+LSv7azt5qC+oRODb6w3P6tEzDKSeuYnTlVyiZRxtIw5b8Nfqp+saXpKUwW8EUcNZogIShAiL5zcePIAigkE5eQO97NRThsnTDZd8KgTdQb+kazt7gxeKLIa4c59a5sZuRBA+MaVPOIMYGo8qKPq38pdTrqoEU3jjNPTNOvx/5Jf6i8o5NOUN9eS4nogKr6KncajeQkw5rDk1QVSyx4fO0Q9CHTADy3HzQkTnnO3NxOEegkWtkprJEj6eal2Ji/b3K5kZ8LrL+v9y8r+Ai9k7JXuBt70Cc3r2kOF/+ETlMGErDdubYS01Fjb12XCe/YFxMpw3OQ3ursTtln2OsuKNde906TvW3spKFeWILjzuJgwtBwGYgJr/7/a+r2iYxvPqGPblTlhMv
 jHPLynQV
 Rk7LCIVTV4Rd31BrK9UV3aPZw8ss7YVcbOOCg6yA6TyHm9g1YQSAgPR0RHso0Nxj8qAdlhWFLJhOXfMqCb00Ht7PRlak/oer45Yb9873rOW05IwlUsu2zvsPuF3kOvZEbjuYCvohrxDmBK7D+Z3vLdOqvxN6FGqe4HiVfm+DR0uTQ4KBVQ44FDOGlpSODSXnfgI4jsEfQ2GTUiwL4th9dHBMDc6bUExqjfbxA7+AnchOFxUQQsV+XwbZR9QO82PkMVY034aJSSJlj/7ZBxN4sOnKsFx2Cxh2lXaStlD+BgRQTc4YuXbO8OCI0lPbt9VGidhb35N1ze54SpC7Sk4l4YgDSZ6aNrlsANBdSgXueRVWrO+t7Crr5trysA3JtBPzOTt1Pv/hPgRk6VzGWFSFvFHcGVmGMrzdmMnkadYeGR4SO6c1M4wWEmJ764rhaCVTiTUXoCHANEkNo8gXvfGdNSUYUarAF/Gx9NytX56qyVxZrZ3kCN3rm1h5psWV0HA224HvdIUs5ECCG5tupyyfiPjzylh4z5YjRVNFoaxWrzvnNA3wd9V0Y6fx68gjvjVPBLD6ILdx1+cTUSdA5MaWVTc4PKgeB/gzJOGbcjWpfKcRaVrizLcq8xBTY247JjZr7WeJ8fAqtVaJANvL/KZLzJIGaoqYuGUid5atPx++jnpLPT7F/Iq4hiq0qMh2WYnXsLpqRHq+C9HeS8dQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/08/2025 11:09, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> The strict flag in struct pinmux_ops disallows the usage of the same pin
> as a GPIO and for another function. Without it, a rouge user-space
> process with enough privileges (or even a buggy driver) can request a
> used pin as GPIO and drive it, potentially confusing devices or even
> crashing the system. Set it globally for all pinctrl-msm users.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>   drivers/pinctrl/qcom/pinctrl-msm.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index a5f69464827119dfe2a7781b558094b283fca215..1751d838ce95d6138c824b90098f74891dec7656 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -268,6 +268,7 @@ static const struct pinmux_ops msm_pinmux_ops = {
>   	.function_is_gpio	= pinmux_generic_function_is_gpio,
>   	.gpio_request_enable	= msm_pinmux_request_gpio,
>   	.set_mux		= msm_pinmux_set_mux,
> +	.strict			= true,
>   };
>   
>   static int msm_config_reg(struct msm_pinctrl *pctrl,
> 

I tested the patchset on CI, and I got the following errors:

db410c:
https://git.codelinaro.org/linaro/qcomlt/ci/staging/cdba-tester/-/jobs/253304#L537
[    4.056081] msm8916-pinctrl 1000000.pinctrl: pin GPIO_38 already requested by 1000000.pinctrl:550; cannot claim for 7864900.mmc
[    4.061402] msm8916-pinctrl 1000000.pinctrl: error -EINVAL: pin-38 (7864900.mmc)
[    4.077245] msm8916-pinctrl 1000000.pinctrl: error -EINVAL: could not request pin 38 (GPIO_38) from group gpio38 on device 1000000.pinctrl
[    4.088430] sdhci_msm 7864900.mmc: Error applying setting, reverse things back
[    4.100751] msm8916-pinctrl 1000000.pinctrl: pin GPIO_38 already requested by 1000000.pinctrl:550; cannot claim for 7864900.mmc
[    4.107960] msm8916-pinctrl 1000000.pinctrl: error -EINVAL: pin-38 (7864900.mmc)
[    4.107970] msm8916-pinctrl 1000000.pinctrl: error -EINVAL: could not request pin 38 (GPIO_38) from group gpio38 on device 1000000.pinctrl
[    4.126971] sdhci_msm 7864900.mmc: Error applying setting, reverse things back
[    4.139203] sdhci_msm 7864900.mmc: failed to activate pinctrl state sleep

rb3gen2:
https://git.codelinaro.org/linaro/qcomlt/ci/staging/cdba-tester/-/jobs/253305#L1120
[    4.155880] sc7280-pinctrl f100000.pinctrl: pin GPIO_91 already requested by f100000.pinctrl:638; cannot claim for 8804000.mmc
[    4.167636] sc7280-pinctrl f100000.pinctrl: error -EINVAL: pin-91 (8804000.mmc)
[    4.179817] sc7280-pinctrl f100000.pinctrl: error -EINVAL: could not request pin 91 (GPIO_91) from group gpio91 on device f100000.pinctrl
[    4.196265] sdhci_msm 8804000.mmc: Error applying setting, reverse things back
[    4.196293] sc7280-pinctrl f100000.pinctrl: pin GPIO_91 already requested by f100000.pinctrl:638; cannot claim for 8804000.mmc
[    4.203735] sc7280-pinctrl f100000.pinctrl: error -EINVAL: pin-91 (8804000.mmc)
[    4.203743] sc7280-pinctrl f100000.pinctrl: error -EINVAL: could not request pin 91 (GPIO_91) from group gpio91 on device f100000.pinctrl
[    4.235716] sdhci_msm 8804000.mmc: Error applying setting, reverse things back
[    4.235722] sdhci_msm 8804000.mmc: failed to activate pinctrl state sleep

x1-qcp:
https://git.codelinaro.org/linaro/qcomlt/ci/staging/cdba-tester/-/jobs/253310#L1776
[    5.881549] mmc0: SDHCI controller on 8804000.mmc [8804000.mmc] using ADMA 64-bit
[    5.889494] x1e80100-tlmm f100000.pinctrl: pin GPIO_71 already requested by f100000.pinctrl:665; cannot claim for 8804000.mmc
[    5.901103] x1e80100-tlmm f100000.pinctrl: error -EINVAL: pin-71 (8804000.mmc)
[    5.913184] x1e80100-tlmm f100000.pinctrl: error -EINVAL: could not request pin 71 (GPIO_71) from group gpio71 on device f100000.pinctrl
[    5.913186] sdhci_msm 8804000.mmc: Error applying setting, reverse things back
[    5.913188] x1e80100-tlmm f100000.pinctrl: pin GPIO_71 already requested by f100000.pinctrl:665; cannot claim for 8804000.mmc
[    5.929538] x1e80100-tlmm f100000.pinctrl: error -EINVAL: pin-71 (8804000.mmc)
[    5.948557] x1e80100-tlmm f100000.pinctrl: error -EINVAL: could not request pin 71 (GPIO_71) from group gpio71 on device f100000.pinctrl
[    5.955983] sdhci_msm 8804000.mmc: Error applying setting, reverse things back
[    5.975984] sdhci_msm 8804000.mmc: failed to activate pinctrl state sleep

Neil

