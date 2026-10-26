Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AE4606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=U5RFi0qB
Received: by kanga.kvack.org (Postfix)
	id C98E56B05B0; Mon, 26 Oct 2026 14:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49186B05B1; Mon, 26 Oct 2026 14:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37F36B05B2; Mon, 26 Oct 2026 14:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82F6F6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:32:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEE271C4187
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:32:26 +0000 (UTC)
X-FDA: 85365622692.15.24B52E9
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id C524310000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:32:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U5RFi0qB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793039544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEX9+sqg9KeVky/NcPkirTK8PMNoKH+/ZsoFca1T+0s=;
	b=oi/RphfpYwE7rc/OH/r0HJ+acGGSAdaUstcDRpOmZFsXq+ONHSyrMBWW7kFHzV4sPOlJv/
	EaYYJB6TzlMft/bG370usXf6C+1DSSJ5JUf6DOJUEY1GfYNEzmCycm9p5mkPLc9tDTTiXy
	0Bw2Jy1rPE9EoTHAEDWB7rICO186LdM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U5RFi0qB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793039544;
	b=W5jgI0M8bf3wwxfbwDXI/dSbhpqDsN/a+0zcpUNpWWWaOwOjthPYrT6HF/WMkp1jGkoQFR
	cb86cTyv7FdtoRie7NuCRYTz2fYHmnj9D71C79cHSg9nfxTOfpnU1zuqAMi/HpTJqeLii1
	CGx18yHcMZhRqivGbjhluHk+MpQkZyA=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so28613515e9.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:32:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793039543; cv=none;
        d=google.com; s=arc-20260327;
        b=OglpVeFmqrpc4QnDII86mzm+QQoBjTgIg8YV/SGGjaISdov6OR4PuZ5AVeaMjhnHDz
         8AgLK4Jgcf3cDijxBJ4nIYcoHUu+G+0lBMDqAo0RM4c27CXlYBtIG39u6861BWPl9nSu
         j7ta+16ps5TdsA1NXviqqRTuXf8qcdxDqyck24ZfilXApYkYXSrIb5c9jvCd/be0qzhz
         c/uDVb7gt28U4Bqc6jR9jeXHJp1bkn2IzlTbjrFUa2oWZraQq5qnjHGPOU6yFImLBpzy
         26k0n3ZpZ1TUPJu/FxTflrQvWhpGQDfbjIQKS5qiTU/ixgRlDdhoTvI3nIQVhJixt2Hl
         BXyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WEX9+sqg9KeVky/NcPkirTK8PMNoKH+/ZsoFca1T+0s=;
        fh=7yMbT6LKo22ldLoNjSxOab/U7RYllEYIMKO6jv9uJpQ=;
        b=S78ijk9TKp42jU1xTZ2xelPw1a9TxlK6586Hyb0KT8OebOqILSKdMteMaZeJ1NsIrr
         NV/wTdAVwliFKEI6f/sqNOw/jaeg+4Rfy7OX/5soeQSrN2Q7/sli8FVZOGraGZ8D7Q+4
         RqSyt7AV232ai2WJ3LbYlf/0eyU9iJLnKvdufYrdob5zQZYc9e1zg9IoP7LQwR70svkv
         hkJPh+rZRMW1oNsj+Xq1DQUU7k2B+NP3twGBmtQLJ4RJ92JocV17PUC+2etr+Z4YI/1a
         IfHFX1VpvJC5z6+107wimG9wXNs6ByqH/VpKfwpb35Kjhj+L1h5HDdxX98++MpkmsI7x
         9tHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793039543; x=1793644343; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WEX9+sqg9KeVky/NcPkirTK8PMNoKH+/ZsoFca1T+0s=;
        b=U5RFi0qBaLecQzV7ZF+kYqZraNTeGLpJg0AapaAD9FLIctIwPSaE1Oh2/+h8t88s7S
         rI5NzoniSqp9g24/jynB+vewgCM+JjchJSY3IwNTCjRs8Sw+uPjPfrLUAtAzX9tfJ261
         DPU10qJ6nVFYKbTD/PUk8LBNjQ0/Ft77ortipw21a0789mU6XPfVpnAcWlaNwDjj7aNy
         Kd1T3rnOOduGnQ32cmxCsUmi0bYamW2OnNJcZvlkfqOItaMPe4/NCZ/umVzW4RkY7AB3
         q3IHo/aIZTYSJR6pf0K05Ggk8M8YAwMX667+XHyb3CCiGAx+Nxm4CO4zFi6XPHv17o/Y
         TYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793039543; x=1793644343;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WEX9+sqg9KeVky/NcPkirTK8PMNoKH+/ZsoFca1T+0s=;
        b=XcBTi7YfPvm1vEhKmNNbCU+PzWbRXu0pxF8sbEq0GLLivF8S9FboPTM2unl8cI2Gup
         B5OOIqtxQVAq7Z4pwqIVOndGH1+tagypwdSa5Zh0WPltLSxmyRk4DfdUPUWePx6W+bko
         C4gX0KATXacboTaBuQPCq2xaPbEXHtT1ga1g8Yek/3qULuQBD/Tf+1BXjfg8uT2oF1jf
         nS23QvcN5zHkdvU6uAf9L7WKMW/vydnO8ytF/H3u1yMX/oTMo6GYwKpca2k3QNcoaR5X
         qinn8+n1jBw/RzrEXrjWsPV0MfJ52hJEaneGjIffGDDkK/7incVJBqPaeuoahm75542a
         TOmg==
