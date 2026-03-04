Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090CBEDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 02:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099206B0088; Tue,  3 Mar 2026 21:42:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0472C6B0089; Tue,  3 Mar 2026 21:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95346B008A; Tue,  3 Mar 2026 21:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D55176B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:42:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 934C6C1911
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:42:50 +0000 (UTC)
X-FDA: 84506832900.19.3006590
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5AF364000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:42:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b="AQE/rAkw";
	spf=pass (imf12.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.52 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772592168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7dycZCW1i0wVXbu5i6p68JSQ3h2ubeTDMrk86ISU5M=;
	b=CYBh37WNHR/6zYksYGHLExYEelRgt24KVSVtHeSGcrStUza6vZmoYPxUUUhla4cYnG1Hwa
	y2Zgy3Cd9AKrKevke5FoAGlMmeLS4q9k/wur3d85rp7tBu1a+OEgPAVmcid00Fbll4COOA
	jDpmnyGVKtHF3C4UWXyYT82J9f5wC+U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b="AQE/rAkw";
	spf=pass (imf12.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.52 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772592168; a=rsa-sha256;
	cv=none;
	b=mLqY/PIwCq03cGPwbu9GqtjXYNrIuZG3NOsmPqvhzN4LVfzcv0pS2n0bCapKhpabu0UWGi
	m6+FpVg9s9+Um/SgI8e6fFRcrK73KF0a+0XIuAWfT2CEmH1CmAi5VOz9bK2l0BjfuaCoz4
	nbXbygfg86M1DjKmmIXwchIwlIFf7NE=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d596a5be31so5399302a34.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 18:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772592167; x=1773196967; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7dycZCW1i0wVXbu5i6p68JSQ3h2ubeTDMrk86ISU5M=;
        b=AQE/rAkwOrPtCKNvBxzJ0KyTd39iA2Uqy3MjZkJwuS+FoxyFhdCq5Qhc0vke3kej4b
         D2Xd3FS2H9pzmi/73v25iMz/2s5mNzlSFGPQFD2p++/A0DU75cyhLeBmI5NsP5ACmt36
         Q3yu6hG9/GTjYhPAOt5LY5l14mKBxfvM4/GmAfJOFu2UrhmHfM2DOFr2qVEtkKUg7FyM
         +UjqqHLlyKjp5HuqqtSjynU4Jm6UMoRSvPrrZ2yJfy2JGQpuBkt8sFJacpC7cLlUfRrz
         +IeJe2X3no139hCSlxjNREwGMns+NXOH2j1AGg95ZVty7VuJovlM6xckYu2OKYJeuS2N
         aW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772592167; x=1773196967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7dycZCW1i0wVXbu5i6p68JSQ3h2ubeTDMrk86ISU5M=;
        b=bGv3BO1qe/6xpA1qvChFirLr0P0Z1HuqAytMQ0M48AsOwroStb+5iJIcnW7Fl5TMxS
         PC8XRTH9U5+Ug79pzzNj7KzaCk8WKQLenaD7hVa0q9Z5uR2yEGnMgaSUkbWs2t9QrEBM
         IWAADhb95/UIW0+vBc7dNenHMad0w/rTy1tUir6V+gOgdiKIUBvBjIJPmF54CW750LhJ
         TBp1Kp2cGMnp6h1AtZ6XsG6jhR3FBWUCOZXM0pnqCelUqBRp5yRLe8bGZhLz7WWpa7zt
         ersFqiPBEoC+V0xBE58tFR7qbHeWPqkxaCMCnt1vvUUmHfbTbx9j3DAYDx60Djmajr6v
         W8QA==
X-Forwarded-Encrypted: i=1; AJvYcCVxPjM3irTcNjuYGDqcRupMeWL+UqFqzhZNG7u/elpkM2SDOOJxRjqynW9vYoTBdT2USLrsVcBpcg==@kvack.org
X-Gm-Message-State: AOJu0YxwKvW66WyymywkqWcKa7wX5Ade9CBKT9OmK3JJyKiFQqvRsMri
	UZ3v3q97ZxsR7zf0Fj6l72hptx0Q4dm7kMJIydCntEwNddZNDXBW4aLe5ois1LuK0nw=
X-Gm-Gg: ATEYQzyW+SeBdTNe18pYu/3r3nlSC3YhNnglKNwSzTDYxLTMnuWCekhIbhDDYjHv2gh
	TVtpKAhaO5I214SR1jEoB6gjvvrRxiky14hQ5yg0x4SRI7EjjgJJDJpeU6RPLZz/fWa5Cig5aMF
	Rcqm4yeaYJ8mCsANCePlxe5BXiWIxN+KnKhDVkOSouefUBmWBNhRBROzw8+HLTFam2Ukig3NEWp
	ef8sKLfeX3tR08L6FAFc3FyNv1bLde4aoMYN4j9ZYZlwW8vhvVVLHA52F0R83ZhyrMEJctj5dQs
	91VBMjI1iIPfXOwTUOxw9ZDXlAIQz5e0i2icqpP+ZtN2t/kMqDsqTLaflVGwbSXKCKuU7FxSzzQ
	ncTWxe3NJMgAP121ntVQwaDFVR5RATwsgWNTfSiS0Vcb3mK3veexSrJQJCj2l2yjDwwSO+DNQt6
	6Copk7RU+ahyWa8ZOdw2ZOy8hNcA9mTKY7t5BmRmE40dLZoYL2tgn1xmcNF2Hx1t8MM0P7ooiLu
	+qypVTBGw==
X-Received: by 2002:a05:6820:4a8e:b0:66a:1886:e4bf with SMTP id 006d021491bc7-67b17703546mr346906eaf.22.1772592166871;
        Tue, 03 Mar 2026 18:42:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm12574800eaf.7.2026.03.03.18.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 18:42:45 -0800 (PST)
Message-ID: <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
Date: Tue, 3 Mar 2026 19:42:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
To: Jakub Kicinski <kuba@kernel.org>, Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Duyck <alexanderduyck@fb.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexandra Winter <wintera@linux.ibm.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Anna Schumaker <anna@kernel.org>,
 Anton Yakovlev <anton.yakovlev@opensynergy.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Carlos Maiolino <cem@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Yu <chao@kernel.org>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, David Airlie <airlied@gmail.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Dumazet
 <edumazet@google.com>, Eric Van Hensbergen <ericvh@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
 Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Latchesar Ionkov <lucho@ionkov.net>, Linus Walleij <linusw@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>,
 Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Sean Christopherson <seanjc@google.com>, Simona Vetter <simona@ffwll.ch>,
 Takashi Iwai <tiwai@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
 Yury Norov <yury.norov@gmail.com>, Zheng Gu <cengku@gmail.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 dm-devel@lists.linux.dev, netdev@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev,
 virtualization@lists.linux.dev, linux-sound@vger.kernel.org
References: <20260304012717.201797-1-ynorov@nvidia.com>
 <20260303182845.250bb2de@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260303182845.250bb2de@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5AF364000D
X-Stat-Signature: d3d34jq6zc6fqjh3hxezwhxrmdmbjd7t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772592168-366436
X-HE-Meta: U2FsdGVkX19qKK7gLqMEPVZFmAzd9hXBt0gB/v3kwh/AiqN6s3DN2n2CIpsvEH7xw62S9Ha1RWSzV3S93vQYMfqB7vT91FXoRJdu1aewwAiFo+DSyFVhbtggnZDMbR9lx6TIxZbbRWhtLXKgH/frhyu/92L3D3s/tb8W8eGTlZWkbvwiQNKiqPtzTJrfrLRdf7RgFJ05Wbk3RydNjkDHTMmhemGoD3hJot+iVRGZMhMmGR62ByYO+8A94whf8JkrWj+IFFKOSC2CmPvbM1vVYhDeZ7MwZ4z6p17APynbdGdL7rdptP1MB1s6PgvbXTAXhpLZesU7jzdZ59S0rdIMZiB72dhSOyX6VA32gF9L6fPzE8M6EfczKFJUdsVnMheIfrx2OszGskpUM4MSkjLah6o47FFopjWdrsi9KDR7uduaaRXcJe/5laP0Xr6KlPLSz/NCaczcj8Ccvxw0je8RlvBraTZfxfIqhTHRd6iH5EhnSJsgPZWUHY5RzUgBPKRe1UyLYkyMwhs1AdxJmSdTizrdQy9QuxBwWz82pkIEi5ug3qTPahjC6K0PD0Uh9ZAmn/xmWLRM8ACqXY8lO5zshM7XfsuftLmBhMtFHhd2ZmjEltmYAZqOcXVXvk2g9qUnhJse4dSRa7qEcp/eLlejRAqBgx+QzCZjkQIoX3Btpcdg8MqjGkgCwILakkAcgKc/ITpmCgVGeV86jr/kx/asa/rXzRNr509K+gpLL1HxMwB2rKa4coPwlcBHDsNpi+06IdXKvYoKAbgN4DRw4H9GRScruQD5UvZ/1niYStrUxFrcCfYxctH0lvTtQ9gHe3c9tCKhRUViOXpw4lQUeJ0FU9fljYIHFNe/Q7bZDMLjkdAp2Y+/Aq0zRb6seIPtWJw/bfGFckRWKnvKfS4+HmjnHCYe8yS4fxBLfIGUml8LyHJ1ix/XaaYiHvubXL3R7RKX04C7HvMAW7Dd9Z7N5jU
 HseJNeEk
 id+mPtZgl6d0kV6mmbTHC8yEeHMNJGJzafajUPUYeMBFP9qdGKVpUUQ8koQpCMiF/YDsW65DbO5wvmpuLV6dI/ik3tsDKZRDCPMksdShLUKvYufGhOjGTdN7Uv15Y+2ugh/HZ8fg2OFAokxI/y6mQQMwPGDrFP2cSEC9Ku18BOrEN1E4/P404MbQc/irwQEDGtM+xHMt/61APkzXD7E1pyeRaS+/+Ovkm8GZZzxrLysixJg8VUOlBZSFHyGvVRpQ8FzfSHvviObnXhprvlmwZEvaSRkxt77OargRcD/pmh62rCybkMia6OTjZf/jpjWMloPP2KOKIqaSPT/TN9wY4RzfyOg9QDjgcyF20ucdfG18GKNOVOlQfdSF9wRgMrjW3CYKN+ARXHsJlJ6h0ZNuIPvHZIZdm52BeOQdeljV12tTOyUwA3ZjDzknl/T9+KYu6MKgU7DpUKzSHhuWG7k4KpjbVUIFQqHazs0bLcXB/ysSIL5OvG/dMMPAQ3qILPv/7pMIUFilL2bKARozvAAKZe7IJ+377rT+I6srquh0515O1JJx4rLuZZrEdyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 7:28 PM, Jakub Kicinski wrote:
> On Tue,  3 Mar 2026 20:27:08 -0500 Yury Norov wrote:
>> The net/9p networking driver has a handy macro to calculate the
>> amount of bytes from a given pointer to the end of page. Move it
>> to core/mm, and apply tree-wide. No functional changes intended.
>>
>> This series was originally introduced as a single patch #07/12 in:
>>
>> https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/
>>
>> Split it for better granularity and submit separately.
> 
> I don't get what the motivation is here. Another helper developers
> and readers of the code will need to know about just to replace 
> obvious and easy to comprehend math.

I fully agree, I had the same thought reading this.

-- 
Jens Axboe

