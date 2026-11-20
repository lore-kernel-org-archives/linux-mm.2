Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E07B606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GAQiBYx6
Received: by kanga.kvack.org (Postfix)
	id 19C906B05B7; Fri, 20 Nov 2026 01:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14DB66B05B8; Fri, 20 Nov 2026 01:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015F46B05B9; Fri, 20 Nov 2026 01:53:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3DAB6B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:53:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EAD140D25
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:53:18 +0000 (UTC)
X-FDA: 85454580876.18.9C8BEF4
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5106620007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:53:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GAQiBYx6;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795157596;
	b=RL1KDkAzthJhs5DP3nrv2b7xt0gDcbCVhD/cyFwlmbLjYUohTD4PzZin9xqAdWkogP9z4C
	K5GC0UogsmyGIanunA9JvAiMt3zVqH3578CstGYRURX+oqiFBFwyqXa11p1VHyLdLRQaob
	j+NSnyBQG4cY6qNFXWjGUKYstm1WZHw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795157596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
	b=U0yzpuucurq1200dVrayo4WSaF3tyFuFcK4TeJsaoYNmCYVpY0K8rYK0/Vm8Hkr4TTkuM+
	XIRjc0tw8Q7YvapueuwgiquTHvohit0Azsr6hnWzckt1uid1mL1GF1G2yRUsDdZ2D3T3AL
	nWxXPzXx/Cui/zclJSI+/y8mVSK2HWI=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GAQiBYx6;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so4120055e9.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:53:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157595; cv=none;
        d=google.com; s=arc-20260327;
        b=mWrGNFnfipIb5/Wgbb4nWClUBoxHmI2HHdmgdaWx6WLAstUSMctL42KG+iD0Ispf+z
         JZf6fxY2tVJR5kF6mKr7pJ7jOlzENWzv5uOQ4auy5aMD7AjMQYwQfvDByaIoUM+0Iss/
         Yb5xqrz+UDA1dPUV7jBFV/GidsTkOlankRyQ9exNs02x8ndaf4CjOgOrVDnEZSnzyWcT
         cHaWkvBMTS9tKOwQQI7ZCfb3yzm90YM8EQ7rRcQ98WPRlC8LYm5rjzSAX/Hq2WzNFeXy
         eRFH+6y5QK1W6yU5Ga0DAzRLJK7qsj7KR0NstRXRlD97iy+YaI6Yn1FWR9Mj1qT0tBel
         W9kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=V8VLnzkuOj2uRqeo7+yZPl8UqRTjkS1jCqJ1y3/gxYoPoVBJxdtoW8QWis4pdYcW3k
         eJfAJd7EqREC7TrdkxETw7OfJI722w8s5rIG7zIV0E7QHDD3lgKu2t2kyyhGwIMZdY7V
         J228L9PwVVjNx2z3Cbvbu7tjQZDd/Qi40tG6llzGqBLUBjZLeZCoP+XQ/Uu0oYkjlZ4a
         pIOPFegFcv01xwOovwuDFavi1m91vKL/UeIaHo8sBUYfovkguuX4G3/4XnS8jygw9xUq
         8qTkoxzYXm9J/S8z5nE1xXHjviX8ULhXn68ExA81kyik3nNuMHBM0rvJSXwtW9xlazaq
         LGNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157595; x=1795762395; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
        b=GAQiBYx62rtDF8LmLvLR/JwZDkA0CbjaSw3viweFI8ECd3XCSsNgsEOB2lFS1dln7a
         7AaIpPz6+hHSNQWrGBRhIhw5Z2JbItM6dxyzas2yznZxu4e9vigQ8sdLCGLUqWPipomL
         d0u4U+K+u/2V/0Eq7Ha4bvyTZsQJqfJFvGMVrQdYbJP6G97C7WVaUCc4JQXxA/KGSH5x
         I0GS3xw7rglxAIKEz/N8xd40UWG7nZi1CtRD+arzBFKxOY1ooQy/YAlaeMduWgHWLn0v
         /wfb+/EWCq3K5ft1cEoUVd3x82sweyFGb9JdAKPEDwgIeb829vmHXrAQ+f7u4XHMTp+8
         gQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157595; x=1795762395;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
        b=D1CWw71DnoJQ+OrMzR+ZGwv/SL1sDYZ24irgtwAlhp5KaUjKSa5TYPne/pFjJWvbQ4
         Jqgx2WD4JNlJVnZiY37LbBtL8ShyNGUWIhf0VXbqOAEnPtM/L3ov2nyHM7XxalI2a57r
         Tadzw6e+XdIzmUGRrqbUSZNUh0fwt2es8FUap/FpLTD3TByexqbl/wugfrOrqjND4MRR
         E7rdoL9HgLTsPp8lPWW7L3TQVOGuAvyi31W/hDi3jQf4sfJu1vHyN5MLqgce7gWKxg3d
         /GXFLbpJvmI6TvLXXcsk1sd02mv7m4JMrMjq1zwk3pSd/hgow8lm+FX0Vk2d53Bao3hX
         7V9Q==
