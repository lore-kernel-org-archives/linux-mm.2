Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3243FC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21186B012E; Wed, 12 Aug 2026 08:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9906B012F; Wed, 12 Aug 2026 08:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E3E6B0130; Wed, 12 Aug 2026 08:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 921F06B012E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:28:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1ABCBA034F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:28:55 +0000 (UTC)
X-FDA: 85092546630.26.C73FB92
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3CDEF20008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:28:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mxAtUg3f;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIk1A4gZRpm14rdjHpjqifL/F94df1vMYFjb/DyIcJA=;
	b=g3FoJVZvnbWJ83M2yQkaWzcnE3vit9GuNIH+iSpg7m31QcHCLTRwwdKSnB7KaXvvcm3nq0
	sn9V4qsMj0/I3q7VkY8qfyzCv1x2eplupEWD2NQVWi6ObM6BL+Q/Zf9fYy2tErOg4j4RBA
	4SEPl06ahNLjKPzfAyoyIN2+UeMfDBs=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mxAtUg3f;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786537733;
	b=uHqhLxusvSqnLokOzT8F0OIt9epCJCdmtFEm2hYZYvTn69woI8jQLF/ElJxmxWGSK3lD+3
	JmBdmDUDREwotNFfxoqU5Gsjb8Cv0AaQ3p4McBkCc0BkSUnae/a9q0WNAoIMVRjJiewGr7
	xj9AvFY6PucoMEGQQjcknAHFgkycc9c=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a1542cdb53so1066556a12.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786537731; cv=none;
        d=google.com; s=arc-20260327;
        b=fj2ybsACjDhlveOc4xfYNKrovXxKpzYeafyNqKJMkMsrGFJqItzaGo73Y+p4xL5Fdq
         Uw8/N2+1OKBdIzj1d/B6OYeuCNiz8PheYFTDl4UJK7ENHLULkXTdVTX6t9ZH/N8IGi5p
         O0FX+hElcbZespe/aU2+jIDH2LwTv+cxes4wbGsKIWCsxN0s1YXOZRfaYdS+pI81hCGY
         Twn52tL9An4YROujaeVN8XG7yVTjvodBroNsfNBzolxftmHr2ZfOCpvMlG3UGeg6f3Wj
         UQNipsTzjKoSaK+UfI/n1jYKnY5NbwnLnWammg7clBoaqx/kypJTNlP+Y7TJyi2KAORL
         XxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JIk1A4gZRpm14rdjHpjqifL/F94df1vMYFjb/DyIcJA=;
        fh=WuBIqP2Hez+pPywfe6FZRch88jx6eh2IQHzWfc+0x+Y=;
        b=la2l2tJSVl3RjA8ez32vpKWB58PNVyXjq7p1/fdwhKjFm8YkF16/SQbpaonrWUFp8O
         iH29TakYoPoaJHxivqShKTRq/8bbBHFFS57Hzw1kOVMxrSDQXDX8wVQV+1ot6fisGgd6
         POaks3eeGopPz+9F4NT3ST5gHFggUkj8YewhOtS4T/VwSEkVwdw3BaSTIPN5K55NE8U8
         et5kusjt6YooaQY4qRIkGOmgpBXQ9AkxpydvyS5BmNEr83i7HR1Qy1/wUpd+RHh8+/gy
         NJF3jnuikflSnC+Sy9ilFCzt2xyW1kwwNfXx9GzGrEL/6duyq0ZGXiHI24S7T049nadZ
         +2vw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786537731; x=1787142531; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JIk1A4gZRpm14rdjHpjqifL/F94df1vMYFjb/DyIcJA=;
        b=mxAtUg3fAJpYe7WhIjllEqbaJfOOOA14SgEkJEwhLfqIF4o3985iXt/sD3N47metb2
         +qRCM403gUcI0qAAsF6l3dvoB4KXUlHZpM0V0bP81GrDKHEhnz35pP9Wkgbg6pwhyOh+
         kNhm768DPIaz57pLb4NbHstFyU9Uce1pKyx+1S0I9eVGssSg2OCt2XBqucqKntvOG6+Y
         1lGdChrFT4L60vcAoR65Z7wGjMn4WJArNbjGD9aPTOZFB9bRD+nxDoQ2/y6OHFbRGlaw
         PTAdhljerSECnQODz7FVmRZfRovJxnGk2lsEuhsie66HZAH2KD9ssesM/qk7o4EgdLo5
         sdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786537731; x=1787142531;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JIk1A4gZRpm14rdjHpjqifL/F94df1vMYFjb/DyIcJA=;
        b=srIiw7tVVyQdY+Vce7aK5ZuxSLcjAo5UCGCLA7uoeUjYpH+XPra6RNabAuMw1mv1JB
         zFsU26JDNxVDy/brPv2o+M5gdjYlpdqHd3yHsW9LBDchyRIeTngrr8VDSetMO6rowbxY
         /fZCGKjZJ/nBMskBoWufUquHdIZIE/yF8W6nUHHm+OmeHKZGgBmOLVCt2HSYdn2ZeI6l
         dnxkJ5RAokAw0848E595YBJjIofO/Oi7Er+N1HGeAzI2OiY4Y89mU4UXK+XaMaQH0E/9
         tfs75NqwERTJrA4ltN0a5nao6ZBNu4DJL+Kwx0XmEyaw9BRkoAveRj8LnVROkGMk7d+1
         WCtQ==
