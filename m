Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EC9FCD0C5
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15EAA6B00F7; Wed, 18 Mar 2026 03:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8CB6B00F9; Wed, 18 Mar 2026 03:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40E36B00FA; Wed, 18 Mar 2026 03:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF2346B00F7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:17:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B6D21605AE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:02 +0000 (UTC)
X-FDA: 84558327084.30.4F25590
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 80FB640008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XY/owpya";
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773818220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rp7+h0doflGXOukRq82H4Fs8MStLttKylnpU51TIfKU=;
	b=2uTrM6jaheHA9xsxplg4Hj83O7M5udY/8CXaDbhJgoi8cyomViG3RdGAhhmO85xs0itebl
	Ji363Q93sXYS+OXGM+yS1EC/HynrVdK8yc4OHUPG0aXX/WegvyS96H0w1TL5IM9GR8oS0V
	AU50kRlsrJUxy/7zGVTi66zPaVMwALU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773818220; a=rsa-sha256;
	cv=pass;
	b=jOjLQefAQUu9GBEu6b5KLjMVgpG5V8nzxk3Ka4fPezl3JdkxdC9i5rI8EvADPtkaFamXfZ
	9A4/T0gnoVCrwb5dXzjM1UxqvY6A6y5LQLX0AZcbiLgAQ0Vv7FBMXZS2l48gN/uCbINkcR
	23DeWTZUmDPrQfDxAbhHRpal16kd/Is=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XY/owpya";
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89c4f7f8650so48357436d6.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:17:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773818219; cv=none;
        d=google.com; s=arc-20240605;
        b=esBUY2Hr5QXqFJNBdtu2feO8Z4/x4a3wGp41f6wPYb8DTAwXS61m/cMjS+aG5b6kIH
         6VmYVhTYyI31uB2iTQrXXKMvDIFsCWZy2LZ5YikOVeL8kEYxFhZIrkH/dkU2StxbyZPH
         B/kESvtVvdwtMQLbR+k88VFxdVcqZzYqlr+EfNUmZhuLgKTRPCO9NOoy654W3Ak9fORx
         eFweC0we6ENN7UQwKIoxrjG25GoQ0iAW37jq+zSFUAYzqv8L8U0Pu+QPO/cWo2yDzlRG
         Q4UzpKWZrRLY3fFodJQGEd1QgWDcNz5DlXvx8kBbd9jiib/lOV02PhyFLqE6URJltdNc
         8LjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rp7+h0doflGXOukRq82H4Fs8MStLttKylnpU51TIfKU=;
        fh=D53f7Fo8+mdyXh1sJiYliixSE/1MVwMwoIjIryOowkw=;
        b=T8AzReSdKnO+exQL/8KnnoJS4/AWJ8fI6HpbrSIj/5nE56SWiR0qYDqVj205TSToxV
         tmwbn6qZtjHjiQbyG+V1pBKNMe62Uf4ZzoNdQkoxJD8Jf0ua7ChN4zT5SucY64p0X8Ez
         j9oK8qPkX3fY1/MpD3lsOIyEqppLzlOt9L7U36EYo8UNlmgwK0ALS66dfIjZ+/O4xMOn
         oqLxGBKLQGHRaA3lfduxGu8XjrmbHZ4XHgMM4oGvYpIMDbtEnLrAUgJOlwzfviMNIYL2
         DnTyg9no+RUJcVHgCAo3FlaguFVOCBcTCGZow1Hmw20jIoR232Ino8JTZcaEyHFI9Ne0
         kDbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773818219; x=1774423019; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp7+h0doflGXOukRq82H4Fs8MStLttKylnpU51TIfKU=;
        b=XY/owpyae4AEz5NKomK6bRMSf58r8zSLKCWRHYm8bE/20IudmFf02GSkMlIpA1O2ER
         X3UicmU8g1FYbdPyfkhI87pv3VtrwYxIoYa+QrI82JL5g9/n36U1xzO0E9HJRjBuZqyv
         ijV0M8syjllHu4wNwWLtLbsuL7f9QYwNsjd4jMm0FDiHnmTWw/ceXO8QEHKy5/tk/Gjt
         aGFnkaEmfDhrFvvddiQUfdh1rqdI3GA4WfMclN6w2K581yVj9yLIGyni+FcPbY3/5Ang
         fQC8dpGB5fgpbCbRl0+HsQmRbwwNY3j4JbUIZ6x/L1z3vWi9e69v3qEOCeMEHGkG8BEz
         5PmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773818219; x=1774423019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rp7+h0doflGXOukRq82H4Fs8MStLttKylnpU51TIfKU=;
        b=Bv+vK7FwYzq1/oX6iiliX2mCSzvu54QjLj4TPvygwHzURez/8x4sxmPDcokSsznmex
         4RwHzmLJPdiq9fuedVF+UZ7nOwiNYvh9raufDr+BA94vrj44qYchO3r+H9zT3mwXU/O3
         quZ6VcImW6BwYheVCbo8l5mjCYZMehaWkAT2T5CVdHxMaHr5YxZBfKMqpi8emlvcztiU
         OXAihVElOS2B6M/pM8sOl9LeELZ2sS/icdAxRDK/IlA9IrxycYigTwjW2mWJ6Yl3Xe+O
         +eEoKfOfwvCqJLzKRjYEJszRM04qUKjGnvfa3RST0jso0nWW3oNWjpLmm7gqasluj49b
         Rv7g==
