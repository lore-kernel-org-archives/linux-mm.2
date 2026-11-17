Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE83606A881
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Wl8pSi2k
Received: by kanga.kvack.org (Postfix)
	id 905266B05B4; Tue, 17 Nov 2026 04:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCEB6B05B5; Tue, 17 Nov 2026 04:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3296B05B7; Tue, 17 Nov 2026 04:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53FD76B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:28:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7E7040330
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:28:44 +0000 (UTC)
X-FDA: 85444086168.20.511FC9D
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id EB3AC140007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:28:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Wl8pSi2k;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907723;
	b=oe4+XWHo0VVmJccv2h5LLcoWS7MX6QEkUbhp4KhKqAeroiEFQ1tHe6s6JdVNdfTk4QezE5
	ENaiGqBu89x3O5Y150rLgxySBQIJQdWVdRe0AcJ/hnNZ3LOZIo5Ro9IvmSeIyxbNgWvMRo
	UPpwD+kJlONOgguNwSHj2BByQLgRkes=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Wl8pSi2k;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoGYMt/eqdLbvqjmNO1up+ep+6dHW804fLUV0KHhNO4=;
	b=KY8jbYCpmXHIzHbelA22nT1SqHrlki6nQoP2y9RRGpnqfLBkCTxY7Mg0PqGpl8TjHBso1c
	eguInsCD57NOgkZkrhWgr/XqhfTNHEQCyUDApw+6WwUYXmNwbqu1x0fCvstA+HOGG14q98
	fOuBlgDKA1/DS+/8kVJUBbsquXqApX4=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-94965745d92so284988285a.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794907722; x=1795512522; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QoGYMt/eqdLbvqjmNO1up+ep+6dHW804fLUV0KHhNO4=;
        b=Wl8pSi2k60WTUMjsA2qZvWFiAKh6FVIPES4kzJTjzk+1/uzhaxwN6XwNp0dzSRqsLN
         lzMLvMeTv5c/tyvDJgVSrks8OwcjrF/6gRLxMEyd7Y1/cttvflWL8Aawsy63glRUlixh
         YOMk9YCcU/YixSOU4lJwzopLgeZdWru1OOUEXzy1JEBrHvssDPfOsxJTn/2X2Qfir9qA
         rwBcfbXBhBKbG/Nn8hmaW9Ej1MvgS9/BZQiEjCrXBgZT1oedrtWxKugUARel9vAUADI0
         s28ktmVGQ2EEpmPNX1ue2ZeVsddY8vFr9FdFaI2Jl/z53KkGWIk+jLHuBg30qtNgnRua
         dhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794907722; x=1795512522;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QoGYMt/eqdLbvqjmNO1up+ep+6dHW804fLUV0KHhNO4=;
        b=R5gtKVOpYMVzzYRIIthtW6G8BbXtRe2sM3zxI9lRshdFNMUaIJ/Lm+1VVU6P3mJDtL
         la4BRUWKmNd6QKaaHXAcojIV7s6JGIqHsbnjCK5sJwkwdEtsxHTSsn7lASHqv6rPcb+i
         B3ot0zc2m3j20O/D4eF5vjR7TRlKjLv/w6W0wuhCVcz8Fwz8XDCtps1kLu6CpKiJy2pW
         up0URqsUohQC7hDkX2fI4HyfrYwvqAy0Zj1hkmXVRNHe6SuBKb0xYI8NKShgrSBGZnDu
         q6rq9pZAwpvqpakxEbH41zBsTQ7E5xVov5ixf5nws/aIOQeFFAD4ba6wjpds9DBg05nY
         GnaA==
X-Forwarded-Encrypted: i=1; AL+hErEiXkI4ZPhPNqAhFMJ8dGxtinHEOeKqmWzPkAmCYHmCAHLPdkyKxFclm+of80PScoc4VYDsNPP/xw==@kvack.org
X-Gm-Message-State: APuU4Z8/ty/cDDFmJkj9wXfwT+dXAnO/fmZo1JL74kHO5NtJPVSlp+ll
	2AlSb+Eb7HMat2CfAZyszawo1zSx/k9Fe+l8LFxZgYzk3HKhh9mJ0B7B8vI9zkvBVOU=
X-Gm-Gg: AYBFou2hLSV/ahuujlsWMOoRPjlWr7KoGzqTqzf4z7R7IiPBrLfJ6NIMD15YoFa2/ys
	piJPAfD0gs7kg5q7PwqeQGmeylLM2T/RfnQfp9aKOUpCUwVBtrRagwB6q7JgMJWyND9QNpTWTgS
	kRvJhMbIXoK3mAOTsmQaa4WaMTlQIRrwAe6UNxA64pxhxLupiTLPLmWeT8U2/ZdDxfUKM8TiKLx
	ZTJlnzz0j2ZPyUyKhGFuoM4zNyUj/CjElsMnxKPcDv+ywq50KLSbr14tYiEY0ffs0bHgl8oEqUi
	DrCb0kYxIEb4dn2EfHEjDLLSzS1IV8lyIIhb9dQwsnfWgc7saiNHlFQJkg2oesE/56ckXVun67M
	MPzjzRHgaV5CjxXN7/uzIqSgTVoEGsHTd3Mlba0ATty7Ti5nIyGQpq1aaxTfIR7dUvH7KwDk6Pc
	KcDRiffOACVRxQifuGWY5tfspQOL4IGLkfDxBJvaJtEeAA9VH0CAqzO+XZV3y/Xum9vgXLRdtWX
	FStDPd+djvbszJz0ohIuSxihLurEqk8b1QOfM2m1BnYksq1V1k1qSH1Ihw8BghDX1PQRSd5mPNA
	o79C0lcgTqHE0fXkIJ/RGtLZV93E2/O2VzVPanFXHG1nnKOE2gSXwkvpteh70ac9sf+NKV9aDi9
	SkOdfUMM=
