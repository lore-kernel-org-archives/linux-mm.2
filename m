Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED26C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DFB56B00FA; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2400F6B00F9; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090246B00FA; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC1D96B00F6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67C771A01E8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:49:41 +0000 (UTC)
X-FDA: 84984188562.23.9E953D8
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F246100003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:49:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tPm+nWPD;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kjXkxaArn2amA2QIiRqCeGoYfIXMvqGUNcKcx37v/Y=;
	b=t068Nd0KB46rh6BUpNa6IN/XRkbXcCy2jGE/OU0BiNnBKwB1szje2PxIRConODmwZDttBq
	2+ZmJbZk5cO8FgbG+QYIWGSzrRQPa7BENl7q2XuWifETYahYyUKJZAn2lrgbqxQ1aP5kV9
	UELBM6AWdDgP/fKNiiBscYJgTZ5BJKU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tPm+nWPD;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783957779;
	b=p13fnfrcKhakyuTa3XNOa8IDOcgVaPPWhKlhx2tk+Ob32Dr6r54NZ5nu3Qotvym6J/xSPB
	hCaP0STTpUtl8kk2uKKvH4DC3mR7fo4zhkYh18hI8nmCL4g9H1Yth31h1MlUts7joGLvus
	gD4bjfcP4BXhj8VW/PsYtMn1uySzYnk=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ce9e39fccbso119775ad.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783957778; cv=none;
        d=google.com; s=arc-20260327;
        b=WLWUVArYucsbfri+e85PYaSLEsTbfeJdZm4HEXTI0Qt/i/f1H2mABNfLmB/wC2Io3R
         hWTcDA7WEXf//CbuV3X/4HkgD8FhBwPDkfyysUG/el6mnJFRd4avbA4SkyVpratNegLc
         bRNv/nM8nklYCBR1bYkUPBSaanBCd437UX/wGp9otIQu3VNYOMvmxs+n7izvgaiFunfj
         gheIAQvO2ne2ax8QdfxZdG/crUiJbm+6hIQ040W1YiDK5aRMEi3eNmvQsbbyX5y4XBRl
         2VB60sp62eJYOiYxylZ3VZkiouVp8YE1G9NAW6qC3F9lDaCeh11yjAunwSqYe5nXGnCW
         aZcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=2kjXkxaArn2amA2QIiRqCeGoYfIXMvqGUNcKcx37v/Y=;
        fh=I41O4u5d/uiW3YUfRinS5WIyfMa2A/JOSxoOukvOCKI=;
        b=dGnAUOkW4QLUeSzGRpf8QnoSJicnLzeoALhdIka+Q51oaxRpoDliFlRIeQmSoFQt3r
         MaMd3HW7jqkTbg5Ew7+wVT2trbK9YWmK/1visrrvwX1+PELYdSdq3QMRjoE2oRdvflpJ
         Iewp5s7OMLBBEvHt9XYZl9ms0gL4zPhBymISi0HnDws26PoJshabubxoLNCCd7ZuXCel
         /HHdQcWrSiKgkO9ZcDZV1sGoSNxJnOU0fbJi4ClxCjgbAABfwFlcU/WWN/V14welveGX
         Lby+S9Wxw7Cw1YiRf+YhWBDwKDUCen67+iRxrjnKyjDiMSz6IAnSdw7y4HqVFC/5+u8l
         YTKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783957778; x=1784562578; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2kjXkxaArn2amA2QIiRqCeGoYfIXMvqGUNcKcx37v/Y=;
        b=tPm+nWPDgCMqObB0x28A0ec14jqPrUZS64x9EM7tjp8Id9YdZA0WoAH04jFW9XToI5
         onPvwP+dU31G9d7ElZhW8VF/4gpdBlJCfMPTaJiYFs29nybTA35bDj9jX68PjntN6uH9
         NmRjbrETv+qu8kSy8xNkXlDHkLFC6QkdYKybb/LIBWn7XP0YYgAm4vFnouIiTtnd7Ovl
         9o5s11jbn+uwj9rTmnapCK2EzaRwzHQ05z1aXMAfpXj2qNJlmAYYog2UHldTdMtljTNC
         xIYxXfBBepwvWtvd4rp3Ceo6hdkRdu3b7v7bl55QMUvj7j+T4UxEDr8lBuadCIr4hl8P
         hFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783957778; x=1784562578;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2kjXkxaArn2amA2QIiRqCeGoYfIXMvqGUNcKcx37v/Y=;
        b=KEkefkxRzV+ZoLnMRgapnzcWaZJcqXfhwg3CwPLjU2v9YilVrxqV8VFwXdElPsvGJ1
         Gxjlc/pbPaoXpci1wSpBt+j2v3xTXXg+6mQROkzDz72HzqAmZhRRzJfYWS63Y3DbXISg
         PX1mDoPyuBUi4LCL/z0HkGbkxXFXZ9MYFnrFpZyb4JqXst20+B84Z0nNxRzEEQuwP5sQ
         w+OJQIcbTnXMbIunyYwrGt1yel6lZrb72jva3QLBuw0rX4K1bjgiQQt2km93FnH8VMRS
         3tCiDqjvj5ez4gCbnyfTW1vbYlC476rs44YLpqb7j2poc4kAdW25f8HYYfnhBijrOOCT
         f6GA==
