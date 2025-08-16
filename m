Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BE4CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731C76B0096; Sat, 16 Aug 2025 10:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644EC6B0099; Sat, 16 Aug 2025 10:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582586B009A; Sat, 16 Aug 2025 10:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 489CB6B0096
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:06:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E345B160418
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:06:56 +0000 (UTC)
X-FDA: 83782796832.10.E319FDE
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4E0D140003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:06:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ndx/XuXc";
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755353214;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/cp+VbHKwcTssvBL/g6TrCkhlullaweEwLRwBzlXiRc=;
	b=soB0bn9/8Bu/+N+IccOGRjkT+ukRbINLedVSMVBZopa8jBVmM9n9YcOIN8X2+70oRNvKQA
	noUFJiTGXrrdrew/SyL/hnwH4kwkFySw7jPLMsxiPvqUH0f3d3XXCBUn9bHPQZPtchg1wu
	b42XfMmXBk3oYJmG30buct1SMsRambE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755353214; a=rsa-sha256;
	cv=none;
	b=cpZ3FcMq/X/e6xMlbkCqnFPDy56gJ3LCPiYSmOjnb80IhTo5hcc0x76k4eiqfiSX/RJZ2o
	GSR65El0jzRFanEiobZYsUgVRDgdLgq3jAXql732yZqb+aB3huAnK1kx6NFmkLO+eMR4cr
	ViKYyFT9FYFxcENP95ttNFK846AMvfg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ndx/XuXc";
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb6856dfbso493720866b.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755353213; x=1755958013; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cp+VbHKwcTssvBL/g6TrCkhlullaweEwLRwBzlXiRc=;
        b=ndx/XuXcuLkgpJR/ziWW90cLDpB+usKQZlG49GBti7XgYIw1e1pT4sAAINmpcUYdca
         PjayhqnkGdKJSBmt7HcdgDS58PiBzay+o+3+caION8OULJkVqTmLuq831c1SlnZPWy5f
         ijOh6AVqV8M0kr2wIxfp2euk5MCfa5GqTRZ5SKyZ6lBB9DoXoATGZygvm5sYnwqvIm6v
         5ssT45b7Yv2hog4+vmcJKV8Xq9dbQxHZHSncQy8dLZ/Q0XmRP9bQedbyC+yGJ3tXnvR4
         uDMi/7LZcZfI+AnrnUgfexLuaEsPuIJTKGMsnxRSWUCNOrQquEdTciDLR56DRYxJW32J
         pkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755353213; x=1755958013;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/cp+VbHKwcTssvBL/g6TrCkhlullaweEwLRwBzlXiRc=;
        b=izgi+E41h48UsPQnrLsjVosinJGsQ6e5cRG75C/2MKjGFlccvmMFTovAVUvkcco1WQ
         uzRrCIXZ5oK5/90Ewfi6Ql3BsZZBF7qrSFHR2i4yeMZVWwJLrZLR/gSqNZfjvQ85/6r/
         C+LikMEstAYJlWyJdXHjeF1fe00f8TCjfTv2BQeN6z3N05fG1Bs6Gijm6o67SzO89zDy
         hH5pO3U/E/5ZJTfkKWDmJayRTiPmi+0q3SndlNX/HykU/FUsVnZMYavQ3oxSpj77/lXZ
         VYXpwiR2ndffhE33/t0eMfVxoQiEE/tVXjUYqLhMJHTBTOXnLwWaqoLEX7PfSd41ytw4
         sYnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrxjVD3Y8G2R//wGiiylvx7+5MkUumh5EgUUjdMbTJjrYE6UfFXGhOwM5FigJy/kt8hGu4D4g5HA==@kvack.org
X-Gm-Message-State: AOJu0YyHTs8PWmFs9DeNvPWWsqSN8+ucTr/4uIhxNiiXb1Z7RIkX3zgW
	avX1SLoZkEe9XTl3+HOG7WjddXJaD94QF556tMH76KpRLs/ggj84mlRiZ17b9mxD
X-Gm-Gg: ASbGncuRlhVfJ0H5FrKVe4XqhcwXe0ov9/36zt4NuvEM6/QYBqYoFPIkgn/ijZb9PlU
	Jegy848bGifT9IqGhD7Mn70M3ddGdrWK94PZ2AF8Pgbpy+kQxEXqy4R/f5otU+Uz3T2Vyya4qUk
	qu2N6PaXDCRqmbX6KrwKyvW8ioqTKy8Qguk1XK3E0jL6PuxVC+NoUIDZ1U0lOCvO1aaQNUXdDPQ
	uVomcU8oq8a9xkpwQ4OvjK9JV9Z9OAgN9ZFIt7mtI+NidoNJtTlh13mPd1GufYuWeHb84oV7zWq
	1KBjSuscyMGwVHL5YE/LjKwUg+KNGhbOvc76oprhqug/jsNQqzFEsTcV3tWoUgMM4gxAZC8lYkl
	zKoOhqZ5lRR5C8yiTolx+qQ==
X-Google-Smtp-Source: AGHT+IGeSr+Ixtwc7wx3WQkh0Jy1SQP8zs6ljOM6DHr1SVeNpVGmGDSkBV6/gAIjI30qJKHsPlbhpw==
X-Received: by 2002:a17:907:2da3:b0:ae6:c334:af3a with SMTP id a640c23a62f3a-afcbd5cbffbmr1091494666b.6.1755353213290;
        Sat, 16 Aug 2025 07:06:53 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618af9da3e7sm3372710a12.13.2025.08.16.07.06.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:06:52 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:06:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 2/7] selftests/mm: Add support to test 4PB VA on PPC64
