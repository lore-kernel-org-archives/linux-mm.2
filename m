Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A098FD8FD7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C246B0162; Thu, 26 Feb 2026 11:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6C46B0164; Thu, 26 Feb 2026 11:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5DF6B0165; Thu, 26 Feb 2026 11:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6749A6B0162
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:31:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2AFE713A787
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:31:06 +0000 (UTC)
X-FDA: 84487147332.16.9FED8D7
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id F406B40003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:31:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PcKYMR3H;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772123464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54084A4OEdYJ/FduLbr67Sj+jCec7nOyoBihp7G/XDQ=;
	b=8e6mNc/1O3CgahgsAUIlAG2AQhht0ZQt1Xt8rv7WAcIEdib91+08JbNWiyfDYFwMqZo2n0
	1vZnf97u8nh6ERTD8dRDYpLrP7dYwSaoJx1xqOqMcKqp0GynDWY76MhN8qkRneIhleIpwI
	X3LGzoKarRor6PV2BG4Xh6UsHsoDGAw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PcKYMR3H;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772123464; a=rsa-sha256;
	cv=none;
	b=4ZW3GjlnzoKSuvY4q8StAl73Xs2RNX3kDkbhbb7HSiSlmOJxyEvwHwjdct0TFCkisdx3mv
	VAryRWqd/iOwypILO5eYnMJtthnHgwtx8jGFk4mdAQnPCQAOAUkHIF0qBZBgc+dkgHuPmh
	c4Ut/WV06X25RZb6OnzH/wrq/LjIROk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4398d492476so33513f8f.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772123462; x=1772728262; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=54084A4OEdYJ/FduLbr67Sj+jCec7nOyoBihp7G/XDQ=;
        b=PcKYMR3HrgQ/gqL+9It7GwWzxuhGv3zNWcDNG+OgwoIRffl4KPDf9bPVUWW3e9zKSL
         slg/2G6GG/re8+BwS4teln7KR171zCTm7fyHxxIwtgbvKybQyVCXF0BTUjIoWLXTEXv0
         05E+WuMSa9HiWUqtMrhTKk7aBdOPi42XcDrPRcuWVUpxN0wbQPAm8UhWppyAhBzcJ4Ij
         I6q5+qVgdPHHf7fhohNPZI+Z3KqvW2uS18wTVG/utcPkFbeZu7ZVni4VDbLaiGWu8+G0
         SWS2L1V7u1LuQHYKUJnRXFdUotitdPG/KSFBrCbjTMdg/xWGu5VgdKkDN4iL7pR1XyG7
         Nhxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772123462; x=1772728262;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=54084A4OEdYJ/FduLbr67Sj+jCec7nOyoBihp7G/XDQ=;
        b=Qbt3RmtrfkHLRlflPIRMGpTP2o3onSVYcLRfQxQFMjkqAIW9C/VpRnDMsX9A8jUkRT
         U8U46q3gPLtUmXSakC83fS+IaWMQEQutLhOtvHEz5SsYeiOTb6b9g8xteq1mjcOUM1xT
         Zl/eirQgHQ5Kz63LIBKp5Q41RLw8hvj6cfj4m/ZOgaVkG9kDklQYbs6VPU4kjmuDge3n
         ZuYeLKh2VFiQ9hkpn5RReATApxGB/oUMrxT7ID5qtELxa0E6bBRmUfDLgRHZzksPnFHJ
         visoejm8lJoHL2dOl5BVEbzUBBaQiJ7p6nFEPH9pPc+TwSXALumfxeWFFYVaPCqUFPN+
         yixg==
X-Forwarded-Encrypted: i=1; AJvYcCXYcRyXhiQZP+xvNdVTRbAKQZE09wNOVTOAq8PZzz9a/Dgmsl9NNw+1ndy6fHujpl+sQJ25OTD2ZQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7NlLIPNj7vm56UxhgC6POH47AXrBQjvOLDiSSu24xqtHrdOzU
	o9Qszl88JpPDdOPePHzszIE+ioxTkztwWEv+RcdZyWwZzCAflyWIU0Ceqx517KBW1dQ=
X-Gm-Gg: ATEYQzwDllxEksZR+PPd2WbNGjTSgk1rgQwaYXwWjnNK5RTAIkElwXLGL9ZQRmdMfRS
	uNwZ0GAmdE5wYe8LLEo60JzDE9aAln3+u8UNuyN6HlyQ0L3/R2WyA96Cczj8IA840Ry8N7UgUw0
	B718HvyCoZsWwpexApGvBVdB+fZcQzrnSQIJ7dQo3Alw/DGsyvG/AWq1lAkOQIdGPgB5RbATwBP
	+MybU63aol6Oor/LGojo9c6eoNBThAoyoHnRmnWOZOmfr511MvfzQqBwiUadCQyHsA+RK7G/+YP
	8EqkGLZHDAX9mguy/KBMqopDNI2CD1ZEWCS05lO2xND5PXJPqe9wc12/9S0/Lhv6335Ur7yqqTG
	oDKJ1JBjf0Brb0C9N4qBuWY/1Ty/BoSiyEu1qKArnxRnQHw3WdtSUvhnleIbPhIow0IdO6zS3AR
	BZHPoilrvMoLUVROL1KMhcWyP24gwTkmb2HnyC7fK/Gf9yo1vVpGmn2GkeHw==
X-Received: by 2002:a05:6000:1101:b0:439:8bee:b984 with SMTP id ffacd0b85a97d-4398beebf07mr6934299f8f.4.1772123462245;
        Thu, 26 Feb 2026 08:31:02 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c76b20bsm596856f8f.35.2026.02.26.08.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 08:31:01 -0800 (PST)
