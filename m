Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57848C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67A58E0007; Tue, 22 Jul 2025 15:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FA48E0001; Tue, 22 Jul 2025 15:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54FA8E0007; Tue, 22 Jul 2025 15:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B68298E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:52:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32AB1C048D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:52:28 +0000 (UTC)
X-FDA: 83692947576.19.75641A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D97B31C0009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:52:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cNpCt08M;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753213945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tD9jiUjYIe8zYIe4eFuBdSpjTfktPJUQThqoL5NZe28=;
	b=5pGv1Yb09sMtSTdjVLGH1GblF8txgUNyUmPcpJYqa8ANl1o0U44ax/twtqIYKj4QsEhkSX
	4/leGQ19q0QMNhlOf2tqQOphx9qYcP6TbyRueFlc//HjIYT3xbhLvV/4blcv2lYguEMOg7
	v2QbAmkGHQr0n8JSYl0xoYSyt/CxiJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753213945; a=rsa-sha256;
	cv=none;
	b=SXs2W0sSP5euHPh9NM8UmHJc3IyFcyqLCmteu4B8q1HfZP82llqiCOAr1Xu4Y7JEIoYCF5
	pg7RRQGeudvKCMtDbOr/0unDub1NZ1e4AthPizCbRf27R9HoW2osXYrynxqpYMnusjmZvV
	2uOedIFTV6LvqKmfteERDZbfncfYVJ0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cNpCt08M;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753213945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tD9jiUjYIe8zYIe4eFuBdSpjTfktPJUQThqoL5NZe28=;
	b=cNpCt08M6BeFY29y+WDJn1avVhXCddG4SvSYwXMmSPbkJCfHJsznXHJKJiehhj+mtHaFjs
	BwVvbJ1xoMyQ4sOKtulh84b15jcJ6Mp1V10UREuECNIk4u8+M+XwjJ1m8yX29oejTwwsee
	lJTqyFHydBwZF3vYQRAU0s8AQQ3ndPE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-Yalvs-FTMQa1nfSoUYUmxQ-1; Tue, 22 Jul 2025 15:52:23 -0400
X-MC-Unique: Yalvs-FTMQa1nfSoUYUmxQ-1
X-Mimecast-MFC-AGG-ID: Yalvs-FTMQa1nfSoUYUmxQ_1753213943
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4fac7fa27so2112051f8f.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753213943; x=1753818743;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tD9jiUjYIe8zYIe4eFuBdSpjTfktPJUQThqoL5NZe28=;
        b=w1BX2jiujrNetdJf+0Hl5rwBA+wa3sdbcW7Rw+S8yN6wbpxWF6CyizcOz7HkRGtejQ
         VKtwb4ZcgXgmnMpzTWuJ3O3YlaiZgynhB/FCZ3WRO5EA9+rcoP2EP3+aDHOPH7y2cRCH
         bS4gt1gd/Ej87i+1QmbwZayJCq7XOrzSD2fAHxoIYwOjp9Z7W3REh+AMc9Oi2WAy0jnU
         +i1cNSQWz5k1A9e2Qdr/8ngzIOXdXcvh5nOKK+ZeHMeKrPNvetwGNF02+qoArrLO6KlY
         Xm66CL5GmfzfjAUVywtPx2dGHN8EShYuWeu+JTJ1KLGIcoDwyy2kSRzRQAZvqAnNgz4g
         x1jA==
X-Gm-Message-State: AOJu0Yw+CxxB1JNyT3ns+yHpbYb2TZCXsU2/7EKa7C749uBySv6rIZGY
	m+t9j9f9nqN6djIHEqW+UkrutiwKvAqEe7Ufo+MEsVCjx8o1CAeJM/M+WfEtZWTsfnWH0dm2VWo
	2VfBYF7iJ2RQuS8y7T1xu+owbfuHIPMXQGfAukiJG0Ye/ujHcSoYt
X-Gm-Gg: ASbGnctkYDk8sfEvE/v2f4MOn/Ll0GbFGcAkzZYm5ZIvs3Kb2uvkMT0Dio/9UvO4kJM
	iTQlC0W/iUNWMYxsM2KrY+johBAo6qmLbo2IH7YGOYEK5WJoQx5TSfuaXAVsmnxaJQG8zyA8ZUP
	Zl6o8xe09iJGo6RqH7W4uJaeLYiBUCoy1SQk2sgfhaF4Ia+CKBeuw57sFuKx9zk6Jl1bGG3VzNb
	s7TKEG1c4TwcjKS3lxBUzvkEbl8EqIpdtqo+RxUuKFNBbxmd2rT3oskjbPj7b/eQQEuae1iZih1
	ZVZsL9jGC74nfjfn6C8MqojqtfZ3Er2vz0x8lVx7RsCc+6ajOrNsQUbLVgt+kUNOYPTlSi1f05d
	VhUkvWTgRScBT8NCnwfBFE18OEI7QJHUXSEkEyX8zT6Q78moXL+osOOnQD0JMXuU0UOI=
X-Received: by 2002:a05:6000:2901:b0:3a6:d255:7eda with SMTP id ffacd0b85a97d-3b768ef3c05mr430507f8f.28.1753213942677;
        Tue, 22 Jul 2025 12:52:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxjPzE6sEuOfFSda8Shbpmks8LbyR4O8i10oMHV+LZdZJzBpZoh5NGpkpHb9XCz+0yB5hopw==