X-Received: by 2002:a05:620a:1a12:b0:947:a247:6afb with SMTP id af79cd13be357-9494bb96cd0mr2258109085a.13.1794907722161;
        Tue, 17 Nov 2026 01:28:42 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c439ea1sm1046418085a.0.2026.11.17.01.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:28:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] mm/page_alloc: drop unused gfp_mask from
 zone_watermark_fast()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261116232346.788145-2-joshua.hahnjy@gmail.com>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-2-joshua.hahnjy@gmail.com>
Date: Tue, 17 Nov 2026 04:28:40 -0500
Message-Id: <179490772096.482102.9464218168628829649.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB3AC140007
X-Stat-Signature: ujtqpdzdcptssfdmshcdxdpkbwzkhdm9
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794907722-361177
X-HE-Meta: U2FsdGVkX19D9qFsz94tD++TWTDD114n01MatP6NWwPBSOx3bjDybLY6vj92prVdEkgwXJCJf+Dnu81wDVN2IHA8PttH5y3YVqBP1vmHOeHndFo71FroXCh+N6EsUmX6bFZxGq9sPJ+4Z/l1VJRu4Qrla5AcG09Rj3RsePOmNIWjWB1RBGPSH6H7pTMR12ypHkbzgT6BYy2foYs3ygtF3VE6L+M2SRSF76VV5HUMHR9HXxGhTwVqsHo/V0EY9SHu9b++9WDuQehiveeZlRYZH8Q//Dr38YM1Om61g0S5nkgZC5AYOt2ZzPHJXDQHcnuZls6v+sEF0ELrFrYuwFGRmfMquAf09+eBmj9eaz5u911w5Kh9IwQZXqgvCBuhq1TGdvpzwSNCi0267hKlBKZg5df7Yoc4PCKmsYA22AEo7vuG2FJqesfNqulvmppxx6ksDnQb5tsmvy42JVW01SimtCz3sybJvQTu9VSnTPigIvavq9PEzHsBpgrm5R6LsTvcfyuy22yReLzpeQW055Ft4VVufH7m5kUYq1C4FxPpGwQUJZZT4++r/oTnpCeUchSa8jG+hEOGzILo6+3xjZQgm2bCb0rTne7t+EnzTG0kcgyYdPUBVm3NYoy0VbNETxWcZ0FXf1FA377kZLjKRk5nEykN3wifdFEHK1PxbBSPvu7Qu4Bd73kmLQrE9r3rLa12s95wy6EeO6PXdz6qStWv6UWI3zqk2TQChIaSs/OXZymp3U30znoa5mof0c9/r69vLFcIgXmaakbR43ys7E44Y/DR6tCbtKri4ye1M0eSXgK2cMD5E1LWUuSUw6icRNLlqZIq3zTzp28F4qm+eLq5cQlFvdmzLpKtCHiCC900hzMdPAUvFiTnViX8KLk68w9TIkHKlZBrmwTYImwb6jvm9XLsunbksInjr0YmwlM5ptlrwvBSR3RA6Usl4mkWg6lRUf5bl8VeRHI+/S/zg8A
 CLdZnZpS
 i2zbneu/ZLmxzc8xsZ+ACVeKYdSr9jhQOcg7LACY6EWfr7l7asv387LDunS5f8fQ51+wlI5ppaVWCalQGlaetBJT1uoYbz+ox2trR8mOKxrlEbzKakrh00TuqdPXj0Na7v/2PJdAypp2bAf3vGc6P4AUveJfy0BexqenjTopWiEHyfscUTvJuK+20URm6ly5QIfE9AbNuJ/dqIgw9mnzW5/FUwrqoYb/jFoigmDzWQe95jUmxAnd12zliBWYNrIZXo44tk7S0D6PpxvxPNCupSf+SiqmbK+EZHpW80MSVLArPApmRo771QFYtiDGYFpxpYKA+lxkSdWV/yB0Y0EOrNzKJdF/pJdFiN9+U0umrb7YL6sTUkjhFq26H0/+rDLY7RBBulLcpP2C32gINZ9LoU4h3ALizLJcKjiaBecj5663nXYXDIvprJdecrW70IKAMoo+pIHLM/Ti3cAviElFOpkZTNkt3z9R4jf3RQSWqnQUVu7wSFjR9FXTmPTYMYqdjhjF6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 15:23 -0800, Joshua Hahn wrote:
> zone_watermark_fast() has not used its gfp_mask argument since commit
> 2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
> check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.
> 
> Remove the argument, no functional changes intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


