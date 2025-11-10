Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F05CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506138E002C; Mon, 10 Nov 2025 12:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B68C8E0003; Mon, 10 Nov 2025 12:49:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357F78E002C; Mon, 10 Nov 2025 12:49:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 226228E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:49:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9CCA1601CD
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:49:16 +0000 (UTC)
X-FDA: 84095433912.21.498CD7C
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09FE7100002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:49:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wglv28vn;
	spf=pass (imf05.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762796955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPbi2NPPrBKl69IkN7kcBKOxfNw5kLfKkjmbVe2fGbs=;
	b=f4ewrqrOdpg6p+P6+neDWJS3hsJnCro6iBUa3OYJY9GCyoepXcc8F+L5TRAxvlqW7RL+4c
	kiyFhEjek6IyMw4C0FVetM8f3bBYXgb8IGS6OUgHNzHIuKME1EubQOuAwiMXBnGJr9h/rN
	BD466JVqcFeNeW+revRE09Xyg0sCmNE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762796955; a=rsa-sha256;
	cv=none;
	b=6b8RQggY85omYJSFGEXNC9cNPYk2ORAQsg5XNTvOdbn7XJHM3J/mLIbhQqgecdWq9+c/D0
	Wrvj89jrOE70uvSB18/+x8shHrlVK+UyeTEmA0IfZe6RuETq9rcrzo/B3wzYaShYo5bmbY
	ugxTzg1+lwmSM72K2S/2+2b54gW9XoI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wglv28vn;
	spf=pass (imf05.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88245cc8c92so12433386d6.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762796954; x=1763401754; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BPbi2NPPrBKl69IkN7kcBKOxfNw5kLfKkjmbVe2fGbs=;
        b=Wglv28vn3dSOrK2Yd6Bg2y7AjpxE2x1c7UvMxmXf9cBOjz0w9ckw8djZ9ePaqLDHTb
         xdSKT+35LzmEVddyg45Bunvulc6MgQfGShmpC21XDTtGp1NtNgRDqSuX1Xxh3NgKwv/r
         24Ahumoclmr1OPInCRTVO3SMRzehMSlFDJA384sqZ81cNdIVIePsuztVrNy9PuoUThEi
         AHYTkNWWKAaIjE6x1d4bCyezeooHzqq0wLR7nYayow2j0+LxHMxaDXAbPQH83CXc7puD
         bkN1jttqGpcYp28lNMJEbZRIKQ54JRbLaOB9kdmKVJcJ/1ibfZxGzl3It2Tq9KRjCzYF
         JbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762796954; x=1763401754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPbi2NPPrBKl69IkN7kcBKOxfNw5kLfKkjmbVe2fGbs=;
        b=rA4A/dSIzjQA8D6LCvxPwbbLpXkImONl7OfuFG0kTorgcC+Az7GLWkOrvNtE6nVOLK
         RcEY+aN564gWrwr7jZWDw0m/Hf4ZEN9CWm5mf46xcRgbolmIQU1nUXUQkZ23VNWrlBnO
         QYyN5uCuCyYQ1vE8mqVPpnHp4eyT3zPQZNJ51WxcV+18zEEdEVzrltmd4jhW91Va1IJO
         gHdks5N3v5oa08HbYitGP/Aqik6QqenTAlljAEmtj15YUoAkGlI1YQHwP7vj5Ay+ZWqk
         0r9VF1jHRkG8y7abF9yRrFy6YnpteaMED427N0wjlN466RPqpwj/LTg1gM8Sp9NOaYMH
         zSjw==
X-Forwarded-Encrypted: i=1; AJvYcCVGcd+B4h9T/5UeYIaeg5pBmok06oH5XmxnSDFG9odL8BFzUsSLbDI3q/itmtdTi1qHYjDa6ZX5Vg==@kvack.org
X-Gm-Message-State: AOJu0YwZBKqQUGTmEbRLjFpQFTOTQam7RTs+HzsSU+OnQgtzC3LLq3iq
	Y4HWEFTkcZwUu/xRuh7Ad7pQMcfPizCvbSd6ciqRyia6XxVDIUnf129VnLwY17SLcoHQv5KOV12
	m3e61+XGSpq9URO3XwBxljhfRx1bq6ABvX1jDQo7k
X-Gm-Gg: ASbGncurrE4grnuRpDPpwx1ka45NKf5COgVdee9tcGBEQ5rwVyCCIQMl0qfLhjGkEkv
	zPIu5ePj0xqoE1OKK+jF9t4dHTKDth5GAZQfxb9bDTJPlD0Y1b+9dUVBI7XBYyWOyiX6K5awODC
	pEv2j49uHcFj7ESN1NtPko2WJkXc47VpQGB9o+8vj0CCWoelg+K1BE/vvnWFFcp4S6bQvmTo4DX
	AA/WiWeehuazsIOgqgD/2yrBaSnfaCKvW/nefSgI3OqRe1Nl8PREPaxxOgbNCW/yqVS9QHpmP9i
	YxG5JTMEJaN+oCx/nRxItpHsTQ==
X-Google-Smtp-Source: AGHT+IHaNRtCNWgUYc5RPhLYoD+nULNJ4nH9LNtSZkCbb+Nk0d7DtvBVzdaKV0/uL+kFEgmffI/ryLd+1MDzyV+BJT4=
X-Received: by 2002:a05:6214:1cc2:b0:880:4bde:e0cb with SMTP id
 6a1803df08f44-882385de9demr131074376d6.29.1762796952867; Mon, 10 Nov 2025
 09:49:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <0ca5d46e292e5074c119c7c58e6ec9901fb0ed73.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <0ca5d46e292e5074c119c7c58e6ec9901fb0ed73.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 10 Nov 2025 18:48:35 +0100
X-Gm-Features: AWmQ_bkJUSMUoO8onDW_Kv00mrjnva_voIrMRMQdowErjlplIdY_Q4t-6BqV8ig
Message-ID: <CAG_fn=W033hGM7_jnj0irwW0gc6McLw2nbhfZROWfieqKTxVdQ@mail.gmail.com>
Subject: Re: [PATCH v6 14/18] x86: Minimal SLAB alignment
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 09FE7100002
X-Stat-Signature: 3z9mue7fmf664h6tdfrxzuuoxo4ki5g9
X-HE-Tag: 1762796954-811548
X-HE-Meta: U2FsdGVkX1+BiS5HXwSDcz5/AwkBLGilB6FPCdv8qFAtg1cQUxo96sTHkezQ2iQuBvHNIyPEtbsKIAqK0hg7N3rX7WXbmkuKwTyKXhTiB6/ItQ8o25iDq+69CV0W3VogdzupEcfTzIJppUpaZF227Ip2PN/qFzojeqezqNjDR5LgvsHt8HRGIKlhCpV0fQANr3H4Yku1JQjD7EHAj4T/M44hX0REhc5YcvLvud7btiIrO16W/F7OJNRbT6ym0Ipe0PDpXxj2gB0Z1xZLsZGF1f0+tU7Q8EDpXAPzNKqr5QnQDqPkb44AOaTU6wHQe75G4uf/0pjEh560Ws3eyJjo0ne85clJ7bYYxAR2LGkcI17rnXwDvKGlGoWks6y0kJujdNQzZ6kLMQkSvlplX/FsWAsqEY4rA9rEFxwoA0R0MOJpbkNPup1WT9dwWK4sH6nf49JADTUzeHJ6sc6oGaNNApCUxJxkR9fkccGMBZAIdOHa9IV2LhdPOtxrehuQqcdqXuC+fwFo3KENm+CNFftv1N+K2/wjhVxpqaz50Sh8dVUdnu8Wp1zgYNptwoYOB6tOCsM/o3TObZKE5++C7u3siMQ5m5UPR2eqpfALG4d2jrg1y9HmQCmRJVMtPNd7Hlr+1OFIGYzs6uqX5GX2zX1tHBuK9xBwWslgDzQTt49BCewi5GBbl8hl4ZQRbKKi1iOlQ1wQRL45igGOgO81p8IFBePDE82CaOjINTIVyjvKW+w8eUgjJzqFOueYYfInxSr/VVYjl4hEFFvpvx3QmUg3PPCq3ITXXa9lF8BbhU7zkoKkWGZSUWqBdtBt7Q2N9Mjyty5xgmpHmdepOc/3cmArAD38KaLrt3B6ohIsE4cTOHzuQ8iqdCwEAmpWVgrjFDJpFdXRWkUx4ySB8iT5AqTaUP7C0DnJc1eKDpbVLlOVdzZtxuoslfuD9OCU6qfbtcONs4FzqqhGEjezJlYHxds
 Af85Z+1+
 XUvXXqzDdrcvX3gaBZwHS5a15OfNvnpmEDQNimebhEC0TMc2CgO/o/CUIiVEOvcbJ/BEgW1IpirR+ML8zW2yEj36dUU8nuQ1yIguv/AHyvDQpq5tojT9h/ivNw8E+SVaWtdc3SSkBf7Dfa/OJE1X9eREsbvJBkueIDHFqY0e58ng91gBLV66rZ1RB/y5/UwnfYSab3C5EbCk6sbqbfNyeOQQcqHl04bKVCfH/vcBVHQqY2rJd4HUaUDcy8oZ7vqFcexYvLSxShCeHvCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
> index 69404eae9983..3232583b5487 100644
> --- a/arch/x86/include/asm/cache.h
> +++ b/arch/x86/include/asm/cache.h
> @@ -21,4 +21,8 @@
>  #endif
>  #endif
>
> +#ifdef CONFIG_KASAN_SW_TAGS
> +#define ARCH_SLAB_MINALIGN (1ULL << KASAN_SHADOW_SCALE_SHIFT)

I don't think linux/linkage.h (the only header included here) defines
KASAN_SHADOW_SCALE_SHIFT, does it?