X-Forwarded-Encrypted: i=1; AJvYcCXkpbK/FOHMQguScY3JHPHbzydYPPUtYWWRiFpBubUYAvd48SETDcs1FV1OWNqeZAHdOvhl3L31dA==@kvack.org
X-Gm-Message-State: AOJu0YzcE072gBI0fvg6ixBAjB3N3YFWpCfXvSJICZWKGztekt2KO6iR
	lMUI1HUSnPhV8ThCmJvaN3XLijyrnbRys0ox8BYmvjRFkhInbc2OcJeZ24DRxf1572cmsQODfgo
	ol3uVF5Z27Z3BNDvYLdQqkZHQXe2PxcM=
X-Gm-Gg: ATEYQzxFh+T8cfuROKNa0z4tpOWlx6zSEr8UF7f0v3WYHYO2rV2xPdmdc2pq3ZskHsX
	wlO8Pe9HJVv3cehDRTsSt2Ba1V/lJy5XfrZCzipIqs9MRQS4K5LRJ6FGwoThEKbZPeH869OXS+V
	RHL1fH2VOnMM9yyAY0vQa9j3uKb/SKVgiOyzcmsQNdojsJ2vC5wZTG0jsco0EydJiNifh1uOMUn
	9rm8Easo1e2XNkya+G2csSW64g5d3nEG/Yt5EcPpsYzi8YyRzhfFXXcZefwCru9eknKybU+l7of
	msoi/Q==
X-Received: by 2002:a05:6214:2dc9:b0:89c:52b6:ba7a with SMTP id
 6a1803df08f44-89c6b490e69mr35139636d6.5.1773818219175; Wed, 18 Mar 2026
 00:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-b4-switch-mglru-v2-v4-1-1b927c93659d@gmail.com>