Message-ID: <20250816140652.qf52izwhltcofp3o@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-3-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816040113.760010-3-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4E0D140003
X-Stat-Signature: 84c9kzedzz3o9e7kmafkqx4qnbbwhy6o
X-Rspam-User: 
X-HE-Tag: 1755353214-486871
X-HE-Meta: U2FsdGVkX1/eXXS3z/7J8uifVkv6ClaBTR4v+maGFa9HzOZw+d8Ad3UHvC7Ij8x4EGNKgALAQqITtUgrpYjQAhNUb2X78A8rFmgAf9KsYojW61srVWcsdSpE7OthyjvK+H37f9q1GII3OFP3r7F/3GgJh4qzy+/RJd9Z8NPIZWsPk1Bg4CeLKwQpka6ISLzMeU6Gmq9piEY/t4wLfotGmpVECrBayfA90YGkRmQAZOhvNWbFhQWiGG2yZoFsSckxHg5nN46xSlLFoBjJevc5WQVd8JRP0tZXtVCo/gcZFY/nduyVZ1vpvENZEGhMgwR61f+h6HLkoFWHHuzRJOTbeHx3K6HC3D3Wb6s1tcYlBDFOa/3w+opyD2iSZSS7gpJXu8pHvAlQ7gNqE4CAg+IAyyijkV/3lGDdL6vF1EQor6JSA90BwnqC202NG43z1ObgYHMT4usV4wdMjHbvK10qeGlG7sGRu1Z68M0jIxkcHPQXRJtnP7GxTqQZllEeNCSSWSGCeadsnkaS2itCokaela51glB87bHmS940H78mJ94BPzCFYY+SkM+v6huEa+ILp7X8U3XsRlfY83Z7CeFN1MzTmgOtMKHUJRLS9BZ/I+FAZgXWz5Em+CeXilRF1T+5XNqrY8rkGgWuJ0P/K1vAPFtb3f7MZuDDCmLoL90bOWSEnaSdjZg9EdSohoddRNrFY0Jin0n9NcJn8hxNmgoOm84MQDHxTypEew6dkAEmYPlQr66JbIUzPmUKJ0+/uP4SbXa8Nhwnc9Jw/IvQfSxxqLYslkBrSDuJr+0Hxzm2GKskxyfnSp/vIbhdWe7/CYV3ibngi812BDKTkJPtMEQPCwqjfQ30fVAiBmNgQ0us13hOapVdauOQANTcdEeEVnB75YRAkqjZmv6DOEP9q1BGDuDcmjLbCQkaK1WXVmB9sBVJUYBWhZXWxZUR/EJUMgjoG+XN/nk8ZCZmj+5aXc0
 GRM3oBQ+
 8hLbkyrNmrrzn5o1Jf4IE9psXJgatt1wm6XkSfImqIYKYfXNUUifzRvicyL1yuuX54cgTlnZsnkPLrhqJMWBo9gJKh51OGvNuWM7W9e2dsIAgBXCpqup8UCZEGIwDFT4dieomgKpkBHDdvTV/0TyXKUPn3eV2Snf18420hdfAVHD2l+CW6gyh3eNaWO3pguPorAHDKGjjix1CkUEKPgoHSy/lbl8/Akz1D9rFLH1pvNenRRvLvxte03pGIIOLQdcWizZnrr7ct6z9JyBtZjPJ83nd/W5lw7glbqFYW+csJbJ+IoWXih+NMxbYLrzJMhCCZf1LK/T5c9Sp64wWRilvRWxOmNij9cAzmYmf7Gs2C9hQbLtDAEinBuY56nKQoqjr6C1hsrrti8HETw09s2C5O2Pi3WoykzCMbJ/1rphQAZXJ4yqV6bb8mpwMfxTNQUfO72/kJwWXi9emPauVoeYGZkiW+wT4jcSNiQ3Lg6BjVuunFhp/+lYAUo5VCAL3AdWc0gTOz97ftFwDX7i6QencSzAlgm3bCA1NR8VS6ZlU4YdVG8plqRqbyjUcDAU8W3+ajT+JAAt28ck9q7UlpqItO0ddgGD1+gY8sD3TbznH0gzGwga6qX5k6C80ih/tUR0n2Lwd07/It3frl4twjfdlNpXUqGtC8g/pSkVHJR71HPOm7/rA+l9L4xfgQ1CmV24cYrxpyF+wSFA014eKWseUFgEZdpu2xQ0l0YPCPl/0Izs6QY2nnJME+cgKt7so4pAQvPNuevdeeIEJLTGqVsqgSvMt+AUuyweff7x3OzJ6pek/CXC+WuHXivcwazYxqczvKZyw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 09:31:08AM +0530, Aboorva Devarajan wrote:
>From: Donet Tom <donettom@linux.ibm.com>
>
>PowerPC64 supports a 4PB virtual address space, but this test was
>previously limited to 512TB. This patch extends the coverage up to
>the full 4PB VA range on PowerPC64.
>
>Memory from 0 to 128TB is allocated without an address hint, while
>allocations from 128TB to 4PB use a hint address.
>
>Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

