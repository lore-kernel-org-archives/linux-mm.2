Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CE560A260A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SPb3+YnM
Received: by kanga.kvack.org (Postfix)
	id A15186B0607; Thu, 19 Nov 2026 06:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECF36B0617; Thu, 19 Nov 2026 06:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928B56B0622; Thu, 19 Nov 2026 06:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7052B6B0607
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:53:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BF62160A3F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:53:20 +0000 (UTC)
X-FDA: 85451708160.17.3D3AD01
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28BE0A0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:53:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SPb3+YnM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zq2XnZcvuiLxYIMYDQf8X6o1F233lSiAvUCdfDIIF8s=;
	b=u72tMHiZM02LPkJsjDEtCoZVj2rqsekfMsFls2qjswmwS9fJGDBCixuew3FOltnrV20kxj
	JhwguetOfHFt3Y4IPJSeDAfvuDQtDEea7P3qRf7Z+AqdhsTbe+hgsoRylb764bClBN/Sat
	JOlBmO03CCI6JwigxoeAKKxmRUbC33M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SPb3+YnM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089198;
	b=j/BzKX/rfRPsQ7AF6vMGe/tsP+svYZLpdTBq9HblGHBqMJJd/hIRBAY8whnMQ4St+0W6C/
	AWOuYNy/2NM/BL+U+F8dGkYmuycwR0aRMBqInFqlCYMRnepjJRuU4vC1EC2ebdIN3L0jQR
	gVx7q/SPjTp0mzDeFwmYyXvswCDAUwA=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso21557925e9.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795089197; x=1795693997; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zq2XnZcvuiLxYIMYDQf8X6o1F233lSiAvUCdfDIIF8s=;
        b=SPb3+YnMfwZ6c5TT0mijoUXe1UmzVy1kPpeKSdwrskQxmuXCd/rhdv+f3QZ+2nbkpZ
         8rbygQ8IW2EAmrOmO91euY05FVzUo/8DCm4Ypf6JLlJMnFYRY22Fdi8WiGIKlSvgLrUr
         sclsYr/ud17JV3VPuRxuTeCu7sI5JumdhGKLe/apy4limJ5+NVCz3x0i9iVoARzm2wXT
         igJKZBM4Z8ge9VoBXIBiywpX0mupAnxZ5zOpP5V2ZekSaXp1SuylfrUf/bl9GAGwZ5Kr
         Ty3jQ8/fEpOgD07DrXTnIWxGmvivcG+T9rdrquEnSBwDwmmCKgVyrOYzpFIeiiv+p+sU
         X2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089197; x=1795693997;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zq2XnZcvuiLxYIMYDQf8X6o1F233lSiAvUCdfDIIF8s=;
        b=UMUh0euxQneIiuC2041Ob3BalwLy54ATiDzlDyD0nMm1O9mm3ghQKid+NiscTpIM/P
         ZPiGbn5hAGTILSdj4mJ8CyzJ1aNXeyUEoRVkmU/1uvQkVUATV9WP78fQuwvwXxHL29JM
         44BBHt4GBBVTsW6oAnfj253j9qfF2LKsAc4nDHakSWAOiu7GmzSHnnfqZzHNacgPvMRY
         2jgtDnqe8C0/X61FA8hR49vxh2MYBi9d99oCMkyKag8B93K1Yz/z4kiyO2tpgrEMe+BL
         quz74ejg7Ps80bWs+ON9vkPfXGZbPctrc3qUpt7T/nk3+VZmWN0cwBFfldty0n+TV+1r
         fhhg==
X-Forwarded-Encrypted: i=1; AL+hErEgWJkfYnW2AAPy4RZ+VxY9FH4+3kfbkmAehyr3cc0aFz88KGKc3JhxAKND4vybjfg8c9N1oYgBnQ==@kvack.org
X-Gm-Message-State: APuU4Z9VQtlvJAlTMjBiPoQ+8JGvRIweVwAZtBF67jflWXzUxMgVmoEj
	e6qunounRem7rntZFrXRfeWJ53Z5ONmGT/3KAhE+mCTBc/dCwpZeGrZQ