In-Reply-To: <20260318-b4-switch-mglru-v2-v4-1-1b927c93659d@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 18 Mar 2026 15:16:46 +0800
X-Gm-Features: AaiRm51XzoukxjfyFHtsHhfDYDts37UvlaucsPU_xoBbYFa3LYp9hOiYs1EWWUY
Message-ID: <CAGsJ_4xHvtjkPp5Ar16UXqZhQYHpdYcqCWMmFbGGUvK-kCH+uw@mail.gmail.com>
Subject: Re: [PATCH v4] mm/mglru: fix cgroup OOM during MGLRU state switching
To: lenohou@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 48jgi4p46ofigw9tmcyq8dsbwuzswiyz
X-Rspam-User: 
X-Rspamd-Queue-Id: 80FB640008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773818220-786993
X-HE-Meta: U2FsdGVkX1/7/0AhxrE5tM4ZODctJ+Lsp/JDaNrAjvaVwebnhyygiwMA/d98ABR2b91gRt7cNQ8jd0N0zdGtIvWuScGqOGc2NJvZncuKMO7vKkF8CMAa4KTnxAOjRag35dIaw0ueaLiASGNDG9HHC7FEfLwuBrxa1swd5HCOrY9coJRizKFQWzXtBhl57kDAZYQyJHf6IMUvaLxwaKYIxH8wGvrb2VB/MIUlSddMQj9xxTJ8lHhj/VcZaOnFbSB9HV453/wtLk3ZQ7F4tKijFSfaRWdBMzKSIlM2FOlox+ljffmXouvPxx6xEtj3MRGDgrvQpFRwTYy18MDbKdYZbIJ9aHdtMD93MByJJFkbYhKYW86Di6BdyPAKvU8zASlFm7d/8YFke1FaNxgtGg5KvYEM/TA/CrLzs/G5Fvp40l+LeQ075UUSjQwAu+KoBNe3xTL11NwqcpLm+LvgK0yEy0Xt1kbrQmbdMGXkSO/fuDX791q8t1HkwEg/lf6zuQfGYGWfGZQfbVy/OERAyHb757atUNQ8IiJ1qnfUtMsxrwkIufqFGyu+SHnyOzsqt1bH+xzIo9t63E6t1X0sZ8+2Xdk8u0J83N8QHn1dBojvJlHYDRg5n8jE5zyIEmtsZ8v1UfYuuikKSmIit0kRpQBTIB6/28t3oWy1lHLkPovGKHLRlXyF5J2teGmWgZaDBmbTvL5ZrL8apvLsT3g2Yy++lOjO7k6N9r+BbYAK2jYpOyTAaqgj3MD9zwnO8UScCCiA1IwL2KYUjiWY43+S04YfBttAxltj9ijsuUyYRSypHl+jAsOrQ+B/2OZpL4WuvB95yu/OknsyJwdtG/75Ffyw+7up2oj6N4cNzl9etQYIRGS3RDspW0dDAMLDTpNGr82ZrWBq/Qd4vxwGj0Ok4wMn17nV1dAs+SuGtn//ofd0Bmnau6x9sAZ8Ha66TUie4cQXNZXI0g3whMPliOwTiIY
 PDrArWz7
 +dL6XqkX7xwRcapYkdPd9Rz03aHDyuUkmBNgxRkvciSoEi3JunpDd4MvUEXxZMUvN11OFwIexhclH/WeE8b7VtJ9quA9LnBTd1N3ftNiQNh7B/Wor9G0cn4mqU76qRZng5j6MEblmIwk5WuMM9BbKPCNjftPY+IRxY6ja+Uz1mRPmwyY56Sn3Ftc6bxK4kAVAyqDtlXbGwng9cP///WLd6E84Tt//lRKoOZ8RtltO747Kj9pGOVFhIGyB40vLvWm2vhRtkBQC0P+vG8cYLi14eSdfag5Sbcxs5Ad3kWoICF/A5J8N0wAgCrG2WSWfoUUtta1F7QbYXMWSB2vAVDtw4vd6Wo8tt83bjhCXCDxAjyWLB7wbHD3JdQqmWWBhPUgkHgWDJLL8Sl2QyVrJzX4Q7ueR1umMDQK9mlc5+oufdLXHEi5IBF/CqedEQK1TS4DZX0TeT0V3GAjaox5/Mmzd85jZAwh1F6sOydUiILhDY1qPIeBIfLryL84Uq33cAho9XV19EcY6i0OdBZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 11:29=E2=80=AFAM Leno Hou via B4 Relay
