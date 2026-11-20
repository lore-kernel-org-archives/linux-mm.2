Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D8D606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BdK3arbk
Received: by kanga.kvack.org (Postfix)
	id B2F8A6B05DD; Fri, 20 Nov 2026 03:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06F76B05DF; Fri, 20 Nov 2026 03:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5E56B05E0; Fri, 20 Nov 2026 03:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71CC66B05DD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:28:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29AC21C4914
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:21:46 +0000 (UTC)
X-FDA: 85454803812.03.A500F12
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4F9A640003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:21:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BdK3arbk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795162904;
	b=ZY7GME5kvX95BlGFG+35mtNtXJCFw6kdnmFQatisu97wA/ZnuZpclkOIghbY1HKXuSDG/f
	4kcdkBvZoDttRMtj34HRExaN6ZA6mjs+WOOFlTHKW+YipQjZxl4hnoMkkLv8CwX9q03y4u
	UTxh/ZycGJKur44UjEbiXsqa93AkRMk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
	b=KPdXK2Zx94HkQG5TvdM5xUYCho5jzIHGzXH9/KLuQarsmXgIQGB8fAWFgGELC61fxW8Awg
	3qIHMjNSDEmqJzhrqwOsl7R3cUUPmJukxjVsqtYhD3XiTXl/AYUDJwoqcBiGKYoBVspYBF
	mYl/Xc3g4R+UCL29d9JqSyYnRfm8de8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BdK3arbk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b8815693e2so734127a12.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:21:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162903; cv=none;
        d=google.com; s=arc-20260327;
        b=DUOC5WHpjgmOzFFZSMr8uZAxyFYI2PrrkE10qygRYI11C84bB6+3f++fBjWM/PTgU3
         0zVHTTYpzLBM3GCfN1UvWV9tHLOKuJ0eBX1oNRnpTpj/sVAoaVNfa/zerhi3VpCzE6vA
         h1HDSbRuYHPQnq8GeDVn8BuYd2PPaIvQbEjkI9exFrcAbMFA1buHWJ80yAiN3Ui3c2Gc
         cviEnLYm20wVAphUUnjdVN1O070nscxFZx+hM8l0TFO/gT/TQnq5V0+4sr+2JJQ1q6nq
         rj5Ciodi1YozZGlf8n21kxRVs69kspOs2sKs/6Kx9ARWBU31fnwmQAykRLvM3/g5F/ob
         IYyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=XQ2LqnFt1ovkXz7ys9SvfyUoLPHWhdaOOfGfLl/y+njUk+6EeHTzBRyydJEDCSvsG9
         0TRzVv3G2Mc7Glw6ha+1G0ms7l97AT/CXncWe3ac1Gmg/8N4OLJKSdk696s2XPlEb4h0
         1qU+YfXxwwhFQDr+XRR04hLUqZQ0eVil+Uorl6eBBC3U+Tf10tNi9z4q6m/RU1F6boPw
         Js3rGJsgOjKaVBbc7Xn3UoeWT9OxjedOP+y0oZdYnp1i2qYwrT2SlYczTNGegQClfvDP
         hINWN6V/w+VACeyrVZ1eCC675zBzZIBlVI+9XArDDw+fUJjdYItMbIWH1uRf7LDkElki
         SJ4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162903; x=1795767703; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
        b=BdK3arbkzDHIUgAdmvKmIk1QYcxRSdMRUurqVMaUGbha4AYCqdX5En8s4z2WWWvwgH
         HHVxT/WJqMUSvxe5aZKHxliwt+7K6VYvRz2yzK/iknwEcC44E71J85dPTMOojnIMDBjS
         HFCzEp10jp0byTDORZJP4OtEu1TfigEa6bC6kzjbPlz+FCEZJgbp86fiNvjnDzF4vcF8
         wH2MrPdWg+Ti26qPuSpt0Am228fvNtO7uRE2rdijeKvR8M6DD99ISPvxy2XWhMrHRbq/
         eAOBJF8ZWfFyNGL274ilxji/+8L3vHfYLhq6g5go7PFxtFfgS0xMepTOb7DTWt3iV5Kz
         rR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162903; x=1795767703;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
        b=DNQKwwJp8mPNtbcjSHt08rDyT247lOwa+C483UQJ5AMtqX91zKqwP2iTN1fBD650Ds
         R9Xla3L8ShCvsQKaymFD/P37TU0TGuTMtWMOEWuO01n7pXWfby8zRoamPC+gFhhgiaFG
         7JFGSZ199dynmOIkqa9K+HpTTsTK3c+K+rIP3pncLfcsBJzkqqXsXldsuvzKrDi0qu8D
         RUx1XokaQ9sYkW2EvjqLrPzTCVf/QKzp2CAdkWRa4jwiabeoK4MeVkPEGuFAsLJ5PmIK
         7SpEKnva9QnNENu0PsTKXCJ/nTit65kqUjaI0Xp5zg+Qmb9gIMA8d+aAC069tcI/iUmU
         zsbA==
