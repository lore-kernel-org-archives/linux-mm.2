Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE93CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F628E00CB; Wed, 29 Oct 2025 14:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110658E00B2; Wed, 29 Oct 2025 14:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40C68E00CB; Wed, 29 Oct 2025 14:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1B018E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:46:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8595B4A1BE
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:46:02 +0000 (UTC)
X-FDA: 84052031364.16.DABF055
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 83B0A180006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:46:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kg9h8bLs;
	spf=pass (imf06.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761763560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWrPcr+YHQwlDYGWW/C60xpax+dwnoF3boq6mvUGiOQ=;
	b=E0DStKNhFJElOztKwoM1YiwnRxCRjExcTaJ0zy7hPQP9HX5QXutQeGfNYW4llTUHQbny8h
	V95RTskL+xdNRg9WbpA5/HD4F67cCMlM2lHR+m+jayYi8a2X6uOT0qT2xpBj5d6R+l7M7F
	3tYvZ2BgumBoSykW+LNZmNGvDW705rQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kg9h8bLs;
	spf=pass (imf06.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761763560; a=rsa-sha256;
	cv=none;
	b=U5xPHE0UFuXEpnLZmOb8Q2nALZErNLcGDHKj1tRbT1/5ZpR71+Fyve7MVJGheRWTQL8vPc
	C0wVNKNMPO9/j5cq8ef1BpuZDfFCQ03O3dcCGJQccbBBQ9BGFgPZJ2Vv20hMVVxkJdElpg
	KVOCqoEDWRYEglmRpl8JCxqrDqJN4q4=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-592f3d8daa5so17590e87.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761763559; x=1762368359; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWrPcr+YHQwlDYGWW/C60xpax+dwnoF3boq6mvUGiOQ=;
        b=kg9h8bLsOIMlfZ12Oq4hPKHh6eo3TL5I8uaPjxMankCdNEhavAIYoDogfcti45jzgm
         krSWOpKqScv3AqFv+RFXmYHABM50PHzc3vIeFBv6V0TWayp7QlLoyjLcnioALz3g/CFW
         QsJBxYQ9x7/m7D0bsIj08jQu2i3CZ9Vh9wPQKPxNAF9jcChOoA/+wwJwpXGifz8SNXzb
         2dlsu0eF3aMtluMaoltrG7KVQs0n/l66/d8GqqgvJ3vIhfEmLqS/G7vtK3UPLSFXYXOi
         GE+rcrbdnFRC40DVccnFOKtvA3ccjZsfgiUAPwSml8rI7/1aMk3xUZFeJFFBrKxIzFLR
         72Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761763559; x=1762368359;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VWrPcr+YHQwlDYGWW/C60xpax+dwnoF3boq6mvUGiOQ=;
        b=ZEEqBOL649pE4hyJOC68ceV55tX9CBuvGVtbnC8pdO5npMWxRT6pSTlW2Wn2B/PRDC
         54NV3qIIb/cKloWDgHkk7F2evB+HLbEImPMke4K3v8pAqK7hNsOb9UvDaoFm7husk0VF
         sNgyCXP9KOuHRE5J33w05OBqGaGChLK0F758cdL+zcYdQCXowtpcSC3/94GGlEoVsd69
         gjhDKGpFT++9W+ohsK7fk7ySQr0U8kYrBt6gXC1NHS4v6fSpCd4fuOBYc0jR7JzpeT+6
         RyjdjLRSzITwEp6Lt91x16y3HKBLe7YjXDflgQ4M0TXCrDYsdcOPb62AsRcq+zNT68Sa
         ca0A==
X-Forwarded-Encrypted: i=1; AJvYcCWe6q7mOwsISpXw9VEJMqXqbv5OJdHHT5YW1sucTmVK1R1kIZmRms7DeGP5wh+YSDxz0JubibE6+Q==@kvack.org
X-Gm-Message-State: AOJu0YxSjqW2y7ZMYz5ExU/LRn/2y+1raIatY8SUbbfjMlVrCdwKvqYo
	+U/CFTGQ//1bS9+JYOprgpFZWwncEYynxJRUYeJgoPbYvrcuuBy27STE
X-Gm-Gg: ASbGncsL1ELD7gASbAt9Kz/J8nGzfekPehw8C5bVMiClzuBFo0h6IzeDGRfBrA5eo8t
	wctHLjq3LfI9As0lAlivfHM4v4dm9DOKNtqrxMxS4KncbSPi7Qaoqh/ehdea+Xf2t6QUIDGrnsn
	9ZJPRONWBcVJAfaoRcj5Zft9XQY6ClzUSsoIaWru/VagF1H83kjJEsHT6hdLnwm+6YDYvuBqceq
	FPS7k+0u3rkvAfLX/QxzY7ApfCI1t68AAUsSb2uHFYi5MmaxH08FstrEdlhZb80ADgDZao/vZIQ
	a4E01iOZGaCTpo5sRNocYbyBIX4eBEoEFs+/BEwP399wik6Ij/kjKzAXGr4s60D0FymkP+kqMGP
	w9YQemEvcGxrRnpc2pCpdv3JUZXXtk/XG7q+c7gygzGv5rTZejUEDIplTNK8GXsYUhSwgtULN14
	5fEC29iw==
X-Google-Smtp-Source: AGHT+IGuEzsNziCkBkpixVM7TgXRYPDuuncHpPEAXKQDJA0pf9GlMeK+fWS7c2BxL9a+qZkeWch5IQ==
X-Received: by 2002:a05:6512:2246:b0:579:2ddf:996d with SMTP id 2adb3069b0e04-5941286a767mr855964e87.3.1761763558572;
        Wed, 29 Oct 2025 11:45:58 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59301f5098bsm4044641e87.40.2025.10.29.11.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:45:51 -0700 (PDT)
Message-ID: <c8f89f0a-a327-441e-9bd6-17523c5fa65c@gmail.com>
Date: Wed, 29 Oct 2025 19:45:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH V3 6/7] mm/slab: save memory by allocating slabobj_ext
 array from leftover
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org,
 vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251027122847.320924-1-harry.yoo@oracle.com>
 <20251027122847.320924-7-harry.yoo@oracle.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20251027122847.320924-7-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 83B0A180006
X-Stat-Signature: e3hzwaqendxoh3znby8ae4m6ogks536y
X-Rspam-User: 
X-HE-Tag: 1761763560-662638
X-HE-Meta: U2FsdGVkX18w9Ayot1fi5eghqxpdfNR5RPpGcJZJY261LdhQpw7mQz+pl01sw+bt10tB7XUin1tOGyXVtWy9xXpfZglyqKj13TdAxvmLzSMqUeMjVfe9EBsFfkUGAxUvFMPrm8vPb4DTxkqc+FPF7bJwFG+hdJbTtp6QdKCkUsrq07KndY/pTOwB8G5Rwcq83POghZkFwBDEfL/YKhICpbTHSXJNRAgOpC4UGReRHtuap1B3cfmGwjxHI9WSX88zWDJAYpEzK/Y8xeoVkDYeqdkJc456QjhLrrMJpmMZ8FiD9vESCWBKSkqotEf77ckmrjtbxS0CyVI6T9JNHGVJbpnvjl+FUDuPG51FxWsSOLj0YNK1ahOeawkyWwtJcC3Mebh7cyBH83lY0QVBjteZSzOTXpfQnkE8/iZ3yXle3r3XpSuSr7EfD+RDeDpLZzJt+IL/DXSy8bV5ahIcP1bpsfTgO32VRUQiCuXF0XOL5X22KwSsvCbkkTrbN2UNBqsO+SLzbLPxKZnucdIVa1AWsOExehDBE2gyE8VwBmW3OPQXXIbgpuIyhl6Mn93NygI02n/mroVaG+o4J4+nxj6eHxNZ5SxwazhLhXBjn1vDHdxOSvCJFAGHeb9K+d/Ht0LOvtVHDjD/kpP0OVTTGyChoAJEIZyEFnmvBhv1C0lJeibuQ/EE/AQb2WNMeaa17yi55eRC69Sa2QXGB57ZWdFHqFodhLtGkbtL44WWTMPJV9loDV8eYd83Q3coXvMYzADNA5/O35DC29gno12709b3abptYzNgfgBlb1AGMgXT3IoZRqT4WJUEasCJ4PZiDd69HTvs9veiTR2rjwkX+0vRvRL38+bMAn8d909YzJ5TyLtuIQqITXpa6r877hvIJypeqeUDIIbT06vHMXas3HO/Citd/frZTHDKvkpfbwXBKfcetzTWKIMdJxyNZYGcIix+15s9TEQhZ7ssFOD2AUS
 GXJgXs+S
 3kWMzxTYc4/m5JTiF3YsyyPOOOw9uO4Q39kybp7Eshg/BgfkBaayDVlZh4iPmmRsXbtdfzUPHb9IwiQoqFtVoUVpZNeObyo3ccpf5NWJ/FE/Vp8rR4NbWs4mz4od5NsqT8q5kKKGw2FtAUtszoL/XBoR1IsXVBafEjwwYdIsKL0SfA77M9+MgJob8ZYToL1cGdmDz3NA88kSaWlvEk6IaLTqvXE7UAIJiGR4Nb4k+rZrXpccKd8CmGI9Dt6nRB8JDDZGSenHAa4pP4xf1C4A7nohlT7/nNxx4/uXKCTy5wz68+vgNMPOdVKnNzlSM9kqnpbkecdMydTcxrCtPeopGoPD1tPRLcMFYd4Cc8V3ydFoeQw/7xgBnogM7BQVff7ztIXqF6BvhVjICq1u7SaHmourP1oO8mklLOzwPTuODHOFul6xzSlrHEZzkN2hISThUxb9lL3dQFfxNvOqq9/t6HOBsatVaEyhjTVpqD1Gbube8HYSQRyZp4RazyynqwcSIYFhUvIYV9Zn1NwpWfXdefKFSt7Erd6MC7wXi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/27/25 1:28 PM, Harry Yoo wrote:

>  
> +#ifdef CONFIG_SLAB_OBJ_EXT
> +
> +/*
> + * Check if memory cgroup or memory allocation profiling is enabled.
> + * If enabled, SLUB tries to reduce memory overhead of accounting
> + * slab objects. If neither is enabled when this function is called,
> + * the optimization is simply skipped to avoid affecting caches that do not
> + * need slabobj_ext metadata.
> + *
> + * However, this may disable optimization when memory cgroup or memory
> + * allocation profiling is used, but slabs are created too early
> + * even before those subsystems are initialized.
> + */
> +static inline bool need_slab_obj_exts(struct kmem_cache *s)
> +{
> +	if (!mem_cgroup_disabled() && (s->flags & SLAB_ACCOUNT))

Shouldn't this be !memcg_kmem_online() check?
In case of disabled kmem accounting via 'cgroup.memory=nokmem'

> +		return true;
> +
> +	if (mem_alloc_profiling_enabled())
> +		return true;
> +
> +	return false;
> +}
> +

