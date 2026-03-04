Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30935EDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 03:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789F66B008A; Tue,  3 Mar 2026 22:35:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738786B008C; Tue,  3 Mar 2026 22:35:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEBC6B0092; Tue,  3 Mar 2026 22:35:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1156B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:35:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11C1B140407
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:35:10 +0000 (UTC)
X-FDA: 84506964780.02.DF73E3E
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1414240010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:35:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=2LOLfPXv;
	spf=pass (imf27.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.48 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772595308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrE0zI+7ilR1NedBJHHio8t27882PDymrHrpls6UPoo=;
	b=4oM6PVaVJuloFbEBkMEfFfHh8eTRhuYS63+Wgk+qTpdwLkSTIcdV/K7U/LmqQ/fjVyXXRx
	0DpIJkTdwU4ZBe0BuQ+mj5phnCPfeC38y2PA42+RiK64lkjxiKZwkazjdLlQtrO38c8gwh
	/TBdD9yWKZhE1kQSsfNkbaYX2yUBQnE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=2LOLfPXv;
	spf=pass (imf27.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.48 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772595308; a=rsa-sha256;
	cv=none;
	b=BsmYfFv+Pxr5SuJHPpXCEnebK6BT0VrcwMBi4uWKsYgrza2I8CKPGJMADaHHKFcFWu7/l7
	xnEacCjqkcFS6zjj84VDkErupwPvfEA+W3+avPsSq/8k5n1lwU6gqM/DMRH9iTDqFkJVro
	74RBg5TGhStcEVMCbf2Gt6R6tZlN8z0=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7d18f80b5c2so4853008a34.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 19:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772595307; x=1773200107; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NrE0zI+7ilR1NedBJHHio8t27882PDymrHrpls6UPoo=;
        b=2LOLfPXvusCRWcJaTQ+Qj33tV5cu+Gv0pxx7erhJ4BAxha+JWaAQqdl7oyJbZ6Emi0
         O7+O1ONXBny4OVucnL2Uzsu5XcW2berXFKlnReYAbAjomeyOW1Gt+2wjZyddvPaVqr0F
         +VpQVJo0GIt0uGg7B6yQSEvVnQFPqn+uMBPiSoK5SlwRdDfJX05sZ/BuME4JJIl3MlZ6
         /H8ot4DEfC+0F4/DCuuLMpWUoCXRyc6X5Mwk+A5ctnRiP4hRjwkQ+ixGIFL4x+55ie0t
         HFwS0UprQq7uCzgI9u7niYtlRJL6oz/JpSNXnahLI+PIQPyRWMmA6Aqv3A5OYzuBfv7Z
         PUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772595307; x=1773200107;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NrE0zI+7ilR1NedBJHHio8t27882PDymrHrpls6UPoo=;
        b=ak1inO8UYGY0bVAr7SsscW1QYSu1/fquZXHIyfXkEUqV/dUfft583X8vXzDgwtjHMs
         kgykrYnn+efOs4XImtM/43Erw+ExEXEi+S+P/eOFm330lnIsooO/3QxYmsVIZOAQdf1a
         6QKejUq1x998+ChHmMDV2Hm8JFCGmrSu1Txt0zM8Vg+tvBf/aYP4k9MIk962mL1QsJtR
         K7Ldn0UoX6e+88ZEhFgjAcH5n/Uy9AzwRBowCXvI9TTQNyepPO2WuZpnKqtAevmOOW9m
         DUjzdxsSMe32+UhalVIeSITXJPmTguf3zzvIVHa+4pyLfMHqmv1DpxPjaf40PjrHH2im
         a7tw==
X-Forwarded-Encrypted: i=1; AJvYcCUgQcP0QeyVeiCWC5g9QRbWRqIyNHUo8jzrC5ylYgoQ9t+oyA0cWM5ZYQ4D2pA1XErTgyi5onkO/w==@kvack.org
X-Gm-Message-State: AOJu0YyhwiTWiVOawzlv5GdvbaDCAAag7P4bk98QrmMvYx9hsG19VCMN
	/d9nEK0YESS9F1WUj149VoUGFM5Ecxd2XxQXbhrfcTkwUOgATkvxMmaKEfuP1YLl21M=
X-Gm-Gg: ATEYQzznMo5yvnFJ/P52DVkXFWJ2ow21ZfD54pcOFMe/H10oOeYecfQZx/osB7Fsk8W
	PYnYv9ntf+iKc8hDHwOCrxn16SwdlCnLDyD/JoNEEn/m4Jb7Q/Q3TVb7BfnYhoXPcoM/RGLqH5u
	2IoEoamAAlg4FHxLfv1QtYeDoHEgrKSy+5+u+8OY5HDUIpNRCt0Jf+9wy/rUMWWMNZul98InXxD
	nB+rT/mKM0maJdgCW/x8ff42vG9r0+ll4O1FpXP5Mbp7+sEu3xRCNO4rndFiEE0ISUdBgUUWV1n
	9h4kNjrvL1gfqeO3M45fmLXLlv/jmRPKpO+a9UH0zWuBxbjpVaD9zydCxBvARXy59Qah3Z9KxxI
	7oIp/eThl2rXXGWmM/Wqwj5sSJ3zT6Ts0RJCUAI3d+dxFWTnLCm3CIZsB0Am2gRAT7TKuG2bsXY
	SwxUHMlfguUkY4Qno/Gg+7PounyCkXZ4uVC/6UeBXd9qxGiKAGAaQOhBSjOlTUPoNsoNup2B5k6
	Fc09fCFXA==
X-Received: by 2002:a05:6830:6185:b0:7c7:6977:17cb with SMTP id 46e09a7af769-7d6d139f788mr450044a34.21.1772595307034;
        Tue, 03 Mar 2026 19:35:07 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586653f6asm15202012a34.19.2026.03.03.19.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 19:35:06 -0800 (PST)
Message-ID: <e96e851a-9050-4d8c-b1e5-bc3b5d91a84c@kernel.dk>
Date: Tue, 3 Mar 2026 20:35:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
To: Yury Norov <ynorov@nvidia.com>, Sean Christopherson <seanjc@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Simona Vetter <simona@ffwll.ch>,
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
 <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
 <aaedwFwXh9QXS3Ju@google.com> <aaen2pGs0UeiJqz1@yury>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aaen2pGs0UeiJqz1@yury>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bbwbk3ne5ffjtidp4e65sqnuzp6rgtiw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1414240010
X-HE-Tag: 1772595307-498888
X-HE-Meta: U2FsdGVkX1/Pp3qEcC8yk8V6miBnGBN6s9UYYCZw92JtgKBiHdkyyEodHblpXFs5bDeONOqGAjHvWNMHEgEXXohxMAvI2WNF8SRB8WBDhx93Ncd1Fc02AyguPBaULfJKCkwhw1elJ/I1AhpQhaSRmGHiJcU18QPRB+hVKzlR1XHj8WQ2H6pk/CpeFRJnLH6//tDDCSYM4OPGUNGyYHO1AHy9ffqzl1ujrKtP2oUL+UryiPlj5P6hLpezuGYV6kJYQ2mV46PMbfdj0O9kO9cOALib+soeRO2zvZZievmGHVz6utTAY18o5YLFr81p0r0teq4KdEHxgJ5kzEJGpqIAhcjB6rp/OW6Hx/NzFscZeH3vJr32HijdmODQZcBC6XcSZr4LfcmL32T/uAxZAiQsWXPWxqeDont2Thhv5SmkTMcTL7UcFeWZAp8ATwlbNJLfdjcQr+ifJsOKIOchB1o4G9YwFtrV/6C8FpUolLK9hv5ZsUoULhyCHAbsvFsQyWtOokKBKNp0RbI6hdz1YfOMto2LAEEESDMHqkzZy0FrlP9WkTxSKRbv75zpLusYne31Hl9JvI3W0LgDP3elrqvkiew+GxjLxuk1EO52ZR51YOObWCl1WixuhGaBjkUrsOV/80YY6Blga/SLhyDzgvrDqBQ0zChf6Nw6cSYJ07gScMMIM3L2Klp/7U9+fox60LI03cMqdooPkSifZ7luAvlIZWgmbKgI9+cdPN+Flhgbcd2kkDAtw9mQqhuQvG/e+qlSg6jR1I0PRak0cCoQHUm5aM0Qz7cr1HA4GriiMvkOYlqq2FAsQXWMGajKrfy0Nqyw0KrYWz5h0N6qec1pExgDX7yRGCYHh5HcPdg75GDNhcklR/mt0uuf6XzhBefXQVsz63xtNzoPZQYCa6lHnEj72HMEcaClNxn7e4RbXgdC4b1wcj8nUvNmCq7kcU5j56S+mDorWZY46Whn1bayWZ5
 /ZKifwh2
 JSLmQ1Es3VJu1zgmJkIjlLwqrqrtJBdmyl6qppf5vm+bY0VAMMY9CVL4oskHIQr17WNIJSBS3LdNvJaj66HyLEfZB0BfTau5X3yAaiQs0tMk1Meyh6v/EGZcGBkSMJefuk5uR5AOO5t7/wuDsUG88diGgnUo4lp0z3QUOlzcHcMV1pz0B01FQZG40N4ZblIbOHKT7o6fy746AuLhceiDtQT4DEdlsfNhsD5a6D/jG8dxtiQvt0GQ9QFKs+7WCFsodJYAE7Dus3WGTVQXRzfy++oIYQQP3s9tBBVDu1sw8STe6q872dgBkfZAA377LjR9QbxtJPea0n7TFu7ihpRPBztRnkaeHGrNMfVrXkYupWz/1fhUR6UUwNUQC0rg33dRtSp4gUcIKKpMBUrVWX+95V6zfXzfrLcaw+ajn9TpdPYbksS58rbj0p1nHbzLhSG+kM6ysQHEw8I+Oko8r/k+5JsQrwF2GkBDZmMT3jeX+DEm7WyHzCT8IXkksqb6pNgVQNHx+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 8:32 PM, Yury Norov wrote:
> My motivation is that it helps to simplify constructions like this:
> 
> -               loff_t cmp_len = min(PAGE_SIZE - offset_in_page(srcoff),
> -                                    PAGE_SIZE - offset_in_page(dstoff));
> +               loff_t cmp_len = min(rest_of_page(srcoff), rest_of_page(dstoff));
> 
> Or this:
> 
> -               if (folio_test_highmem(dst_folio) &&
> -                   chunk > PAGE_SIZE - offset_in_page(dst_off))
> -                       chunk = PAGE_SIZE - offset_in_page(dst_off);
> -               if (folio_test_highmem(src_folio) &&
> -                   chunk > PAGE_SIZE - offset_in_page(src_off))
> -                       chunk = PAGE_SIZE - offset_in_page(src_off);
> +               if (folio_test_highmem(dst_folio) && chunk > rest_of_page(dst_off))
> +                       chunk = rest_of_page(dst_off);
> +               if (folio_test_highmem(src_folio) && chunk > rest_of_page(src_off))
> +                       chunk = rest_of_page(src_off);
> 
> To a point where I don't have to use my brains to decode them. I agree
> it's an easy math. It's just too bulky to my (and 9p guys too) taste.

The thing is, now I have to go lookup what on earth rest_of_page() does,
whereas PAGE_SIZE - offset_in_page(page) is immediately obvious. It's a
classic case of "oh let's add this helper to simplify things" which
really just makes it worse, because now you have to jump to the
definition of rest_of_page().

IOW, just no.

-- 
Jens Axboe