X-Gm-Message-State: APuU4Z9lvs5DwxqSEZhBozZuq/YUr0CbTEs+oI7/kyS2+VPpK/SWz9GD
	QQk5hPrImdi9/WXMTz5o1sJ80wrTKfl9CiWYO2t7SWZ9zgFtUfaS2BnRDQfmxi6QpcFnsLehczY
	nx3Cjoe+l/FK8RqF5ZMtDgRpASSFAX+4=
X-Gm-Gg: AYBFou0pc6cViLO2Fe2ByPij7rEb5276WjX0xt3EFT6twKw69mJOBx+ZnmKXDDI9CBF
	bsBrwmn+1EpTY/7oLFk3lzH1UwKWyId169/hiWykeO7tOOSUhltbSNnsZ5B6Ui7Jvp/QgAgil3e
	tckveHprhict1XRCYYqt8lOeoxjU+MdO9klLA5STb+NIyv3QfuyHj7RuIRtO49sU/6h14/f4fOK
	k1MCnhnFsV7iYGO3xJBlE5RoA4hOFFIQk3EQeWoEy1aUwCBXKxJ0ynz0MJBCYpGZu54rFqWfDDX
	Ya5VgtZJotsAsBh1S50hiePZE51jZg8esZFuoBGZ+m+HnQi1Xj9+LoQEp5YOogguJCE30WVe5Du
	2VpKCV+bItWJAC7gtmNO+b8FBXQgo2e/CFYp33TLm8eRbpHFSNTt8BMPMjVOWB7VQVw==
X-Received: by 2002:a05:600c:4f0d:b0:4bb:5c97:f4b1 with SMTP id
 5b1f17b1804b1-4bb8881941bmr45328225e9.24.1795157594548; Thu, 19 Nov 2026
 22:53:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-5-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-5-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:53:02 +0800