Message-ID: <64604c7e-5db9-49b9-b576-bbc627c8ddd1@suse.com>
Date: Thu, 26 Feb 2026 17:31:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] kswapd0: page allocation failure (bisected to "slab:
 add sheaves to most caches")
Content-Language: en-US
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, harry.yoo@oracle.com
Cc: chris.bainbridge@gmail.com, vbabka@suse.cz, surenb@google.com,
 dsterba@suse.cz, hao.li@linux.dev, leitao@debian.org,
 Liam.Howlett@oracle.com, zhao1.liu@intel.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-btrfs@vger.kernel.org, regressions@lists.linux.dev
References: <aZ5aAlDDpUoZxx_g@hyeyoo>
 <20260226162052.36121-1-mikhail.v.gavrilov@gmail.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260226162052.36121-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F406B40003
X-Stat-Signature: enz18syti1e4azj5ygnqwq5tpxe78py7
X-HE-Tag: 1772123463-113511
X-HE-Meta: U2FsdGVkX18VSPSNYA3uRq0B+jZdgGd6QSQX2+ypnAPSfIGVIVIPr7FDbn8MYwXwUsGDkYoVjNjuozj4tX5Ga8tOthH+uXslpQUVOgOS36P1+WRTtb0B0y0+z+fIlREwIzh5oyKeaJTSRSpyzEevdjMxJ1X9nfBY4VHAf3a2PHsg1dAmCBsPsr1n+CyMyQ2IvhXLXzuvc5UllsZWSaixGHigzReCtRDvQmb9Y+TFQvyi6bp3pzGARi0rDQafWgij5L/R5HHuj2hro2ztfj6W9T0kY3A58K1eBnFehKLQnOGQ2OOlFaqgCudnIwd4yqd3FMyIrlmWbKCUamWEAe843K3LJq4aGKPXVye5SxlTV4yH3OwN/MKLXzUG9yaablFrPUK1LNSVSP7+mHffMneclGntnBDaO48va0LEnhDLfmGi/BfjP1XahSTtFISy9FCYYQGpxhgkzFpE4W70BYyzp3DdqxWjxiXTGR0iskkO/r83Hh8FzyZy4lzgMid0rlLrxhK7p9V54uw6cCV5zs3k4hF6msGgu4jfeslm7c9lEcYYLxffQCg+tP2ZKMClpVVCijJ+xE0iDp1Z82+wCkVt26qaXYRge6MlxLECBgScf3XF1gXvHq268trE3x8ktsEVwCbhJL7fcnAMSCexL/AWWr0ZV5cNSKwc3kQJ2YtDrsg+dAFhxHEPS2YPch78VACF0hgzXfbrNd7Sy1bKjMFM3vR3w3LMBQmsgrB6KQHFSggvK2xzUhVE6c49hyAYAnYqhSea9eqiqzCXGfldvNqftfnS0yqklVkMHNpYKwLfwX0bFdau/x2ZMt9E7yI9LZyesYMKSYRgHnLT6H8mCip7uFPrH05C3b2FTe4T1icowD++yNRCPZtiAzKsCfwYJtOl9XMrKlJhmIJZ8TefYKMH9tuf7N22xLa6A6U/wEFjSmo5pIlihd6nYhsCkAwoYh5Vxv1MNaQ7SfRd9PUYfOs
 LVG4Gr7V
 paxzOmd4r4G/GueTlUJg9Ary7tmcQ0hBO+3xs6soffMpPG5znz2XPjxi14NDMsgEU5ljLIoY5a4yxcMeaHSPexhVu0ia1yPZNK4MKh+TJZTWR0e/E0abjT0V9+Gm5E22J6bju4BsZREJH0yg7BOB8GxhiPW1aySmuVGpFjSxPy7+xaKJJpvMwtkli/WtM2xOvWNwPKsEQ4qesHNNapRNdsSQVqIqh+XNEDIO5Ic/TvYtt0XCJ7adMasYhO9IJkowcg8Tfb4Ihubav0kaJaGhz+ufBANuQZ8h7nVzdjiAu7B0PbxX5INjg9EyUtpnRJhW5Kq4eonZ05PFet4ZpIMC9XDM8FNm9N5HLngiCTu/cFKYYC1R0aCFvbVTnlNBkxu0+uvB+1aLl+uCrewDL+ZU8apr08EdVEmGlraq27445ygMxWGgBj5AX8koz53liPxpfuEJITKUllC9IxTDlk6hB3vA5yxCbHQs/97gTC8zFps0HJW6jx8t13+JbJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 17:20, Mikhail Gavrilov wrote:
> On Wed, Feb 25, 2026, Harry Yoo <harry.yoo@oracle.com> wrote:
>> Slab fix is submitted here, please feel free to test:
>>
>> https://lore.kernel.org/linux-mm/20260223133322.16705-1-harry.yoo@oracle.com
> 
> No page allocation failures after 33 hours of uptime under normal
> desktop workload with memory pressure (64GB RAM, btrfs + zram swap,
> Chrome with many tabs, AMD GPU).
> 
> Previously without this patch, I was seeing failures from both
> kswapd0/btrfs and chrome/amdgpu callers within 10 hours.
> 
>   Kernel: 7.0.0-rc1 (commit 7dff99b35460 + this patch)
>   Hardware: ASUS ROG STRIX B650E-I, AMD Ryzen, 64GB RAM
> 
> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

Thanks, added to the commit.