X-Received: by 2002:a05:6000:2901:b0:3a6:d255:7eda with SMTP id ffacd0b85a97d-3b768ef3c05mr430492f8f.28.1753213942208;
        Tue, 22 Jul 2025 12:52:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2bb80sm14421672f8f.23.2025.07.22.12.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:52:21 -0700 (PDT)
Message-ID: <883296f4-ec25-4961-aafb-b2ccb1607422@redhat.com>
Date: Tue, 22 Jul 2025 21:52:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: move memremap.[ch] to hotplug section
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>
References: <20250722172258.143488-1-lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722172258.143488-1-lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ssrQhrWcntMzvANtw20oqcROxaxx9L28V6dvo1Q-clM_1753213943
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D97B31C0009
X-Stat-Signature: bub8c1gho11hxafrbs6qpwb71uncccqx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753213945-556136
X-HE-Meta: U2FsdGVkX1/dFTgS/Lz0Np3stCkHOUGuL/To6wOLjYDJQRZ92XtMM+VLjnr/PJZtYG8fsSIgIc4F5ssckMVJ23N+P1FuxCxx4U40rZw8lpoXLPZVhqFAsJGdmkPac5rxRMpWs/3VasgmvWodxr7vAPy/QwbFRWTSVeaRuX6RfoNRY3bZ1xnEH0P6Cnmm4JZn+/g6TCIVw151LY642oMgdhbF1P9G1brfTWve2NzoAd0czkpHXA3F7LstsJp34TxvYdslKE4IlwbgOHNAD5DCQ9uG8pU6qYO0pf5Iig3FwYi+mmOMZdP8m8TSq/THB1ZxUigGJW32SOusPe8RdcXfpi2kIrW934zAm6BETMgeKH1vuImOtp8upt28EWtCulqqtBUi0DYCM3Nq8o4RTASc67ELZBytmhRIUmGYSMwbvNTktewjeAcEprOu2McMu9lCthWZK0olr4aIe3H2JJ7RoqBeptADx708YfnGnYZFZ1Qd/5gTIoJKdNNSFHPNbKQaD7MK3RqHoHVEWIU+u30OFEmwdweHoLHpseuVXeMbvrRJm/0o00VChAL6KKXRKd0gRXZ3PppStBLekwrYSqcrnad5gpXWzF2nGNkyDmULIwH6rJLF2xjVlxPL6Q+lmVuTgQnM0n6FsKA6qWSxMVi5pRi5PRw96Phk6xnDvjyLmOa2jMkhrlkY1oHt6grGk1VTCtBXb+pEsZQz66aT3Bk7DafA3oX0W2R46F1z+iyU/gKZgWxkstBsCnKzR/yCgTxbhbJGxuBYlMzyzMhgmxlPtSf4hFYzBZnYLq22D7/y9m3ZHbgG13Xde5iQKz9ILGG/3TOmpWphdZshwcuJyuGlg8qK/C7Fu2T4C1z5XZvarIkX75H2FT9Jb3vx8NHr+vmrkCXwW3IdUxA8pnXgqjJErEqb090BQZDIAH6ct3oO6HgWed4ByQ4IVUJyYFxuC8dQ9msFtbobUcyHwYTFcy9
 PiSSTIH5
 XrDFC252KgPqj+VPhLysY3/UMuKUGHYro6va9fPa+0gwXeMaY5tfjiNE8C7/FxgB7EadxjWq3UXEnmUikF3lZHj7cjdJasA4UzeSThPhhim/AN9vOXXKuKU70iSsk7I/UMIQ+7PW5SCU0f2557/zziW4QoOxuim9/t+hqfKChSUKh0gZFAntBXJeXxYFw6QEG7qyz7Y7Huddtj56TqslHb1aJB5CtBKXfiTv3ebYXTLE7b04vtoBBkP5didbIJIJg084aBl3QE6E/29zWL/e2MvaXwD8KNyR4vPeQTTsSgh8bp4HNQA/dzSuWwCxguFnTkNi5aXeyIpetIztKMIs/rbHAurjPcfZ604CYCl5Y4se14X724fTQqAN0xEnk9FG0tv/FDXi0fWJkYzjZxcPsJ9VzDSA0PH7wl0y6eH44bgfMd8FOb25luZ7ljR75354vvYMZLM7g+eXm0JwvEybaiDtiFXgRe8FkIESREoh2+4lTwsHdbh7QtpU8B7KpbtQAew3u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 19:22, Lorenzo Stoakes wrote:
> This seems to be the most appropriate place for these files.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   MAINTAINERS | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..68b8407926a6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15729,6 +15729,8 @@ F:	Documentation/admin-guide/mm/memory-hotplug.rst
>   F:	Documentation/core-api/memory-hotplug.rst
>   F:	drivers/base/memory.c
>   F:	include/linux/memory_hotplug.h
> +F:	include/linux/memremap.h
> +F:	mm/memremap.c
>   F:	mm/memory_hotplug.c
>   F:	tools/testing/selftests/memory-hotplug/
>   
> @@ -15747,7 +15749,6 @@ F:	include/linux/memory_hotplug.h
 >   F:	include/linux/memory-tiers.h>   F:	include/linux/mempolicy.h
>   F:	include/linux/mempool.h
> -F:	include/linux/memremap.h
>   F:	include/linux/mmzone.h
>   F:	include/linux/mmu_notifier.h
>   F:	include/linux/pagewalk.h

As discussed, alternatively some ZONE_DEVICE stuff.

But memory hotplug is fine with me as well

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