X-Gm-Features: AclHuK-UAZOlULyacCKbVJRgcNRnp6P5R-TwcyKCwuErXy_grzV4Q1tvMgKauLc
Message-ID: <CAN_Opa8b0Uh9WQ85HkZJPm6UuqW+eSqtdP_UWW76naupt3HNmg@mail.gmail.com>
Subject: Re: [PATCH v5 05/17] mm/mglru: skip the flags cmpxchg when nothing changes
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5106620007
X-Stat-Signature: eodn5r9b4t3d6gdjwaqn6jp71fb1zqir
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795157596-897712
X-HE-Meta: U2FsdGVkX1/2/VSxip4Uj8UYYCquvHSK/IkRf8WdGCOhViCgVsa21EioclJLpSEv5VR8aAwDi80imTVsIK383sV+kvKtf80IV+1a1eQjPs59115PRf4S5fVGEtgbIBRGdv5pTBCW+/7QegCvD2PvuYMTAg2vMCaq+OngiquQtb+eLOWvOspQO8L5oQZ9ieCW7fEQQyHuswd4IfHphvI7TdoCS9+ux/ugXOGWUSoQCK7Ub8Y4HKPq+AvtwzJC21+xWzdovU0z3e932XX+X0c3lWloKVIk1tZ+OIMV0kXWE3M1pTG6w3WlxiEBjWUvT6/E/bzOlNfcy7e2xDHDdHETJCKuVdAmDeYUzjP3mpk2di19sbsEcvANJ8YDdIZ6fvqR7v2zwRoE+8U2rf49ZHxk+68V8L9DkqAd/BiCrqds4da6LOrg5TXoysDHEE60B3jEIX7bMIwAGeUaavz5ZgkLaZSxj9Fl32ev5XLZ1Va/K8oqTbizlYctoOAIUtPjiB7MXHP0tRiBqjYYjv1XN9RVckgvSIzK/JKcHUXrevT+JeJXwV5kv+Fyi8lVxajSOTGMMfUhOauEJm3Pd3pM6chKEHUSmEyX4doHRlIFwYfN8aIHPBvIv/YEYa5COCi4fHNpk06hROxByVPuDxqgxdEbtS541uMYHi/mWjTfXgfu2UyvpiUG+7khVX/FKaT5IFzX9jcEMEMAicvBXHKTPF9Puu7/B9RkrpA72FnNNs0CVHHePxGtZTuY/kqhucUpsVe4QQoDkyCQxwf5y7nqWbTvrSEQhDRXiSfl+8V00/lNNpxLGRNvO4BWDI+W0NfdA2c2pEiAGbo3xnlkWLOJYIcbcxtBgWXNTTpyo+0uMwG+PE5fUESmQL0o914i5YmLL211TEERHcmhTzkYmU/WmPZkot7o5Ur5ihn5rSDIdSNszzPkWZzuSSi8jwTaKnK9QlE5rodxA7pYXe+faHIq0xw
 9KQFhmc2
 nPp+fnc9Q5FSk104bS3lDVlgXfpFeTXaj4lyIE5kbcSUhm6Y7dX1UgTl8nZJgQqVEpiBZBg3x/NI7Jh0tAqCK5X4Nvg9BoqNT8ejqB0v/6JPHqq2GOkYEQ0CSektkBvS51w1XbIc8aqroK7B6Oq+2U+wfsWOmEuceGPtYnPY6zYjo/96TO2Mf6t5bHpLR3JqULy4ziVwWUv5v5hBlOgDX/cecrBdII5Qw9Qv7s3qpQ79Fm6kngxPpuN62r90d/GUj5eG7RbPLkcinELpEaLpGlStI1nkMZN1SHfVomMwj8zgXE30b6zFFsBxl0eIXOwrCY1kB29tNwZGR+6dfZkKc/fSNh/BcU+tjAy1tGHgek7C3C3Ixya0qMpL9FtRTFGQpHEgLObg5x1LXlBGc78LyDz+YaSe9VwsPa4xZ5kCWA0WtGWIOdhGKlH8tZCASXbDZ7IQe2xxXTc8rgPnw80SMMYedPeFNCt8NtFG6HhFfZnzYD9b2J4wbA4CGJcBg+UcIHv1Aivk1vINWu9fI0eNmBWAjUzpFxM+TRJ06yELUSc3ux5NJ7c3dE5lzswKc3lMEGNjmzrKqzlwlHopqyIZfMMn1/ksu/3gAJ13Y2ZZs1kDg0mmi5upqjJK1db/q6kGkBEqOzt9EZ1nCGpAusA/oQG4Kdd1B9a4nhGncjjSdn5Hpe9qDOXY/NaIrc/LCJQazGm21o4GE7O7NzrFg7fjTVbmlE1Gw0DjCtNC7VUvwJg6sx/8zPvyLYmsxwhGJSADnDxrzqKbr6teoA422J+9/7QoQO/Ujc90sjHW2
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
> From: Ridong Chen <chenridong@xiaomi.com>
>
> folio_update_gen() and folio_set_lru_refs() always end with a
> try_cmpxchg() on folio->flags, even when the new value equals the old
> one. The locked instruction still takes the struct page cacheline in
> exclusive state.
>
> That is common in practice: a folio mapped by many processes is visited
> once per mm during a page table walk, and after the first visit it is
> already in the youngest generation with refs cleared and PG_workingset
> set. isolate_folio() and the eviction paths also call
> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>
> Break out of the loop when the flags would not change. The update is
> complete at the point of that read: the flags already hold the target
> value, and a concurrent change to them is ordered after it. When the
> cmpxchg would have succeeded, the value written is the same, so no new
> state becomes reachable.
>
> What the patch drops is the retry. A retry re-reads the flags and
> recomputes new_flags from the newer value, so it overwrites a concurrent
> update with what this CPU wanted. For folio_update_gen(), a walker that
> read an older max_seq can lose the cmpxchg against a promotion done by
> another CPU, and then write its older generation back on the retry.
> folio_set_lru_refs() can likewise clear a refs increment that raced with
> it. Breaking out keeps the newer state.
>
> No caller relies on the full barrier that the locked instruction
> implied on the skipped path: the eviction and isolation callers run
> under the LRU lock, and the others (page table walks,
> folio_mark_accessed(), lru_gen_clear_refs()) only care about the
> resulting flags value, which is already in place. Note that
> lru_gen_inc_refs() already returns without any atomic when refs is at
> LRU_REFS_MAX and the folio is in the workingset.
>
> Tested on an i7-13700HX with turbo disabled and the performance
> governor. N processes map the same 2GiB tmpfs file (huge=3Dnever) and
> read every page, then one aging pass is triggered on their memcg
> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
> over 2 boots of each kernel:
>
>   processes    base   patched
>           1    32.9      31.7   -3.5%
>           8   195.1     160.2  -17.9%
>          32   755.8     592.2  -21.7%
>          64  1597.2    1260.6  -21.1%
>
> With one process, every visit changes the generation, so there is
> nothing to skip. Before the patch, perf annotate attributes 53-58% of
> the walk_update_folio() samples to the lock cmpxchg in the inlined
> folio_update_gen() in this test.
>
> [kasong: folio_update_gen() is replaced by folio_inc_lru_refs_walk()
> later in the series, which keeps the same early exit.]
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 2 ++
>  mm/vmscan.c               | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 46beded51c7d..2571b3f01226 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -233,6 +233,8 @@ static inline void folio_set_lru_refs(struct folio *f=
olio, unsigned int refs)
>         do {
>                 new_flags =3D old_flags;
>                 lru_set_refs_flags(&new_flags, refs);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8d14831cdf83..0f24b6ebc1eb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3274,6 +3274,8 @@ static int folio_update_gen(struct folio *folio, in=
t new_gen, int *type,
>                 lru_set_gen_flags(&new_flags, new_gen);
>                 lru_set_refs_flags(&new_flags, 0);
>                 new_flags |=3D BIT(PG_workingset);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
>         *type =3D folio_flags_is_file_lru(&old_flags);
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

