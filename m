Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3649D606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zECH4JIA
Received: by kanga.kvack.org (Postfix)
	id 3DD3D6B05DF; Fri, 20 Nov 2026 03:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B51E6B05E1; Fri, 20 Nov 2026 03:29:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB5B6B05E2; Fri, 20 Nov 2026 03:29:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E74386B05DF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:29:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CA7CC0C4D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:22:04 +0000 (UTC)
X-FDA: 85454804568.20.D083B7E
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 87F5E20002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:22:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zECH4JIA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795162922;
	b=Me5BT/5bLH7SiXLmvBgFVp4qRKjrb6f1WsIxfYSt48khBlUZNWjdY5qaOhsdm0wxIt4md2
	u6zJe5XQzGSpZGVC6kweov74gDBvJ3e/qE6QkFV/547n9k4oOG4pp1SsvN9JkX5LiN/dAF
	mIlTh/rzOtZK1zceOzNB9zBoR3YkCnU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
	b=yAvjtPwpjGDb/Hsouc+r6YWbzrzef8uE9jpjJo04YVyHUcX97hA1G1mu5WEoNZVP4bOY0K
	Nh0uFkgHlHEuYyNp/64ELAF9kz9akxPrI51i7LDkZF+InrfeY4mT4OxCfkFE1qbeMgsN/R
	70NG/zQJSTl2YMWP7EGNOvHnq9Pr0qI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zECH4JIA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b887ca9f5cso892200a12.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:22:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162921; cv=none;
        d=google.com; s=arc-20260327;
        b=dmFCEv7l0RGMFgmZaOVHr8gVxVn1ZHkMse3Ijcxf4NQNrwkp8rbsqC/r4dCcc9aIfR
         X7zBxcvYf8hJra3oyqEZh+fNxMmWXAbL7sROlA6a7Ie6MwXOkmxeHDwk1mNY/T1FxFhq
         TMD0kpmJdTC74PLbcv3NbExsG3mDN9Q/CqLA4w3XGJYSw+/ZSnN1vEn+vx9ChSiuJVKM
         fpNzEXVKzet7sEcxz4NevzV9KBFtqcPhHz1g3Rrhb7Bul+s8N3xtpJqC8LgNJ3bHjwYL
         GKWDo4iHjgp9pq6ohPD04NUGADITptC+Abrk6692LwR8oOvsW9afJBljTXrixaguiMNu
         ka5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=N218zts/Q/eid4LEXK+F7zzh1Uy48GD7U/Rc0w8wtTnPQpLHn0qbOOTFlxCvzTRuIA
         bTV4pW/NIzM6asanDZsVy8XWf67B5rqJDuB/KSoCRadRGiF+gWnCRxW37P6r+8VlDRV8
         o1V8OXwEqgRyQMYm2DJkb9pyqIEeoTCYl38YQ+GQHNldhMiJ84pVeDf1MyS59TYDBcpm
         VHH8GbqW0bRQpKaFmjs9N/nqft+rrpBuMnvv7LEMdgCOg4743DruHi2WAqVb2EfoAAIf
         rV3AqWbLzG/soKMXwdy+JehoPKnUvnExK86Dg8ruKSLf8ptJE+vMmd0fMMBbl+0G6ERL
         ouMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162921; x=1795767721; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
        b=zECH4JIAMnFvAfwkSOLUxzAY2YdJGzpVKjZtAwX8kduKv6QBFCNSatpDh7jgMBPhEc
         D61EWFFIdIiwDjmMjm/A1k7OCIE3DYQTib5oG6lPBM8f8e0iqxUNjlvV0rrOOmg/TGgH
         AzcOu4xnDUEsyXsBPMaA5hmMe+knwNHWnatGHcekN8RzNx5rTE8WVlw0qQlNOvKTsYO0
         X8/EuRdavWvJOOttgyclu4eG5dCFdMyQxEC/ByeHezeT+26mzreTrjRTSIvgXHewOXOj
         gQXN5x1wcr46UhUxerb7NCgHAC168Ut34zMELWkC/2TosSlBAnTAj7bO7mpevJOrMTIQ
         YTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162921; x=1795767721;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
        b=mTernmv6+OgAlMJB2/emOXgBrjNiAIIx0rUy4+Yadru3EhNViQbowOf9SUFltoqKTz
         TyHF2+trJH29I3oWatyQtI0QJb+gUxAVINZ/jL825V8OqF1TNPa1Knn81p8NVkeE1YO3
         IJjjx1TAV3TvJ0oeSc1UJR92j9Oyo0Sh4bcoc2qX+IinbkbjdBvr8HpVDRVNQj6xszO6
         IlMurMc1NBwTlUeAl6oBjXrgY4E89TtEpbz00zjJggFLGYoaz+dQXZ7dsXD5EPKVxR8h
         Tvrr4HS42ZFx7gXmwTjBpm3oDvZ1KBCvuG7gUsExUgHYSWlPp4DjIY2GGIW3S2kKIkTV
         gs3w==