X-Gm-Gg: AYBFou1JF5r+tb6FWI5S/4u+atRLPw3robJp7rhjk6Yw2A89Twc/9hAm+9CTuajzEkN
	fzpvhHUeZgThbx4bFkconF+ldOEzU35t1v5Khtg23EnV5yn6pVFS7pqUC6c95OVWSLcHX6WAjVy
	atfsxj14rL9jqQw2lmX7N8B3R42nqyh7pkT50IvSTKMuO3NfB7zg+f9nn2c8xK5NGYxy8j4c2CR
	/jbgHU/MJdSMLfyMNjcYFu38MRTcZSyoON6aV21BCoa9ASffKV0I2I0P9kqPWptodpcMiEax2Eo
	2hxUtJALOS918C0k8iYZUaMQ72FxOug/xoEw39GwuPl7vGzB3qFZnkC8WpheKRp9i11TwqB3cqS
	YEw49ez0rTDXTOyHW8ltild8s/hKtcBmKcoiJ5AIXK/NANM8jUlRObEJ5p24CbDykYa9q5Fw5Ut
	W8rh3fOduTJyI6pFQj+tsjKikVvuu8vpf1E7sLcybUVFqtl1D8TmhbhWfHUOBGN8JtJpq5D8t44
	ApdzAP+K8b9HoG5Uqic1Nr5SoKd28Od2PzsUuMK1xRuVopfDKSKtJ4Da0bOiIaQ12ea2e+dqTaz
	GeQahO7Xn/P8DPwx2ToYpWnL
X-Received: by 2002:a05:600c:4ecf:b0:4b7:6942:39bd with SMTP id 5b1f17b1804b1-4bb7da395c1mr109315655e9.26.1795089196516;
        Thu, 19 Nov 2026 03:53:16 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65560b5f1sm10580575f8f.21.2026.11.19.03.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 03:53:16 -0800 (PST)
Message-ID: <32b06069-0cab-4e9d-8d6f-b0852711d336@gmail.com>
Date: Thu, 19 Nov 2026 12:53:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_owner: fix double decrement of stack count on
 unpoison
To: Nilay Vaish <nilayvaish@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Oscar Salvador <osalvador@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Marco Elver <elver@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261118212819.403059-1-nilayvaish@google.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261118212819.403059-1-nilayvaish@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y6nysyjhn5h4iujfi6xq1oq7u5eb9e9a
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28BE0A0004
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795089198-168432
X-HE-Meta: U2FsdGVkX1+4E9+uN4Lh1bcGnwx38t4ZbQIRO1YyPJ7Yrw5DdHtWXXCG9rTNPKkpJQPUNkipJdIZJXbsysJkBtsKhi6eDWrrk3xXQv64Qo+DoqMucluMJEblwIeBGrBmSAloOLvFx64ELVFO1AYwi1xmkCDMiLwFzJjxIOut3NzDzjpWVp8JV65gtZjb01JxmmTyPAJ6KX8HgiHZ3TpimLvWgfD3SpMfjGUPD86V9FHflrXmFYLwCsuebY+OmAKrO2Mxap5Egflj5y2M+W7easAE26dWnG8OSY389m7RaBjL25TZvB9wXBpS42ice0bUh8IQSvlTGiQRGM+EYsfTBaqmY5Teg1opuWKmH4do61MRHAgfY/SIrClYoe9nr0EATnRvjE+Waf4ejLswJrgFYng39I68cWIgGimftFGRbIhrVXXlI//8vbTVIteNlBvWIuJeWVvwZiUn1itHvci2Z7QouMY1KjpS4u3Hsk6gPmfKjxzaAKD3DsU+UOG9Azpx8Z67h/5CwszoCUgTQtX4D2G54C95S17XvC6+NxAHEMvH/bsYMNH8vYqiEAziuXexMx0F447lqyw3dAt4VHAykodpdu+HOxvAXhnzN5deSrGgDAyDaXm+IHR4H+8tePV4clfyQpX8lAD6pfFSa/rw+hPvTgNBlsJ+SqE20ihrLbcphEVXYEjhZlFnL46BA16hLf/fQmHXwZCNln9qmsmFdiQcN+hZVcZltbIHx2nRns9ZUg4TxLFuzSNwximwF1ehtYinRcX4qY16d5veMqkZwGh1mlLZLtzK9Mnn3D+yRtV88/2sNW0+7FaR1q9HWpWwbRC8qkOOjIWZ8tpcFXgSXIkdb7A2Fkt0HmQDZGQaTheXPAfoCyTXdxgWsS86+Ete7QlHv0pEv80Ux6EGDhwiCy7ZCl2GUe284ttMajCOl3N2d5lxF0tEn4YMlQacX9pD2m03VCygbnaXDesL3Xy
 R2aD3Ch0
 Q0hmOgBUcD8jSVkWBPpCA7kIg1A3+qg+1wzWS5QghbuOIkKU9EaT6KKoIeB7InM1I5uqvpYZYN8i/eKTs7+TihxpYgLxG1LRF2TBh+mG+YI/VBKRGgbWYd3xPyLYqeC7Ut911B0sO97uFgT3oJ/7N4punKVt0vdaziMihKrNxno4r0RYvY9Q+PflNzbK8aPcY+c8eSTnW68/S+CJv7MTaSBphC6APaG3QIe1ZXKkFwVEqk9CxfV7tWQguzPcVkF2bREmhmFGyyNEPcRBul2lyXia+4i+gL5VUPQPu3Q8CGTHyaLoduNm7EDdS9VXs5OS++AOguRp9b8BzFRol6dHSmSAb0keNpEmh/0kqyODN6uBCDizJ5+mL3jEkDgAC8Wa7ltw+bKCliSa3L/9VnmYuF9gqC8OL8DXPYaKKO6HXROhLJJ1iqAll05EuOFdNlzmUZUpr+xX5TZG1KroMAhFHx9JWK4DlrxS92ol5lBa8ohWwNfmEh17QyWzzvcxkxtKXShrgtx/4stEQkVf/77HjBlUjRzkTxEIJvUvNbjZYs8vgBMLAkCsDE6Rbujr9vP68ngsDo764ZmFapVrfOs2dFXUjchlO/rwbvnt4Ur/a82+9y99CrvdMpGYtfcaaFfe9lOgn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 10:28 PM, Nilay Vaish wrote:
> page_owner counts, for each allocation stack, how many pages allocated
> from that stack are still in use. The count is incremented when a page
> is allocated and decremented in __reset_page_owner() when it is freed.
> 
> A page that is hwpoisoned while in use and later unpoisoned passes
> through free_pages_prepare() twice:
> 
>   1. On poisoning, the last reference is dropped. free_pages_prepare()
>      calls reset_page_owner() but, because the page is PageHWPoison(),
>      keeps it off the free lists.
> 
>   2. On unpoisoning, unpoison_memory() drops the poison reference and
>      free_pages_prepare() calls reset_page_owner() again, this time
>      really freeing the page.
> 
> __reset_page_owner() decrements the stack count both times, although
> the page was allocated only once. The first call clears
> PAGE_EXT_OWNER_ALLOCATED, but the second call never checks it.
> 
> If this drives the count to zero while the stack is still in use,
> stackdepot treats the record as freed and warns on every later
> allocation or free that uses the same stack:
> 
>   dec_stack_record_count: refcount went to 0 for 92274844 handle
>   WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x5c/0x70
>   Call Trace:
>    __set_page_owner+0x110/0x290
>    get_page_from_freelist+0x1225/0x1440
>    __alloc_frozen_pages_noprof+0x1fc/0x1b00
>    __folio_alloc_noprof+0x12/0xa0
>    alloc_migration_target+0x81/0x1e0
>    migrate_pages_batch+0x1f2/0x14c0
>    migrate_pages+0x9c3/0xca0
>    soft_offline_page+0x189/0x570
> 
> A single soft offline followed by an unpoison is enough to trigger it,
> because the migration-target stack that the offlined page is accounted
> to usually has very few pages.
> 
> Fix it by decrementing the stack count only if PAGE_EXT_OWNER_ALLOCATED
> was still set, i.e. only the first time the page is freed.
> 
> To reproduce, boot with page_owner=on and CONFIG_HWPOISON_INJECT, soft
> offline anonymous pages with madvise(MADV_SOFT_OFFLINE), and unpoison
> each old PFN through debugfs hwpoison/unpoison-pfn. Without this patch
> the first cycle prints the message above and 2200 cycles produce 6597
> warnings. With it, the same run is clean and all stack counts return
> to their initial values.
> 
> Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