X-Gm-Message-State: APuU4Z8bEeqNgbmV/oGn1/AL4w5cSj3tTFsBT1qX1fO1kAVMf2Dgb0DP
	k6imFSWAQWZXDs/vugGgh03VKvqVGPdBUTrExgETNUyrBt4xXYtRURZ9Tb3EE2TI1lXbrQUFkVV
	6b44rPxrgZWpCNrb4eq5RL1z02oLenZg=
X-Gm-Gg: AZFdTZfbsiIt+Q/s9y9w9OOL24ptcXjeVpBdTIXjTBYFjqEljj3/VvsDIzYWKv3NKVV
	tk8XzvuPDPcA7Hx3+T8PEuny+0TXabpcwvefH7P929LAzOQXVdvw3FqA9S6bKCI4x8QeaASgT1V
	vYHk2TsNsesMruiswww34o0DI/o+HsQHTT9EOHP/UUj1+mi8JqsuiLEV8CdxE+DMqUiflXLmZTn
	pt/LQbdFx5CSTlP0fjjewS6dnSjfGDTSRf3S5YWnFjpPgj6/5IesLq2d/jkmdSpV5xZYDGh5XkE
	IbHpW0oYxC1QFPsmufgJ09rOnJXampOOmtMZYzRFLIqGTunNT8qp+kyH1qD1vN7EuRBK/JfCN/Y
	N3XtforoFXenDA/CHIMMGttxXf7o57CehvNWoVN1Fu8vRze0BrkTdalMyQNoSRHM=
X-Received: by 2002:aa7:c0d0:0:b0:6ba:144f:ae43 with SMTP id
 4fb4d7f45d1cf-6ba37c7b138mr1084173a12.6.1795162902503; Fri, 20 Nov 2026
 00:21:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-11-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-11-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:21:30 +0800