X-Forwarded-Encrypted: i=1; AKwUvBw62HsYgjfIMInUo35sXDYGFpHPeuQ/TySxmWUsCQqIQity3JaZ6XadoE7Cn7O9HK0d0r2JUcoDyg==@kvack.org
X-Gm-Message-State: AFq9FYINsdz3qiULxvdZ57mC2zG+eumA7OxX1X5ldETyaEjQEYDQdsnR
	uiLHYDR1y3UYyNlYlUzLKMnsW7dvPUv2yAtrrycqVhjHBEP2aumJCOP/R4BRqKoaswoxzv0aYVa
	nmYvz84cAnVAusWci/lpFXakft9sosIk=
X-Gm-Gg: AYBFou3pZaFVU12xAOC1Uj0aqu9P9Tw13jDuSyYW+B8dsV5g38zSFd6P9BYkzNfdZkj
	obFzKGI7VRLmbPWnU0H/bb8f7Vesh6FCE2LmC7/s9/9jMkUGNcQhyZItTJ8WhZL93ZeQlM8v9F9
	eiKmjQ2029Gsq3+EpOaxQtA+Bkm8YQBHlRGA8o2tc1mU4urU70g0HV9tKLvDWxNKmyWJKPDfZua
	f0rBZaYcXFdMTyzjv9GREs1r3ZKvYaDo9RGl4nCjwFTceWWj2KbEFo1Xtb7Cp1efUw1mq42mhsG
	4y/edzdrQ/WdXWkXAzTw5L2XmSWn9B2S0EIMuxBav2RsekaWi9sEAYViQ7kbwsZQdOlYilTn/Zr
	Nib0vo6MyIWaLQYob04kFJUkBkcyYD2toYgZnGvIX3jqOa7F2iPXuyTGypLB/QuSuKsYxWJLDCX
	uz9ULDRAGhFnXgyemkCC0T/5qVmG0zBqNEadt5lwBeb/cCNMdM3+GO
X-Received: by 2002:a05:600c:4e87:b0:4a1:a2c0:7b73 with SMTP id
 5b1f17b1804b1-4a35acaa6c3mr145207195e9.30.1793039543135; Mon, 26 Oct 2026
 11:32:23 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org> <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 26 Oct 2026 11:32:10 -0700