X-Gm-Message-State: AOJu0Yx0XUO5x+pTzoo7KuDJUSerS5PntH1zgGnbeIaRziOKnKDT1Wpb
	eygoaC8U4mZ8XNzS6v2f2QkEqo8LGnLnjC7PrmIGOVYO8IJXgJWOz+A+NRJBrTOgBvCyJqA2+ok
	mxzL76VPTZ877VzyjWgvLGxCgGtHQVaM=
X-Gm-Gg: AR+sD130Tiw3gVFVfgF6V8F1IbSXwhwhuAg7K4WFhQB3C8Ox3GcXd/tKhSsok2tY9s3
	Wi8EK3yGjLPxhwIBHVyJLfAARlvBAg5eOr7BwjFshRz1H1IgUJXaAvCeAQ62rBpYnqy6I1cs6pW
	SLXFzizW8seB+eziWFRZ4mzyp4thp1DKZhzV/S4obsVe+r8wU4MV2eEGi+URCFm2HT9GHQdcCvo
	VjzToCVCdEhTeGbFo3s63LcosQofsp7sgE1ruupPZwPHDGXc41EUciLChgpEaCFDvoiMlaw46eV
	RFPEMQONm7qaYOLF5C7f5ofQjqwM/7PqkO9HQG0mg8Cj7XGX84yAolK9/qBF/0vtXnR8OfjwF1v
	Dbbkky/urCc+c
X-Received: by 2002:a17:907:d11:b0:c20:23fb:bb05 with SMTP id
 a640c23a62f3a-c20f2f966d3mr228949466b.15.1786537731331; Wed, 12 Aug 2026
 05:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com> <9ac2eb18-1b8d-49b1-bbf5-757c4164c566@linux.alibaba.com>
In-Reply-To: <9ac2eb18-1b8d-49b1-bbf5-757c4164c566@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 12 Aug 2026 20:28:13 +0800
X-Gm-Features: AUfX_mwly9UlM2JZb_9ENntPXQKxUVzJW3XjZT8ZgjL6D4Csr5jW7Pc8VSrbnjo
Message-ID: <CAMgjq7CgrvwrkciM8GrjN8UB2O+HeRax_5zjvhRdpGKxhFxvXw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix and remove redundant unevictable folio handling
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, 
	Suleiman Souhlal <suleiman@google.com>, 
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Yu Zhao <yuzhao@google.com>, 
	Steven Barrett <steven@liquorix.net>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CDEF20008
