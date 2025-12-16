Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AF3D609D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 17:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270866B008A; Tue, 16 Dec 2025 12:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246E46B008C; Tue, 16 Dec 2025 12:39:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DB86B0092; Tue, 16 Dec 2025 12:39:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 058E26B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:39:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 906AC130EF
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:39:30 +0000 (UTC)
X-FDA: 84226046100.03.0171EA0
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id B5CD620003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:39:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DgJWFLA7;
	spf=pass (imf03.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765906768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDRVcNBtR+iW6Yf99Q/xL+9AQK2g/UaoVu1pJaWUN/8=;
	b=2SAL9Nk4GTztrLnsHUYPHr+2UyVqXDooNQBFw5oFAdgxV3HW20NEmDb3JdUGz5U0me1fMM
	ocUjdiANa0D1UTq41UBPfj6rt5v78sJlJZp2YRcBzJTOfLbTuZO3Ti9TSX8n7tIk02WId9
	IXg+LwZip2L52lU7z8XOM7/R/Ng7NBs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DgJWFLA7;
	spf=pass (imf03.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765906768; a=rsa-sha256;
	cv=none;
	b=j0Ez7Hf1qeuje/OZOB4rCqIYNkAtB/pjdoAPzpL4aVeqrTX5YHt0V1rl1hsLxpWllbGSUS
	qdGDBo8nO5SjPbvAnbYVn6LlZU1i1i+gc86EDZjF+d/uflsvAhgmRxBXxqHij5aoh/Q6A5
	xGvedbHNt2IZLgAEr8Pl4WKQIWfJJSs=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-78e602d09b6so39808997b3.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765906768; x=1766511568; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wDRVcNBtR+iW6Yf99Q/xL+9AQK2g/UaoVu1pJaWUN/8=;
        b=DgJWFLA7EOlL7RFf1stn+Ay/XSZNwY6O9QS0JFp108O1ow2JkrBQTl/73WH5FAIJmS
         a+2Q4ndDrYp+k4i6TcQiucEAd8I9zHykbeku1BaWxVxIHhODEMEN799FE0LYT459ujnV
         D+tep5ID3xZKY7lEF9LqLS7ZCxx8AAetPidxRG4OTgfI1wY+GN/VSJqbIxQ3ZHvpsYuG
         SrMhff60PnrTQ6rijXUHcuSkj83qct0iv3gxiInPwZyrCj0K8p4O2EmOKC9dccLWRc/C
         6CgltK4iBQx1dD+mxsTEPtUL7RZKdcbVkL8M3jc+SWnat0963HtKkJ6NTm0aNyGEhptm
         1sZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765906768; x=1766511568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wDRVcNBtR+iW6Yf99Q/xL+9AQK2g/UaoVu1pJaWUN/8=;
        b=SgjqxUpQENnIBfPwKwFQ+/gReesnnLMYZ/jeKVyGX1s7FUls0q03Uu0+jy7FYxhPqd
         FTIExuKzc4fl/IvfacWBtEfadWpX/CJBLoOs2riS59LtpGZNypU5NGJF+eL20y7tvJl4
         Zlu6RjixqvVCU8fdHEL47B6S2BHvve15oAGuujr6Y2zJNB2XUgiuqG4bGpvAAiet/VJt
         fcTGfElttgv66erH6ksKq+N2dxxaBTRc5Te3lWkkHt+HnxKwbeOYGdG+bGiuAf7pZiBS
         s3wJX7MLshE65I30S2xxdNkKgKgNOocY5nfhr5WR8bAK/XUBg0seOip1/UYsTQn1PThZ
         0slQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqbrOS+0d5DEXST4sxhQppccaoNAFn1g9cmAeFh3svJLBezYXEKAE/Ts+MP1rGedduo15SEKCM4Q==@kvack.org
X-Gm-Message-State: AOJu0Yz2ZWEn/lzGY5ZiPbtfScl9yQxtQfvvT6yS5wZG2UWUYK7u0nzD
	aU+yrRSrk8E/3gODJK/JRiaF0USGDmiJPynXHPocgTPqqmjow8/kH0Gw
X-Gm-Gg: AY/fxX5rYtupQxcQ3vNUFZz+Bf4ENXLQ+cdmMD1VInvWMJIx/W19Bq6PBlBVrsSCPwJ
	Qa5KGlDgeWUzLg87YyaIIbkBJv7LmM9LWZN+ykpRLQ4hAcIqXWf6I8X/ZU9yIzPfCkxEf3u83fG
	0BBWWWEx9TGO3WqpeympmmN1xl6ZItdwEWm7OUhPysHLqMf/r/dNdcXLt4BWib56eUHUOjZr2yk
	/5dv5wS8OrrB9r92NFV0aIPzh2xZ1uUS9DcW3YVgTWeVskEa93yX4tTjpemc2lyEqdYTECBPP4U
	SfYOk+LV5xTlGj6WtDBI13WcNlCCAv4bh6HQ/XakCnacc6+s+SOtsfI9OGm8TPGVBgMRQEBlh6+
	cvaD0WT3vHJllGfy1z80/uxavHWlP8tZogfJ1pZcKVAkXMAGJMj4J1fw6idw5tf3t+OtPB/fP+/
	8dSJGyUVo5mDURVwEJLg==
X-Google-Smtp-Source: AGHT+IE3NinGFdKlAN7UhDAbPKCkBHxHtNBkcwDeZ6wptkYuBgdRACzHAMbsJH1rL1T21esZqKIaWg==
X-Received: by 2002:a05:690e:1248:b0:641:f5bc:68e1 with SMTP id 956f58d0204a3-645556680bamr11330010d50.78.1765906767566;
        Tue, 16 Dec 2025 09:39:27 -0800 (PST)
Received: from localhost ([2601:346:0:79bd:7f3c:658f:3c84:2aa3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e74a57202sm41212187b3.57.2025.12.16.09.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 09:39:27 -0800 (PST)
Date: Tue, 16 Dec 2025 12:39:26 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: aou@eecs.berkeley.edu, alex@ghiti.fr, andii@kernel.org,
	andybnac@gmail.com, apatel@ventanamicro.com, ast@kernel.org,
	ben.dooks@codethink.co.uk, bjorn@kernel.org, bpf@vger.kernel.org,
	charlie@rivosinc.com, cl@gentwo.org, conor.dooley@microchip.com,
	cyrilbur@tenstorrent.com, daniel@iogearbox.net, debug@rivosinc.com,
	dennis@kernel.org, eddyz87@gmail.com, haoluo@google.com,
	john.fastabend@gmail.com, jolsa@kernel.org, kpsingh@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux@rasmusvillemoes.dk,
	martin.lau@linux.dev, palmer@dabbelt.com, pjw@kernel.org,
	puranjay@kernel.org, pulehui@huawei.com, ruanjinjie@huawei.com,
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com,
	sdf@fomichev.me, song@kernel.org, tglx@linutronix.de, tj@kernel.org,
	thuth@redhat.com, yonghong.song@linux.dev, zong.li@sifive.com
Subject: Re: [PATCH v3 1/3] riscv: remove irqflags.h inclusion in asm/bitops.h
Message-ID: <aUGZTkLGYuew7-s1@yury>
References: <20251216014721.42262-1-cuiyunhui@bytedance.com>
 <20251216014721.42262-2-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216014721.42262-2-cuiyunhui@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5CD620003
X-Stat-Signature: ik64aayam685bey8h5n8y9x6yn5rw4um
X-HE-Tag: 1765906768-802828
X-HE-Meta: U2FsdGVkX19gnt9ZtXWSl2Rch3zdoKP10vaVmOagFTUEwNTnvak8pUkxzNjOyD91hCzfhClJBFhBIFdgO+MAUWBuhVrUR1ItddK5S79CsbRaTa12IG9Tuy3A4BOL5KpLgTxKDsrqNnO+jvbqg+2/KuYittj8mBYcPofXEmi1MCSSomCxbiWutOu+R4mihXUl+qSyAwYhgDo421Dp46jVFBkGnHZ+iL6JdIBjAMHBlk9zJldPl/d8mU5wd7IDuTAmeCImhZeHhwneKgPVIc2sy9fuAhjbRAPOFF93rnb+SaoGPfn2vBF3RJXhaxviG3HNmOQA6MYKE9DOTRIK/pPmKdc82StufCAhEqK/x3MyFdL5/U23N1ERI9y2GlKuw87eQymyynalXLnkOaoCWKfTflpTwWfyFP1rbctImoXwMziE8H4s2v5eUxOLZQwoDBQW2M+Kq79L/rLPbURulPxIqBYHhAPBBv8Pr46YBqMfMLsXA65waVLtbZXNpr7O94l+CRy5V1gLVcKM8cgHG0MPxSSdbc1c4nOa8l9eDJZf2Ft9os8fwu+BufdnD/3HAMI2PW4EZs4CFGoEFBnmqWgPdLrh55+XBAZeUwjiGIsDzKwg214cd8x8EGmf32RQH/SdZ8jNPzDkvtUl7eLPLOlzcbu7+CAKUXf4M+XOqZ7rGYVn+iwj+HkOL2DRI2Oh4wLNoSz/AmpDjQYjdnDTcbZZEKk6Tg4u1GWgbmAEaULD/gXyxIXvh/IdQSKz/mDI9vntF347pgHum6//UsIYYRKD/92YA5pkYAr4gLx2Bv4GQFbTkrdHEi5eHSS0hIwSk5g9VNVCkfJi7yyQ0ZLyZblKn82re9C3K5PBzhU1H4S1zaQu3tY5MysHkOXZvzc1NzVzIpIepVh+SLbqh9Ali/xtOWB4MQqoLhg8q00N6SJzebp3yt6KM8IjCDRXk+7MomQcDudmrcojcpOeHgfE1Hk
 YpYCK2lS
 MAbJEsgUGocPPQaxh8+UiNb/grePG1kVVjr2OdQLZ4jgO7gCVHR2M2GmOqDBxVyxQHsgci1zk0C60ooQFqUunQ5sLl17+Po13fV+Rmi5xby+6L1guz2Z9/26nnL8FJ7V1HSF+Z3XHU2aWfvkFYiPdTC1j8FbT7WJ9qjCirMFI0kh89D+gGO7SnKLPyDKAjDheeAYyIXoqJxhl5DIZfdIOTb+Pbdg3mbKGpN0gbblsbMbwYa+EslRe6btfLjXKQcjLOYEyAQSSkdMNVivHx79m8LX4R/53V92NhY1GjgEKRihKh8g/b0/QZPA7wd/LV1k+3ePuCI9rHEX+FLO7el6Z85+Bk9xlTepp2WY4f0lhOx4D9aov5S2r50MeKXspfnM0OW+QOx0feFadCNTbEtFlN0P58MfIvyvf/me4eciRJHPhR1L8g26fOvNEYSac+E5pogaCji+4iwb23se2e6Zfar6niZ6nd6n2nreSpBreL/9oAcUeScVYkCb+7oD3VJ+5TzXP6C0/8DKQlF0wOTqThXO/Hk/GOS9eXNMyOnC74GQTdopzcMPhp6Q+wz0layHzxNgmV6xc+gAJ4YT6SPD0GLVV5J8mpoubcD5VXPstnBVqyGHlrXkq8cqzOt3rxUzMVGP/MsdFymR7591QfV4OcRIr4Qa+IPqVWHNs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 09:47:19AM +0800, Yunhui Cui wrote:
> The arch/riscv/include/asm/bitops.h does not functionally require
> including /linux/irqflags.h. Additionally, adding
> arch/riscv/include/asm/percpu.h causes a circular inclusion:
> kernel/bounds.c
> ->include/linux/log2.h
> ->include/linux/bitops.h
> ->arch/riscv/include/asm/bitops.h
> ->include/linux/irqflags.h
> ->include/linux/find.h
> ->return val ? __ffs(val) : size;
> ->arch/riscv/include/asm/bitops.h
> 
> The compilation log is as follows:
> CC      kernel/bounds.s
> In file included from ./include/linux/bitmap.h:11,
>                from ./include/linux/cpumask.h:12,
>                from ./arch/riscv/include/asm/processor.h:55,
>                from ./arch/riscv/include/asm/thread_info.h:42,
>                from ./include/linux/thread_info.h:60,
>                from ./include/asm-generic/preempt.h:5,
>                from ./arch/riscv/include/generated/asm/preempt.h:1,
>                from ./include/linux/preempt.h:79,
>                from ./arch/riscv/include/asm/percpu.h:8,
>                from ./include/linux/irqflags.h:19,
>                from ./arch/riscv/include/asm/bitops.h:14,
>                from ./include/linux/bitops.h:68,
>                from ./include/linux/log2.h:12,
>                from kernel/bounds.c:13:
> ./include/linux/find.h: In function 'find_next_bit':
> ./include/linux/find.h:66:30: error: implicit declaration of function '__ffs' [-Wimplicit-function-declaration]
>    66 |                 return val ? __ffs(val) : size;
>       |                              ^~~~~
> 
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>

Acked-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>

> ---
>  arch/riscv/include/asm/bitops.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/bitops.h b/arch/riscv/include/asm/bitops.h
> index 238092125c118..3c1a15be54d80 100644
> --- a/arch/riscv/include/asm/bitops.h
> +++ b/arch/riscv/include/asm/bitops.h
> @@ -11,7 +11,6 @@
>  #endif /* _LINUX_BITOPS_H */
>  
>  #include <linux/compiler.h>
> -#include <linux/irqflags.h>
>  #include <asm/barrier.h>
>  #include <asm/bitsperlong.h>
>  
> -- 
> 2.39.5