X-Gm-Message-State: APuU4Z+vzm1ebRlZu9y4a+WrCNTzcbBIggvPsu1HpGiMz/A+end+l2hS
	pLzMLrbYKdeLHZj+8k5PRYpk7QvL8li42UB+qe2fj7ulhTwyueEOMybG/+Rp+BCF1xglblWxTrQ
	8Vj1kjUs2UI1n6vP/5kh2jmPAyT5etdU=
X-Gm-Gg: AZFdTZdHlxRsWGfkKrbdl6jUdxGcvxZEd+Xu1VVp1yIy8UwBF8rffDMM9mQ9lNDexIj
	+QbdZdYy1J/Wx+MUkRD1XoeFffFiDnyfAOis1efSR6L90Me1NrEA/tZ8YqryKCBHjCuSDNqumCo
	8eoGf8SOywTRh8DyVSCmETvhoecsD8hQd3e1tX4klCbqw4OFd1eZ1YopdepEov8B//zobwew/Wb
	Y/dtdKJm/mNtDvIzp8T4Bkwus2zU5w5v/pdevWFrGCEqGfdWHrtsTn9IvS1hNWPAx5f0xhPQ06u
	RRK6pAUKFFOXtUxhUF9im1tL+VRRM7LGnitzRTvfFbORuNfypUeumlYfWocy+qp4GMyDGzWhTPM
	Tvykejg17TPGNf/DmzKn0wgIbuPTgbvH2c5JigBXlA+QXRE29M1AnBWlGFMkSsBc=
X-Received: by 2002:a05:6402:2105:b0:6ba:3738:aa76 with SMTP id
 4fb4d7f45d1cf-6ba37ec713emr1520051a12.28.1795162920798; Fri, 20 Nov 2026
 00:22:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-12-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-12-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:21:48 +0800