<devnull+lenohou.gmail.com@kernel.org> wrote:
>
> From: Leno Hou <lenohou@gmail.com>

[...]

>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ad50688d89db..1f6b19bf365b 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -102,6 +102,12 @@ static __always_inline enum lru_list folio_lru_list(=
const struct folio *folio)
>
>  #ifdef CONFIG_LRU_GEN
>
> +static inline bool lru_gen_draining(void)
> +{
> +       DECLARE_STATIC_KEY_FALSE(lru_drain_core);
> +
> +       return static_branch_unlikely(&lru_drain_core);
> +}

Can we name it lru_gen_switch() or lru_switch?
Since =E2=80=9Cdrain=E2=80=9D implies disabling MGLRU, the operation
could just as well be enabling it. Also, can we drop
the _core suffix?


>  #ifdef CONFIG_LRU_GEN_ENABLED
>  static inline bool lru_gen_enabled(void)
>  {
> @@ -316,6 +322,11 @@ static inline bool lru_gen_enabled(void)
>         return false;
>  }
>
> +static inline bool lru_gen_draining(void)

lru_gen_switching()?

> +{
> +       return false;
> +}
> +
>  static inline bool lru_gen_in_fault(void)
>  {
>         return false;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6398d7eef393..0b5f663f3062 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -966,7 +966,7 @@ static bool folio_referenced_one(struct folio *folio,
>                         nr =3D folio_pte_batch(folio, pvmw.pte, pteval, m=
ax_nr);
>                 }
>
> -               if (lru_gen_enabled() && pvmw.pte) {
> +               if (lru_gen_enabled() && !lru_gen_draining() && pvmw.pte)=
 {

Ack. When LRU is switching, we don=E2=80=99t know where the
surrounding folios are=E2=80=94they could be on active/inactive
lists or on MGLRU. So the simplest approach is to
disable this look-around optimization.
But please add a comment here explaining it.


>                         if (lru_gen_look_around(&pvmw, nr))
>                                 referenced++;
>                 } else if (pvmw.pte) {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..88b9db06e331 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -886,7 +886,7 @@ static enum folio_references folio_check_references(s=
truct folio *folio,
>         if (referenced_ptes =3D=3D -1)
>                 return FOLIOREF_KEEP;
>
> -       if (lru_gen_enabled()) {
> +       if (lru_gen_enabled() && !lru_gen_draining()) {

I=E2=80=99m curious what prompted you to do this.

This feels a bit odd. I assume this effectively makes
folios on MGLRU, as well as those on active/inactive
lists, always follow the active/inactive logic.

It might be fine, but it needs thorough documentation here.

another approach would be:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..91b60664b652 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -122,6 +122,9 @@ struct scan_control {
        /* Proactive reclaim invoked by userspace */
        unsigned int proactive:1;

+       /* Are we reclaiming from MGLRU */
+       unsigned int lru_gen:1;
+
        /*
         * Cgroup memory below memory.low is protected as long as we
         * don't threaten to OOM. If any cgroup is reclaimed at
@@ -886,7 +889,7 @@ static enum folio_references
folio_check_references(struct folio *folio,
        if (referenced_ptes =3D=3D -1)
                return FOLIOREF_KEEP;

-       if (lru_gen_enabled()) {
+       if (sc->lru_gen) {
                if (!referenced_ptes)
                        return FOLIOREF_RECLAIM;

This makes the logic perfectly correct (you know exactly
where your folios come from), but I=E2=80=99m not sure it=E2=80=99s worth i=
t.

Anyway, I=E2=80=99d like to understand why you always need to
use the active/inactive logic even for folios from MGLRU.
To me, it seems to work only by coincidence, which isn=E2=80=99t good.

Thanks
Barry