X-Forwarded-Encrypted: i=1; AHgh+RpO48H7uIqtU39Imb0UguvO5JQEl1SGjwQOEda+xof+RlGZh29skbnoA4UWrkK5FA42RSW6IMYHNw==@kvack.org
X-Gm-Message-State: AOJu0YyBZ8ahqvuNSMKVA9BhevGbw6wy992MKezyJCHPupKEOwDPXmfV
	OCDvMrSfxbAThTRc2XdJfkKGl5VsPxjqoayUfRY8qW6TyRsXRGEyeZYMaZ18/IjAMmn0ht58pF0
	P0TkVgPL0hP6t9L5GQkoi8w7U/LG8DwEjlxOUV7ro
X-Gm-Gg: AfdE7ckk6qi0+Pd2pnmGw+Km2/P8/UqJPAPy0W8UFD8BL+Z2vUCuZM9Vtj0GyanGvJV
	TsePc6OYfRfWmh3C1Vi1l/lC99q96KNp3Gz2p6EM6hRVbDJpZAJ4wBfLW36OqCio7oCpc0QvYIy
	UGh+hlnEVj+8Up+JziRdT+iejI95QS1OPUa4PWcHQ4886/0Die8i99Raegds8mgGQE9ajkIwV8p
	HHBHreWfB9VIFOotOo1pOHf45M3Gz0Fn2a2EgTccwx+qiWNq+133/Z3LhHzrYAOn8nNvBslguAw
	Sw8sO4XXhoHSDyiz70SmBsm9crz9JfzBKfIuc98INZjpgM6AAsTN8ULP3zXExYofqm1T
X-Received: by 2002:a17:902:f60f:b0:2cb:402:70cc with SMTP id
 d9443c01a7336-2ce82988044mr131703855ad.28.1783957777649; Mon, 13 Jul 2026
 08:49:37 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 13 Jul 2026 08:49:36 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 13 Jul 2026 08:49:36 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260713144557.3845941-1-joshua.hahnjy@gmail.com>
References: <20260713144557.3845941-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Mon, 13 Jul 2026 08:49:36 -0700
X-Gm-Features: AVVi8Cdh7Zm2xz6VvnNu7YZe_vlQ0EdMypGL7cnWYZk8YXXL9XNBTQclMKF_wMY
Message-ID: <CAEvNRgHMsva75JcJBEw2UdmNwAvKOZb44w0-Z_dq14D8QT2LAQ@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: restore failed global reservations to subpool
 in alloc_hugetlb_folio
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Song Hu <husong@kylinos.cn>
Cc: Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Zhao Li <enderaoelyther@gmail.com>, David Carlier <devnexen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F246100003
X-Stat-Signature: ijqrxsgzjnbdkey48qot7ts854jp5jja
X-Rspam-User: 
X-HE-Tag: 1783957779-254169
X-HE-Meta: U2FsdGVkX18vx19TnR4McPcLZX5qJpBrBCDLJyMH0eYagZhGz6t8cyrjUKQ8akFIMVSbUGJDfDATp0uYh6IPJhskE3sTBQnzL+ymos4Yp02DpyAwvrJrzgw5uiIEcaP3D04PLeFJ1Pz29p/nOmrpcVwjnk6Pz5ukqbGnQnmDvgb06jQsOtYGbLB/4370JxKiEq3RG/QxcL0PttZLX7PfeU27juG1HoGHrS2bh46gYhentsMupurh+jsrmdGzNFcyEXk0yhQvMXKRtFc94pwm5PLpXCzR968G7RAsbiKe7M5ijp0oUvpb4C4uRvvuYBRHw+HPDvBN1S22fw7Ol4mUADB7QLL5znNzV8yq9VfcUovcO4RaKhISz24/ZnjgxeR3JyjLxJIuqrwK0QLX/ILNjHhBnAo4P+3ceyXOEYx3nl/9JeLmkVt8F3H0Ph5M48yUc/GPgP4xOdizwS5di0D2YEwrKI094mNcchyIQ44ACD13eQqrHQ0EaWFaphBEYP3ZAf5/eLAAUFZs+vDvA5jnH0ux0NLMMSG+BIeBOo1eNhneB/std6iDKOaBzGYWvTIvE05zeYqa2CXMLO0HLvu02DokP7P7ng+hqL+/nxCmCN39+BPp64UfaXvj4UPtcsx/iLvnRRCjNZP/fsei+OAslyaykk9XRGMZkNVgxN7aMWAzRlMwkt5/hXONKDu8iZqm8c59sja5q6RiVtzGb7DUyY8O9NFCvhmvl8QtiFerFjxavbWAH9tnoS1ArPaq0o8qQCRgl6NhhSPi3zXvakbWe1QZPlim3GhbiVwWR47DnIBQ+RU0XDYdAsSq9KxmCHgGkgw3OAgfWWnbh4U1jYLuJ/z7K6If1VZgjesjwjQex6Ctu3lnybiP8mg+9CgKaXuWsMLd30z9jsL3++tQvxo+KrhxA8VyBco2h0QY1B78Q3ziA/VUjgE8Q6Mvtxf3nN5mv8JppmYzncgYntRD2/d
 Eo7KRdpM
 v3F6yzxTalBJYueJcs+BK1LPfhkDVXN4S5q1kaCC7/53HaaV/Pxu/Ef/C/XRPnc50N2kexEFOwac7hAb2mNZr2STI7HTwFxc+2mqy8rRFQrnus6trVtjk0TMz/IDNwewMMZZOKUuTjzEgc6PBOqgfGhULc/ZjXYjgHM/0wH378aGszlgKi3hluKB6gYZbB7fpB0NJE6WQJUM5gQzVfJuMO/TPbSH+1wc3gPTeAZjeOAmYdACWcHep+9+VLBZDsrBPZyyBdIEfMcGpro9sMXFiSmWfSaTib0ybDRcyUt7ctVjqAlQvIn4fn1kWREKUcBbIyQHfZzv3fciScs9b4gkoFNLnc7qiU9ZF8GM4BDRFCUqndyymcOas7SIYrwBettDX2Y062e8kT1bwVTw5OHrY/gyZf3yhT0MHmjX26WUTV6ndlvv3+vOc6Yv9khU0LtzPt7gX1PM33XAFV64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Mon, 13 Jul 2026 19:50:08 +0800 Song Hu <husong@kylinos.cn> wrote:
>
> Hi Song, thank you for the patch.
>
>> When hugetlb_alloc_folio() fails, alloc_hugetlb_folio() only rolls back
>> spool->used_hpages in the out_subpool_put path when gbl_chg == 0. For
>> gbl_chg > 0 (e.g. a size= hugetlbfs mount), hugepage_subpool_get_pages()
>> has already incremented used_hpages, but the error path skips the
>> rollback, so each failed fault permanently leaks one used_hpage until
>> the subpool is exhausted and hugepage_subpool_get_pages() itself fails.
>>
>> Decrement used_hpages for the gbl_chg > 0 case too, mirroring the
>> hugetlb_reserve_pages() fix.
>
> So something is clearly wrong with this codepath here; there are now 4
> competing fixes in the mailing list currently being discussed [1] [2] [3]
> including this one and they all do things slightly differently.
> Let's please agree on what the correct solution is,
> I've CC-ed the authors of those 3 other solutions to discuss here.
>

Thanks for connecting us!

I'd like to make a pitch for centralizing the fix into the subpool [1]
:) I think it will also let us clean up the existing codepaths where
each path does its own open-coding and reaching into the subpool. Also,
if that cleanup is centralized into the subpool, we might be able to
track availability instead of reservations [4], which I think simplifies
HugeTLB reservations and removes some possible races (for keeping
rsv_hpages and resv_huge_pages in sync) completely.

[4] https://lore.kernel.org/all/CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com/

I understand the above solution is a deeper change, does anyone have any
thoughts on the approach, or existing tests other than libhugetlbfs and
tools/testing/selftests/mm/ksft_hugetlb.sh (which pass) that I could use
to prove this works?

>> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  mm/hugetlb.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index d6c812d1857b..8413ec92d836 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3073,6 +3073,19 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>>  	if (map_chg && !gbl_chg) {
>>  		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
>>  		hugetlb_acct_memory(h, -gbl_reserve);
>> +	} else if (map_chg && gbl_chg > 0 && spool) {
>> +		/*
>> +		 * Restore used_hpages for the globally-requested page that
>> +		 * hugepage_subpool_get_pages() counted against the subpool's
>> +		 * maximum, but which we failed to back from the global pool.
>> +		 * Mirrors the fix in hugetlb_reserve_pages() (1d3f9bb4c8af).
>> +		 */
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&spool->lock, flags);
>> +		if (spool->max_hpages != -1)
>> +			spool->used_hpages -= gbl_chg;
>> +		unlock_or_release_subpool(spool, flags);
>
> Why are we unlocking or releasing the subpool here?
>
>>  	}
>>
>>  out_end_reservation:
>> --
>> 2.43.0
>
> Thanks again for the patch,
> Joshua
>
> [1] https://lore.kernel.org/all/20260708-hugetlb-alloc-failure-fixes-v2-2-c7f27cbb462b@google.com/
> [2] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
> [3] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/

