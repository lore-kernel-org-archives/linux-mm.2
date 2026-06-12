Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49742CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 23:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C08E6B0005; Fri, 12 Jun 2026 19:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2701C6B008A; Fri, 12 Jun 2026 19:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165766B008C; Fri, 12 Jun 2026 19:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01BBE6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:35:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77DC3164D49
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:35:43 +0000 (UTC)
X-FDA: 84872870166.06.D6F1239
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 33BBD180002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:35:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQsYgNM7;
	spf=pass (imf24.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781307341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4upJJSxjXQj+KxsSyE78cr3gya4i5tdkm8H2lvYaCQ=;
	b=dq0JShZX8Ua+5IWSbeOPkhqdd/fJqSzEEN814HaOBpXFgq16ZpxTbLqpzvTSoJAwPBOT+3
	MAuH2mNGsRwm5KJwIo0+04G0HJOj/0uysisGDfkM9fWoJnexlTAjcLR+mfQEeJDb20dfLN
	l47wb+IIGzlBs8si7I64G6ouKNRPJkk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQsYgNM7;
	spf=pass (imf24.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781307341;
	b=vmtRtUwuoL/YKIEi+QrOVh1Zwnsly+EazSAnPcalfADcXbdDQEPBqmIS5Bm+8QWOx2Ll/Y
	0o7xWnm3TmB2197GTCkkb2eo9wVkYb5JW0XMvMwlWEnw+lpDPhGA/g94UCZul8xJ09RHLi
	VKFnWleNDeCmzpP2SElIBhX+vC7rzQk=
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39677114c7bso1904951fa.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:35:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781307339; cv=none;
        d=google.com; s=arc-20240605;
        b=CC7xonN3IDUViE49NNcF87nE44IeLyghGVxr2UbYfGpS25Uoo4Wpq38hF6T13aJ7vY
         czFFBZmiS2xj3pwoPyAnnBp/diypWgiHjZAnlfFScwsPvnbq5NbPwx6MuLRj/aSO7rzG
         tMKVKV+0S0zQIUqErVRIDYaLH73DNgPg94G8fa8sjU+8/fEUQPAX6drvMKa3cNLXVISJ
         XM72W6ll9yDvm4yAQsnchaVrIsgLW8lDsfklzlB/oHjj+yqpmJZqpnyM+pjv4r4N0k2K
         ciMIV0xghxVBWEvvh8FAY+FjoYH52N55ZzFlle0dZ6fJINHwcjkbRx5zT+CFfvh1n9q1
         ZoMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g4upJJSxjXQj+KxsSyE78cr3gya4i5tdkm8H2lvYaCQ=;
        fh=xGfhKD6X7QwUrWlf2I2BSRkfQpWZUS3ZCUrvSTEITR4=;
        b=lWLe7ArU86C7KMj1HuOug+hW4VulxeRzWRFRs/SyB3y6ss7bh2f0d7yUdKWL3HJAlx
         +olI6BkuO1hsugVRcSOSIeBi3fnPZ2Cdl5u7e8i+UuWGu83ALwi1I4iTPw2/8pCLVboC
         4zauLG4ULUbx58pDttGpHalq6Sx1DoEbOc7R3pHzPqDjVfyN8yS1r28jSlTnhzEm2pdu
         NaNbrXYAIAnlLPq2MtGkdiDYC2duwjPRn+44xCvtbarXRgLh+zUbnUk/Srjef1HIYwtN
         oCqYrb1XbidVxHRGKeOEWxHtbJzHvq0UWM5rnJdHHODH8txLjmuamX/GoZgem1BRtjrq
         i88Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781307339; x=1781912139; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g4upJJSxjXQj+KxsSyE78cr3gya4i5tdkm8H2lvYaCQ=;
        b=cQsYgNM7vjKCwYSdtY1O9t7aotF/DL1qkqsCcPJB74PRlh4ktRmfKEruGhEIUJOx3W
         5sFnucG1qpdgzTPuInXR0pGo8wIsfl7fa9G0wNj4ohLalMVhl4NGo/mTYtxbQx16BpvT
         oPfKjdaSqKzqA9uNu8B+AEPpJNaT33Yw0mAPa9m6u93bvixcb2runIZaMhsePAw9GPRp
         M9knsdkzexM6/K0JNe7nJFX4VfV2iRL+YfLRPBaOqLhxRfPFWntXRgr7Os95VTnXIQFO
         Rkyq+bQi3NKZhjJeuiCNmvtLcPgbOuLvtp+L6+KEhwyD10jQTGomt9UYE8yjrkDtP4pL
         hQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781307339; x=1781912139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g4upJJSxjXQj+KxsSyE78cr3gya4i5tdkm8H2lvYaCQ=;
        b=QcMDe6l3zr0CahhsbJT1oT/IU54WAL62BXSXLACJNDfI+vh1O2cChJnHrowzqK3w+I
         zaxz7coMAuThXkEkhb1wdMybXibf6hIwpQXf8l4jDMEz7066jIjFzvAOtHHcbBhHyX3v
         2/g4x0D/O9x1gUXfr773RJUxskk7GpsH8VQFPin2vTME6GfSklognHvQu2c0X8kH30k+
         fOIzhhF16odW/Sn6txycC25C7zNk2gKob5IXmyyB/BwdLeAHdZ6vvd4L89APwc9UCabz
         U915rViEfv8eZvP+xdIIFNJRsPUcjbNpuwq9Gaxh9Cm21+iu8IQdVpXYyk/5W01joJ7W
         Mnag==
X-Forwarded-Encrypted: i=1; AFNElJ83HcrFcW1JLo3gGCVbb1WHmIG6z799YLCnWDUDuqoX18JQHlWbm08FEFh6rq+gLMYff3XrwDVygA==@kvack.org
X-Gm-Message-State: AOJu0YwGf6DG+0lZYD9c8Teegi192HZ/hmFXY8EsLFpwHJQcemfdl9Gf
	sQNXyQ4ikPSsgZ6lvXEoqHlc8g65Upu/N5PYwawC51uMxLQbqIDi6rCybVjmfFOp4fFBqyYiC2F
	InD7MXRam+Cdtr2O523y8BY7jisS2moI=
X-Gm-Gg: Acq92OG/z5m+HEhM9RTg8/E8c08XDPw8eDQAQicPByyq6KnrJNUUCcpcM2PE57TKA+2
	aDCOWbFpdxLz+sTvcpDot2kxHxG4Dw++QYrWLgz+SVrETDvsrQ+SJwHAhCWzq428k8Po7vbT4MK
	ZvWagl25pTY6rBEHRps+7NBRzSzH9sanTXeEu6gT6jp0QDJBv6s3Lw+0scRuiENwz/ccDobNfAQ
	TAr245DIZoTIu5EiTL5NtCD0YFCRgF8r9QW1XhyjPjn46WNH4RfdFUyuRoS16z8XD8t4BNbS3lt
	cHKFSLHVvIM4LwOqw6k=
X-Received: by 2002:a05:651c:b10:b0:396:7fd1:f564 with SMTP id
 38308e7fff4ca-3992b01f93dmr6063041fa.3.1781307338908; Fri, 12 Jun 2026
 16:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
 <953254E6-4518-4CE1-8A41-93EFB9364413@nvidia.com> <CAGWkznG0gdAhMei4iDf98w=GfA_O0sVgtaWC9BYcnigG6RjiQA@mail.gmail.com>
 <CFE7A598-0F5E-4F67-A2C8-2B9FAEC246FA@nvidia.com>
In-Reply-To: <CFE7A598-0F5E-4F67-A2C8-2B9FAEC246FA@nvidia.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Sat, 13 Jun 2026 07:35:26 +0800
X-Gm-Features: AVVi8CdWvPcTD2SRWJ1VY331HPiWAOAgfCQXq4V9t5ddpOEixi42UgRoux8UOKM
Message-ID: <CAGWkznFKgdqZc+oj=fMeMYctWi4HauEvJ9WcWiONOd8eP8PphQ@mail.gmail.com>
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to LRU
To: Zi Yan <ziy@nvidia.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com, xiuhong.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 33BBD180002
X-Stat-Signature: wcc67b1spkcxw7mbwpk4rs8r13yj6zph
X-Rspam-User: 
X-HE-Tag: 1781307340-135220
X-HE-Meta: U2FsdGVkX19kBRxtBW3WyIjG3aEcJ8VrYeCYpzg04Qwr0dDFYwQQpAzXTnoBLY1zLOSkpFrx8Qeq8JbT6E/fwrCWz3F5B4dGS9P2uIpgBB4RB9cY1DZNhZQoMHuu9/EkTij+sCbNIEuhwKw0wkRwOiVPfGDeDCO5hRRMeUpUxdnIS6DzfON32tfKiGwD2rBk+j8ErlxPCtpoekI26YW0yUvPuYMg5TmSwCBGcTS1bYnawk4NJ51vZP3o8TL21zcu73Uzoz9+h3aB6cE3y5FYc3jsovNa1pP2JDmPkB6aH7SssyWvPf/0gImU1chF/pk4PibJt4u0ccdSTmon6wwrECfLTv/Qfyo807OdMi1ZzZ8zEV7Fm76ZvQi021SzcJc7CCNUj8x006dub8iXKloxm8gGYvouWzvql9u3AtVXA6FJklTfZ//wpfHNGlpXlChaSImkk874kbtSXiWjP+/LGQPhQdnfF2TPKHPzavz7Q4sGbiIBGe3AK98TA94avI7UfcrxeKvBg2UyzO8HZYIghIUqxmzs8wH6lxK2ZjUj/YmVgZpQQ0vkDhf9bKnUG897estvB5b84O1SjeBWd2RMdcFtoNGpBjNdIuflcARNDnjzuNkGXCazw+Di8cI2aBU98iIu2mkdbWzhZ9uUR1oXGt8L+edOZCPh6GwrNheDly52WRSFefKGYIkP9Muc090d+fnvQ1f8r+S2KL2yeC/Q7wzeTzWyeieZ6fgCOnIRYk674hVtN2Q9Pcgp8xsDRTJf8hSx3fbtbLbyKwS2HDC+oM614FJBAVODX8OQXYab4dvrOT6MrmxHhtXZB12Xdi1RaCM9dwl27kizHFmiihVePwVG6xWkDM6FTjasWh2ZjxjfE/FKLIvITXyebQsRboAkeo/YlCXk7PulIiunz5ZftVRRlUQiaHye7hzDaGKRiIiTGK+Bhf43rxQ/KC5D7kaqjrCraAYr1bP5ukE5IFA
 NgsBmhU0
 3TeGb9+myh7wHjb1OJ58r8lbyISy9NTYv7zEViN5eToIXHMF+hANoLz1GOx/K9g1ptkzJEVRkPZZ6kZC5rmySQ1PjOZkaS5pDL/R1YfsWtLjiRZN01VM4/nesXdUT9WLd01ij2WRpOyr7kHA1/BalnQxJFmVkMN20nmcVxoqDM6f5Arag7h/o9aJShlxJAQWF02DZn6XuP4jKcwU/WnqQRTq5dCeqbLFU4QutvISBQr/HnhK3oLZ5pVeKHKzgsZGAotpt3H86DS8f+O2jK3IlFRVBBkhxfzsODIFFCrRrk3BaZDOSm0seWN207NX/sX8mp3IU+khGt0BWWLO7nqducCYRS2rW4laHAqavH5YXQV8833G8kD8E2C09U0QPHd2WXfQ+tS5JqZsD1otZu+zJg4qK4GMrKLxICKMOdYVhqASyfw4lyE2cwWetgKymc4H7TwXG/jtdHremlZwy1MvbWjl3EGTAJ8jAxrE3AN2KedeVW0lPypjHkbcbl0S8czbYW5QbffS3yhtXRs/RzjBhBDu57g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 9:56=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 11 Jun 2026, at 23:14, Zhaoyang Huang wrote:
>
> > On Fri, Jun 12, 2026 at 10:46=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 11 Jun 2026, at 22:34, zhaoyang.huang wrote:
> >>
> >>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>
> >>> The kernel panics are keeping to be reported especially when the f2fs
> >>> partition get almost full. By investigation, we find that the reason =
is
> >>> one f2fs page got freed to buddy without being deleted from LRU and t=
he
> >>> root cause is the race happened in [2] which is enrolled by this comm=
it.
> >>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: r=
emove
> >>> non-uptodate folio from the page cache in move_data_block").
> >>>
> >>> There are 3 race processes in this scenario, please find below for th=
eir
> >>> main activities. However, by further investigation over the code, I
> >>> think there is a common race window for the truncated folios between
> >>> split_folio_to_order and folio_isolate_lru, where the folios lost the
> >>> refcount on page cache and remains the transient one of the split
> >>> caller, under which the folio could enter free path and compete with =
the
> >>> isolation process. This commit would like to suggest to have the foli=
os
> >>> beyond EOF stay out of LRU.
> >>>
> >>> Split:
> >>> split_folio_to_order() can split the big folio into individual pages =
and
> >>> put the resulting subpages back on the LRU.  For tail pages beyond EO=
F,
> >>> split removes them from the page cache and drops their page-cache
> >>> references.  A tail page can then remain on the LRU with PG_lru set w=
hile
> >>> holding only the split caller's temporary reference.  When
> >>> free_folio_and_swap_cache() drops that final reference, the page ente=
rs
> >>> the final folio_put() release path.
> >>>
> >>> Truncate:
> >>> The changed code in move_data_block() lets the GC path evict the tail=
-end
> >>> folio from the page cache through folio_end_dropbehind().  Once
> >>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> >>> page-cache references for all pages in the folio are dropped.  The fo=
lio
> >>> is then kept alive only by temporary external references, which allow=
s a
> >>> later split to operate on a folio whose subpages are no longer protec=
ted
> >>> by page-cache references.
> >>>
> >>> Isolate:
> >>> In parallel, folio_isolate_lru() can observe the same tail page with =
a
> >>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its=
 own
> >>> reference.  If this races with the final folio_put() from the split p=
ath,
> >>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio(=
).
> >>> The page is then freed back to the allocator while its lru links are
> >>> still present in the LRU list.  A later LRU operation on a neighborin=
g
> >>> page detects the stale link and reports list corruption.
> >>>
> >>> [1]
> >>> [   22.486082] list_del corruption. next->prev should be fffffffec10e=
0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> >>> [   22.486130] ------------[ cut here ]------------
> >>> [   22.486134] kernel BUG at lib/list_debug.c:67!
> >>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> >>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> >>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> >>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
> >>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> >>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> >>> [   22.488539] sp : ffffffc08006b830
> >>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 00000=
00000000000
> >>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffff=
ffec10e0ac0
> >>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead0=
00000000122
> >>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: fffff=
fc080061060
> >>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 00000=
00000000058
> >>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 00000=
00000000003
> >>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85=
721f0e25f00
> >>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c656=
45f7473696c
> >>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 00000=
00000000010
> >>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 00000=
0000000006d
> >>> [   22.488647] Call trace:
> >>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> >>> [   22.488661]  __folio_put+0x2bc/0x434
> >>> [   22.488670]  folio_put+0x28/0x58
> >>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> >>> [   22.488689]  f2fs_gc+0x230/0x9b4
> >>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> >>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> >>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> >>> [   22.488725]  invoke_syscall+0x58/0xe4
> >>> [   22.488732]  do_el0_svc+0x48/0xdc
> >>> [   22.488739]  el0_svc+0x3c/0x98
> >>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> >>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> >>>
> >>> [2]
> >>> *F: big folio before split
> >>> *T: tail folio after split
> >>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2=
 (folio_isolate_lru)
> >>> *F: pagecache refs =3D n
> >>> *F: extra refs =3D split
> >>> *F: PG_lru set, mapping !=3D NULL
> >>>                             split_folio_to_order(F)
> >>>                               folio_ref_freeze(F, 1)
> >>>                               ...
> >>>                               lru_add_split_folio(T)
> >>>                                 list_add_tail(&T->lru, &F->lru)
> >>>                                 folio_set_lru(T)
> >>>                                 folio_unlock(T)
> >>>                               /* T PageLRU set */
> >>>
> >>> *T: pagecache refs =3D 1
> >>> *T: extra refs =3D GC + split
> >>> *T: PG_lru set, mapping !=3D NULL
> >>>
> >>> move_data_block()
> >>> folio =3D f2fs_grab_cache_folio(T)
> >>> ...
> >>> __folio_set_dropbehind(T)
> >>> folio_unlock(T)
> >>> folio_end_dropbehind(T)
> >>>   folio_unmap_invalidate(T)
> >>>     __filemap_remove_folio(T)
> >>>     folio_put_refs(T, 1)
> >>> folio_put(T)
> >>>
> >>> *T: pagecache refs =3D 0
> >>> *T: extra refs =3D split
> >>> *T: PG_lru set, mapping =3D=3D NULL
> >>>                             free_folio_and_swap_cache(T)
> >>>                               folio_put_testzero(T)
> >>>                                 /* refcount: 1 -> 0 */
> >>>
> >>> *T: pagecache refs =3D 0
> >>> *T: extra refs =3D isolate
> >>> *T: PG_lru set, mapping =3D=3D NULL
> >>>                                                                   fol=
io_isolate_lru(T)
> >>>                                                                     f=
olio_test_clear_lru(T)
> >>>                                 __folio_put(T)
> >>>                                   __page_cache_release(T)
> >>>                                     folio_test_lru(T) =3D=3D false
> >>>                                     /* skip lruvec_del_folio(T) */
> >>>                                   free_frozen_pages(T)
> >>>                                                                   fol=
io_get(T)
> >>>                                                                   lru=
vec_del_folio(T)
> >>> later:
> >>>   list_del(adjacent->lru)
> >>>     next =3D=3D &T->lru
> >>>     next->prev =3D=3D LIST_POISON / PCP freelist
> >>>     BUG
> >>>
> >>> Assisted-by: Cursor:claude-opus-4-8
> >>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>> ---
> >>> patchv2: update codes to eliminate bad page status
> >>
> >> Please do not send a new version until we figure out the actual issue.
> >> And this version still has other issues, like unbalancing LRU counters=
.
> > ok, I just think nobody would respond to my latest feedback and want
> > to fix the bad page status.
>
> Please be patient. Wait for several days if not a week.
>
> >
> > I would like to explain more about the current scenario by taking
> > below codes as examples. move_folios_to_lru have the folio be set with
>
> Before you continue to point fingers to different code, please clarify
> the context for this issue:
>
> 1. In first paragraph, you said the issue is solved by reverting
> commit 9609dd704725, why do you think the issue comes from MM code?
1. I can't find the reason why 9609dd704725 could be broken.
2. The suspicious pages continue with each other and also has PCP list
be involved which make me feel like race condition.
>
> 2. You mentioned that the issue is from AOSP with v6.18 kernel, is
> your patch targeting v6.18? Is it reproducible on upstream kernel?
No, the patch is targeting the mainline. I don't have upstreaming
environment to reproduce.
>
> 3. Can you provide your kernel configuration file?
Sorry, I can't right now for security reasons.
>
> 4. Can you share a reproducer program for debugging?
Sorry, I can't right now as it is reproduced depending on gc which
requires a full f2fs partition
>
> Thanks.
>
> > PG_lru before calling folio_put_testzero to ensure there is no
> > free_page without holding lruvec_lock, which is similar to this case.
> > free_folio_and_swap_cache within __folio_split has no synchronization
> > method with folio_isolate_lru which makes the bug happen, right?
> >
> > static unsigned int move_folios_to_lru(struct lruvec *lruvec,
> > struct list_head *list)
> > {
> > ...
> > /*
> > * The folio_set_lru needs to be kept here for list integrity.
> > * Otherwise:
> > *   #0 move_folios_to_lru             #1 release_pages
> > *   if (!folio_put_testzero())
> > *      if (folio_put_testzero())
> > *        !lru //skip lru_lock
> > *     folio_set_lru()
> > *     list_add(&folio->lru,)
> > *                                        list_add(&folio->lru,)
> > */
> > folio_set_lru(folio);
> >
> > if (unlikely(folio_put_testzero(folio))) {
> > __folio_clear_lru_flags(folio);
> >
> >
> >>
> >>> ---
> >>> ---
> >>>  mm/huge_memory.c | 22 +++++++++++++++++++++-
> >>>  1 file changed, 21 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>> index 970e077019b7..c24c12f71157 100644
> >>> --- a/mm/huge_memory.c
> >>> +++ b/mm/huge_memory.c
> >>> @@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(cons=
t struct folio *folio)
> >>>       return folio_nr_pages(folio);
> >>>  }
> >>>
> >>> +static void clear_dropped_split_folio_lru_flags(struct folio *folio)
> >>> +{
> >>> +     /*
> >>> +      * __split_folio_to_order() clones these LRU state bits from th=
e
> >>> +      * original folio.  A folio that is dropped instead of being ad=
ded to
> >>> +      * the LRU will not pass through lruvec_del_folio() and
> >>> +      * __folio_clear_lru_flags(), so clear the cloned state before =
it is
> >>> +      * freed back to the page allocator.
> >>> +      */
> >>> +     set_mask_bits(&folio->flags.f,
> >>> +                   (1UL << PG_referenced) | (1UL << PG_active) |
> >>> +                           (1UL << PG_workingset) |
> >>> +                           (1UL << PG_unevictable) | __PG_MLOCKED |
> >>> +                           LRU_GEN_MASK | LRU_REFS_MASK,
> >>> +                   0);
> >>> +}
> >>> +
> >>>  static int __folio_freeze_and_split_unmapped(struct folio *folio, un=
signed int new_order,
> >>>                                            struct page *split_at, str=
uct xa_state *xas,
> >>>                                            struct address_space *mapp=
ing, bool do_lru,
> >>> @@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(st=
ruct folio *folio, unsigned int n
> >>>               for (new_folio =3D folio_next(folio); new_folio !=3D en=
d_folio;
> >>>                    new_folio =3D next) {
> >>>                       unsigned long nr_pages =3D folio_nr_pages(new_f=
olio);
> >>> +                     bool drop =3D mapping && new_folio->index >=3D =
end;
> >>>
> >>>                       next =3D folio_next(new_folio);
> >>>
> >>> @@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(st=
ruct folio *folio, unsigned int n
> >>>                       folio_ref_unfreeze(new_folio,
> >>>                                          folio_cache_ref_count(new_fo=
lio) + 1);
> >>>
> >>> -                     if (do_lru)
> >>> +                     if (drop)
> >>> +                             clear_dropped_split_folio_lru_flags(new=
_folio);
> >>> +                     else if (do_lru)
> >>>                               lru_add_split_folio(folio, new_folio, l=
ruvec, list);
> >>>
> >>>                       /*
> >>> --
> >>> 2.25.1
> >>
> >>
> >> --
> >> Best Regards,
> >> Yan, Zi
>
>
> Best Regards,
> Yan, Zi