X-Gm-Features: Aa3M54qin3mQjFf5kqOfy-EjZ2kR5w_yWqv5wLaUrnSsLRk4SMbzaUhZRRw7xMY
Message-ID: <CAN_Opa-DxzvggsGKMXJWd2vSKjbztttBHx3uSzJawbiiEOa2bw@mail.gmail.com>
Subject: Re: [PATCH v5 11/17] mm/damon: convert to LRU refs based operations
 for MGLRU
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
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4F9A640003
X-Stat-Signature: k7adi4kczzh4ko49ke7td3qqce6mmuth
X-HE-Tag: 1795162904-737082
X-HE-Meta: U2FsdGVkX184E9sXv5w0HIUgN/acS6A1noXhM8PgUp9Jmrf3Q5zACzGAtstftl/Fa9ntn0Ix2svMJXys+bsObA8QdfvW9KlxKOHjdZSq42NiLk/pTS8SyHG6zrn+WAT2dyAKwDuoqGej7dQsWrR/mNXC+bff5blo4tMMBV9J5vkpWpBcqi2XYNGt2U1FQgjxI3VtPtfCYe+NljDcZyUC2fqoEYo4awOvCtchDeaGQJqjjvwRtBcF83FuvFSwOwCMZYJ/6GZ5jjHUiiACoFcG1LA0/rgqRFIPVEQx58F7KGWA0dcCStre64cx1JBy26kxZo5CO6kozmqTtEJVZ2Cm4mAII99YbfIXM844hdmdJP4IcApzNuCDRrBTn2Xd0RwXHbIxcPliuoxG/tTpLyO8NlHQ52vsxN5XMQSFAHXJtXpSeCST5+b4HBbp6yHqP8Hs5FxjCYg3aFyAslPZFvb/O/e9tDmFPQKlSYvF3p3OVGZonK4bv/J5JrvAFzl6JkcJiaR8ZxndcvDduDZFtlEalNQjtF8edDovc/Sdls6BKfft77EeocPlij5a4+JgJAekWvDWC1O7lGmtjMfiXWKfXfshzes+lBBhrSFklJLT/v9XHuAsu2z3iw9NKYmzy2LTR4r99GJiLf7W6uyuBVscyRLrS18XSySr1EdrAuSj9P0H6EnDeReMAdkN/h59ULGdXAI4NiJhT0g7SIb/YS7Ue1hWaAwnUU7l+oUx4xZEEJswbrDGyM47Vc/qhmFO9G7lyXBv18Bq+bO1u+2WdmV0+vLvukHFT6LYQIfyYMGq4GrDm5JNu8rbkapJyVpwcraMLArb8QGCZCbTeV2fHDJuI0D0u758CC41/tSlOPpAI8My2kM8Fwx5odXQ0YSJFm4CMRLJkEQ2ukATbC59a7NLZVgbGHUT0IsOGx0lLuLqMVF3u4dF1KhuFmFE1Hcg398J8v8Y5ajYiHj9KMwg5dM
 NW6yeE6u
 z15TLYpmCpeMKyQBTIgerKkAeqT5CQd54PoHjHhRRJ2Vq5stKOQrWvkLJ+WAqAL6mvUWPpGNA03hzwu1g263EjSMdSDmYbFwfbmg72Wmo1ZZG+hcl2GGbfuRxinDCucmSyE57sZKeZFmyW56TntujKchg7Sc+LkXHR5ECpoUgAeQusgZnE62exulP5ISt9nCBetUfbOQX6C86Y8vLwuf1jCt1vfg6MhQlkkw3IPC4pQT/BmHT86w7s4GrWXHtiQCLzJY9rUpLuSirIYRIRw8z2KePny9hN2z1tOWFW2kV7ED/6jkwzZmIQlmC+iz/IzerSdQawk7LHJrLflQOiZu0/u8irfmahdiRVuZaSFII4Ajr3ymXRs27HWJhWsZtMBkiQAahZ8Ppidm3NXVOpNEiIC1fMNx8DWxX9HDIDzbiTzTVw07q6WrVq5XFphCKT/J3wjy2uDpzQsjGqvkFYyw8+LmH446R/uNplImje07Im2eQHV7rDToNqsowGCSNF4AvKzH+vR+kGqMtFLKc/zXFf85iZk+Gy/xMP6Yc9A2WbvS3UbrK+t726f70yZf1+bxKu5QDFSzb3S/hkBgRF0mo0UVwHBz09iFxWkplsmDIBlUpiMfxf314Ch4q5XYmavhbubOACIHbfGesDK2gfKmErYEkvWUDbVz7Y+awNV2A1tuJ9qkoDTLh4KcpvVWuMo151Qi+sX8VwltD65DWR+2E92dMfmiIjYUOeucN/YCa7McgrBygXsTpQuoO+xNXEkE7zSvI+O1PMytEABhLzsXDbalTYRA3fM68cW7KF7ncrVvvcpe+tUelw0kKT0vgPzZLF378
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
> corrupts the folio's refs count. That flag is now
> bit 0 of the count (LRU_REFS_FLAGS).
>
> Reset the count instead under MGLRU.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/damon/paddr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e89cb14ee17b..411e1d557ba3 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(struct damon_re=
gion *r,
>                 else
>                         *sz_filter_passed +=3D folio_size(folio) / addr_u=
nit;
>
> -               folio_clear_referenced(folio);
> +               /* The region is cold, better drop the hotness info. */
> +               folio_clear_lru_refs(folio);
>                 folio_test_clear_young(folio);
>                 if (!folio_isolate_lru(folio))
>                         goto put_folio;
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