X-Gm-Features: Aa3M54oR841ct7toroFKb5-FMop-YAlKT3qgtmdkpn6S2_l60VC8mi_ZrcEbsCc
Message-ID: <CAN_Opa8SFEzeu93GpJY7OkOUP5AeB3P9_8MGuhi6JJnBQsA4Vw@mail.gmail.com>
Subject: Re: [PATCH v5 12/17] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 87F5E20002
X-Stat-Signature: 3n79xobdoy1cf6s5k98c8usqczfouxg1
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795162922-370820
X-HE-Meta: U2FsdGVkX1+LFYEvymZyAgByaRvOmffrXRL8lymnanjxHqAgIJzDqIgTTeCVzrHw9b/wMW6leUuEiyAmi21e5iIADDpvd+sN60v8Gvxd5IBriYwOQjPS+OLWo2QkbyFDuyDkpCa66v1nqKfXqYRZd22u5X3xF0SFMtUMFiBtI3J1V94757LhZbFc9xIE5ez8WufbWSgdyI+A4JtLtx8pHiaMPrfZz8mwPgS9ND8yPOUXQ2HQt83dBKl84UrIu+iw1XloIotNf7+mlz+lzH+AjKdY2ur01Dz/AIPNm192TWBOj0AibrlQhBBq/ISMwRTImymQtHTDuC1/iomE7BSsa8Hy70RdWcxtkbteqsz8Oye0XcAUstWnYDIaQXNLwpO3cHZFxB0N3Nn4do83hvQbILjYCf/E02bfLlb8ol9f8AHW0ifKs92fEFzhQU36NQaT9dAo/9f3HoGr7y8UaJ56fFGcD4jL3r8QH+sLwe0x8bto39IEn8Kxmq65wJejDeyuAxp5VyfsfG6aN+RJo6rJjTtUii+s3pxT21AwBjA32Ci+Ce8vp8Sq8a4LtUkRnfqDsVKw48oUWoABiGQb7ARTDqj9UVpLNCYLuP5EsziOcnjeTEy3H2zJIQddZ5sVJBAY73wmVCiD99jgzr2e8Z/kKtYbFF1twMzTGV/F9E3VrJrl99k8Dcle8D3T1ogWd5r9USgDZRe3pDv4kLigaeETmqZb+Y+zEv3BnMrYLjSjW8PTB0mmky0Ti7URsJl9AtvtU460o6A52bXbu3zJoX+UcG/OStMyUu0yTpEjYmDcl9Y3/nqdojqz9cCtTBWrzz17SLMSIpQVoYN//ae/OsR0fj+Hm0qe7H7I6jVV8AA1RE4H2rlo29ogAg3TJtRhQ7als+aUwOBmyirADZiqtc2ZwamNnbShUtc+Fau4Yl1OP8LO43o0K1/tDdGvHdlBR+uroWJnI+sgBQOnVyQpYiw
 qqW04tmx
 Db9OB8r2WshVzuSbWeKZ8OTFtRaniBGaQ1NlaeLYy6sHzRfhj/lzAxgU12bD2CqBnG7OuKphxIDXKxUa4v1GIRHQ92ndp2FLMl271WTWEzwzpkBvKkABTH3oDpdtknCnf4Q4mdCXDDt8EgDOvoCr2J8BRIMcIDhtve/BqQz+l3JEyr4JB8RG87+VG7VbyDAbIglqPliX/ZK93sSFMtrzGqfkPDiG3GlB1KuhDrrI2tDLWnAnl8BLRUQMw3yQzJdvyhHFMrDFksh/zndDzAkCAhWZlZmR43W7yMeKx6oD2YDWKPlrwrjmC/bqVKVJZnEFfZ2cOlcgOhOZKQVxaQWxUm6ogBhI1S0dcBWWXMXDIl2w2dRM1kXs7N3z495x6AkSNLCL3YqDe/vEf7huV3DMEHBxodbUODv9CeQ1NowvBfM+ddWRFXUZqt5j7t8v1P2laKIKhXPUlIGNzn7twsDA+cWzLTc49j20gMcMyXZMPn+9/Do5jDG9Zp4NwOa8DQmMTBexM5TyAzho4CH8q9mnPO06fMnNpzeC9Jnpmz6tLtU5WyS5YmkDZL6BCE7BdJshsKgxbzDgAEZnakeohA8QBo2kdJhF0liymuD4x1vTi+qpTRkyqjF+fJuE+r0n4Eps2GZgdS6Bber+H2sWHcAV+A+un4rwrm3Fbu/byVky21Au9VI02r5VsjKhkoaVufAKRtwbdhmawcpr36cegjSpyqAEft32fKwbYhVOGqagD8FpzdKwMcuiH8HISyKAit/kBvYE+3F/KrwZ4j+OUm/HAAWNbxFTofzitn1Hton4nbg+YDJOVsKa0/fG2+2oQgKjC8FhG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> count, so folios with nonzero even refs no longer have the bit set.
> folio_pte_referenced() testing the raw bit misses hot folios at
> refs 2, 4 or 6, under-counting the referenced folios of a candidate range
> and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
>
> Test the refs count directly when MGLRU is enabled, mirroring the
> smaps conversion.  The classical LRU keeps the plain bit test.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4bbe319ef86f..68f7a30e36be 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
>                 struct vm_area_struct *vma, unsigned long addr, pte_t pte=
val)
>  {
>         /* The folio was referenced previously ... */
> -       if (folio_test_young(folio) || folio_test_referenced(folio))
> +       if (folio_test_young(folio))
> +               return true;
> +       if (folio_check_lru_refs(folio))
>                 return true;
>         /* ... or the PTE mapping was recently used */
>         return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, a=
ddr);
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