X-Rspamd-Server: rspam07
X-Stat-Signature: xhk8eadj467k4ekb6xygiyb9cs1jjx9e
X-HE-Tag: 1786537733-320972
X-HE-Meta: U2FsdGVkX19rK8r5DamDZcNT2WuD4i7CcFrcbzd5yr8h1RvCyt/lke1ekRJLnal8A3CPr37n0j7qXAICv+y4fW5ZiptgIoY+uN/WZx0kW3qlUnjGisWvKLeQ6Zc8IX9tqrrp8edEf8hNsm6iplkTMjrKbMysIF/nhmtcwkL63m2pW5H6E5Bv5Qi8h2OypyB5cz236TYIu/ARp36Xlr6CmjHY2jZ/wjmKwoifZd3+ElFgTI1nkN8I1M5kQBAOewh1p5CED0uj3euag/T3iWV0bJG14Oc2lYOhxm90eTg5ilIzL9fxHLmroyouok/cJfVfNmTwAfaqX3joIDkKZCpdqpDikuGWDw9r/N4rYFb/PAPvpyWWUBalqZFJVS22x1s1PNj33ImEbCfrxopFSQamp2NHmrosoJy8+8qfqF8g2ObWDudfljWOw7SAnudUhdTCMnrfUFvXdxh8UMR+NAoRMIZJF37BXSwnEZQZrypxAVEMXgTShsM2z8d3EY3pho/Oec6xq2oupzFSTKBGrNn1F8tdDc+GdAp//qMfSDBfhNgPMh4IxnORhCdDe1KZ/u1EeWVSY8WNfQXCcY4WblKTDj1ceCtNnx+5efau/tqMOg6HIxb8N9AkbbSjrwhiuioNmF/uPsADNDR3Ylpq/3PcQPR16pMI1G3Wfd4ZID9vtbcMMlAtyNtyetkxpa+ilieYu3EWyJ683GH0SOGm3NtN8uINdEXvoPJQRo8AeKufH6pM7oBlbVA75MtFS8S035h4jE5Cw6fEMZbJ2M/vZXirn3JJpqPKa6SsznGi5WK45dZNZEYmzl2HR2c5q35G6nNppbG6V0w6gpplBMEIjqx3SqmAFE55/gyxQ9BOY9XjntbxBv/O3mY6BEr99dMGmi11g0a58O9AT5Ym5gcDvPX0VGD1ig1w+DmjydIyWamedmQ59IMBf4Z8XrYgwb5cnXR9CEy2oikQr0LyyvcSo8B
 oV7A8z/Y
 wUX8nsOS0O3RucbbVISrJ/2NDa1XxepBxPXQvCee/euci/AtM3frDM0W8TVDPd8n5sTaJQw/sMRtXha3X3ewajPBA1C32IfZgo8G0GOlCkbuucUXlwpiM9YgBtviDKl0q75jl5dx9ZTOg1trQXLl6wjIYkCL/RmxsqpJ5/Z06RKCOfT0aGhBzGvEWbts/UwoBtDO4d2bTNyGqOWKJDdEVUJOaOdJkLWj+tcJYYcaEGBVRICsOJQfS+nLgJPPPs+L54ugb/1BUfNR/NCT2leR1drEtkFcMr/v3WhuMfmVU6hT/Wg4eOkf37ielGDfzvLxXLn3fR3wIN+jGniKi1q7qav+yjyGKHAIZbFT/M1L8wy8XVt0fTVRnAYTDvJO6kAKgNwoIlactY+WLp1WQkQiNI2eYhHYtCbpJNo6sG1GNUTWNmbA34PRNL+l6/9YcUjbWSDHwdEdQ78La8AuC711onqtjFv4S1yasagI7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 6:06=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> On 8/11/26 5:40 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > sort_folio() has a shortcut for moving folios that are no longer
> > evictable but are still sitting on a generation list.  However, this
> > shortcut is buggy.  It does not follow the PG_lru usage convention,
> > and it has a more serious issue.
> >
> > Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
> > folio->lru can be reused to hold folio->mlock_count (see the comment in
> > lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them=
,
> > and every other place that turns a folio unevictable initialises
> > mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
> > __mlock_new_folio() set it to !!folio_test_mlocked(folio).
> > sort_folio() sets nothing, and the lru_gen_del_folio() right above it
> > may have already poisoned folio->lru via list_del(), so mlock_count
> > ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
> > result is user visible.  On munlock, __munlock_folio() decrements that
> > bogus count, finds it still non-zero and bails out before clearing
> > PG_mlocked, so the folio remains unevictable and the Mlocked
> > accounting stays inflated until the folio is freed.
> >
> > The shortcut also touches the LRU flags in the wrong order.  It calls
> > lru_gen_del_folio() while PG_lru is still set, so a concurrent
> > folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can succe=
ed
> > on a folio that has already been taken off the generation list, may
> > lead to unexpected behavior.  The generic path gets this right:
> > isolate_folio() clears PG_lru first, so a racing isolator loses the
> > atomic and bails.
> >
> > And the shortcut is redundant.  A folio left on the generation list is
> > picked up by isolate_folio(), shrink_folio_list() sends it to
> > activate_locked on the !folio_evictable() check, and evict_folios()
> > then hands it to folio_putback_lru(), which sets PG_unevictable and
> > counts UNEVICTABLE_PGCULLED from lru_add(), with mlock_count
> > initialised properly.
> >
> > There is no performance concern either: such a folio goes through this
> > once, and then it is off the generation lists for good, since
> > lru_gen_add_folio() refuses unevictable folios.
> >
> > So just remove the shortcut.  This consolidates unevictable handling in
> > the generic path, and makes maintenance easier.
> >
> > Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> Good catch. Make sense to me.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Hi Baolin

Thank you very mcuh for the review!

I just sent a V2 here:
https://lore.kernel.org/linux-mm/20260812-mglru-mlock-fix-v2-1-a3fec5853c08=
@tencent.com/T/#u

This is a bit different, idea is still the same but I changed the
code, since the patch is very small so it's basically a rewrite, hence
I didn't include this review by. Can you help have a look at v2 as
well?