X-Gm-Features: AclHuK_E_LaW5XNIuZY1k1mQOjBZJvvQ1cVrvsfMHmbvxMe_yR0Z_CAYp1s13eU
Message-ID: <CAKEwX=NJfyZMgC1trXKnr3G_PMau+j5wqMxBty6QtHCyMdmYrg@mail.gmail.com>
Subject: Re: [PATCH 06/16] mm/shmem: hold off eviction in shmem_writeout()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gregory Price <gourry@gourry.net>, 
	Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Stevens <stevensd@chromium.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C524310000B
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: m9eg8em8a7gb86n86bux7oadb1z5hiro
X-HE-Tag: 1793039544-74489
X-HE-Meta: U2FsdGVkX1/iBQS1AUSN/LXOum4nUquX102BWZt5sG+P12GT4RmFkmTKPyWDsdIpaw3S+l9Uv2+F8hfV0Krctp1Jti4rddhp31SlQ+j9IBMuwLcRc5WVIanu2uEJUPpsp9vviHAlBgpCZj35naMN4zwqKGhlidz8ZfrZ4UHI4tgvbdR5+Bc6Lfv68qbxa1+tTxs1PT1zAHuvZN36t5vh6uNgl8nQVgZ4gLepEnrakwfsZ/9arJ+1HwD0GHMGTUSJbLSEloKjIW0q3H5NK73esOLNJJAdnpshKlVvx0zdQweBFn21Y5By5xXtpiHn/JhT0/0cji6Ske1KANDoVCkjjgw1K+K4RBfIf01/L7Ew1h5jcNDONK2jvTwaeMxO4tL0BUeyfeaWR0QGoo8Qwljfc7PQ9cy71mkbKrV2L8FCmvn/2D03IebjLxtp/aUQX9TaE0DWbbMoazequLo+VfhiaJa2jCTfxrVpFKBTTzshhNkF7mtsgtgz8b2idXNLscR4NzAYY5CiUG1nPo1SMgGYVZD0P9DCGL7jell/22dI0s3KqUNFICfTkOlNIhfhyOTsJh9w0i/2aRMfXIx56Y41tVOMSVSzs5RV2tV3WHzoqviBwLvOYK1e60UN52wZY3SJMVMTUpdzZPWBtizI+GeoO+525tkgddbBto9QYgaPCr8heFstlz/G4Hd0zCo/yhhb+MoxQ1MuGMXd++O3joEvMgcvYd7olxgiRuEw5d9udBrf2/yBrRLs2MSPlGqGjPH3BlIhJqC9dty5j+WdxniRU93JJYpETPPVYWXiQCUIszL8m9pDqpbDlG4c9upxrq/p91yzZYP1qMhJWeB7EzDA/8WKhOTOqKenuuiCks4GaD7ZZURp6sVf2o0rkCsOOHTwE3MB4aiGO5Xn6IIMfQDlotuTzOFP9rmVDLGQsnd6edVlWRq5Lty8uFjFbMOy/fY91cYhc/KwKBsj7HDsjMT
 MqCU5kXK
 uG6h44QJwmWCDB4ClwwWDcpMr0He2rrXhaChugeQCeF/nwvxSXrp6044OoQzyKNZzSCs9ab83ukNiM1KKgGUQhVYSIfbY/prH6emwZUMSFiwP+Lv8bilu1rIBG4eag7M8umDokj+5o4UsWwT92t7ktu6fQTX9P/9Pis1SB2esMAj0wH90BcMNvZmIXix5jM0n7RmfFoQ6NahchWctra/B40bpWykXyJzZ/0Ekj1ixEGv5ZppXbValZKhn9qLQDDxV1LLibZKtc5V3A6xKCwlsZ0wtBqOlM9fg+e/zm464xoMFdHIuCmW+nUjjYFlM5YB784Kf3hYxpTjvXsMrKJVdtivBfwgxoh4nc58HcCRedEp+n/wbjNt4lCw8KXKAY4UVDw41e3gbDRNB1DamYOlidrS3zInKxCd4Yd8rudWMOemY7EqMUD6AS/mB+1076TrhUWD+ZW8Kn5O/LeuWAC7n7yH/TaSVEPLhWrIgVQeJhZgqV2BYdaLVtbahyMDt4TbI6MnVM/fC10iXnNKOpC7qcXaC2jUo7Th1YXyl3Ru+8EeVaNmBQZY6lXZvcd7PSiEfy+oPqJoTx+DOoV7y2UOADHI3VqRN1Utztr1pjmG3RXi+bz9LvG+aIT+UrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 2:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> Once shmem_writeout() has moved the folio from the page cache to the
> swap cache, the folio lock no longer keeps the inode alive: truncation
> and eviction find a swap entry, free it and do not wait for anybody.
> That did not matter as long as swap_writeout() was the last thing the
> function did.  But since it puts the folio back when swap_writeout()
> returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
> afterwards:
>
>   reclaim                               last close of an unlinked file
>   shmem_writeout()
>     shmem_delete_from_page_cache()
>     swap_writeout()
>       zswap_store() fails               shmem_evict_inode()
>       writeback is disabled               shmem_truncate_range()
>       return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
>                                         destroy_inode()
>                                         ... RCU grace period, freed
>     shmem_add_to_page_cache(mapping)
>       xas_lock_irq()            <- use after free

Yikes on a bike yeah I think this race is definitely possible. Good catch.

>
> swap_writeout() behaves that way if zswap is enabled, cannot take the
> folio and the memcg or one of its ancestors has memory.zswap.writeback
> set to 0.

Acked. It just takes some incompressible pages to trigger this with
memory.zswap.writeback=3D0.

>
> shmem_unuse() already added infrastructure to deal with that.
> Reuse info->stop_eviction to protect the inode during writeout. Increment
> it before removing the folio from the page cache, and decrement it after
> swap_writeout() and any attempted reinsertion and inode accounting.
> In shmem_evict_inode(), wait for the counter to reach zero even if
> swapoff has already removed the inode from the swap list. Add some helper=
s
> to make the code easier to digest.
>
> Fix generated by an LLM and sent by Josef Bacik in private.
>
> Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() rea=
ctivates")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: code cleanups; improve description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM from (z)swap perspective.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

