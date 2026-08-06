Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DDCC56207
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5556C6B007B; Thu,  6 Aug 2026 10:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506726B0088; Thu,  6 Aug 2026 10:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BD26B008A; Thu,  6 Aug 2026 10:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 104296B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:42:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CF031A079B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:42:13 +0000 (UTC)
X-FDA: 85071109746.27.522AFA9
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA602A0012
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:42:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+M27qnJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786027331;
	b=FSfMEw/+Ar+XYA3qNYojnU/rKIP5jAJa03uDbXZm5vb9vmrv8OeT00xKUrnmZAWfnkwNPT
	Z7zFKcMOqmxSo0VAdSJGZIdbu8p1PvaZbAqEWD+z2G4xM55NMyW+T8BT/6JvLiKiqGYgMO
	FnxtQYnx/A4GYA5L1kZghb+E3Y0qC8Q=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+M27qnJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786027331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rk175A1VzOhYd+ZvXWeOt/44h2PSKZpjHj/8UOjVH1E=;
	b=f3iwqcXMFurrEEZ3TB1SX7TeWhIyzOLmkmuDDfOc5xKElLr9UAl+NgRXtLNzn42M3D2O4L
	2/pAoH9rlcFNJZibN/0MiQEu1QedLY77hUwX+3nwXxOM9oDaqkWB847kx6YoC5lJbYx+ld
	TG0Zv1Cz9GfqjkBvJlIUSKl5z18BkXs=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-80dc4a68e4aso26120767b3.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 07:42:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786027331; cv=none;
        d=google.com; s=arc-20260327;
        b=LfGMSuGF+Me/LD1QdeVQ5bIgJXAp9GMT1Mr1U8NCkwAQDtVugoVrRCJLerLXF3/Ri1
         yIXklPH6pY7dYYQl0RfTeAUF6NPaFwhAI1PBEzEolu8b0KjcwvEX2ndJUP/TrhOE8tja
         rgvrjaiNe90qMh3WVyQVMNGKAAmKDvYkQydQYI3idEQWE3ncN3F/U2C3gI4CfER1NEqY
         ttutHppcENrqFPjoPjbXJKsJ6C4gibj+bfx93ThqUVvQdl9wtlroJyyKKOAzYmTDtKMy
         iTj+HnrJ5lACvI5I2+ue9a8zgQnD0Opq370uDpSt0nKYlGfGzVIkBPcDt3kz1jSihcOd
         PaXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rk175A1VzOhYd+ZvXWeOt/44h2PSKZpjHj/8UOjVH1E=;
        fh=OqhKqTav+PlW9YvVCYvbyqcUsmLdjJhtAUw7RGpfLlE=;
        b=MX3fe/+4Ja0ORqo0Y3iTnuhZBS/P76UeUnPHxa+vKM6NOrhnGFu8ju1U9Y4qIeUAYe
         tVtmUsr8h9sLsGNlHbEA/mIaxfQz1yLoEqJY9S0+evRgBQXJcxJ0yiWXmm8JVQsQxOow
         lBFbxdP1NyLS7UeLHJtyVzi3/7T/p5meQQa8ir6pApteGwcTuk864YKhp5sHjYxfgySG
         69bw1rZqTArqdrSuvMc7ED3N0GBbmRZItpt+v0J86WDn70g3m0KpeZiRCuUI4jnWr12S
         OXlJnKUbTO/A6KXiQgIfu15l0oUZnZUrMUYtAevwuiYuW3Ma1jCKCOZJf456EXi7VHAQ
         9qDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786027331; x=1786632131; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rk175A1VzOhYd+ZvXWeOt/44h2PSKZpjHj/8UOjVH1E=;
        b=n+M27qnJ2d+tjbed77aJIOXW4Pj0BplnSQEQucxwkv0DYVJ/+RgnljbY25dmNftPY/
         qcPzQIjxcgcCeveRSGgrRnelW9xMNRbSDUD0SLFnQe0Z5N/xQsFWHVwymB7huxyUuxxA
         b4UwM24W8KRz/bHJippVmcRmOFCWWrOp2vD4PTKd0Xz7G+77c5dq8nC0AzxfjuFTNOlb
         +ueeiXQmu9esoFAi9AFXioQV2Z/AF4ck+h40kQepmDhIKSwqXec+sd2hoGJ8Lx7JIPsa
         QQZriAUie4kCRoJmNRhH0jWzfZFibV0H/eyvxWnFcVX12q0VY21McqYxKPwAbm8QJOQR
         a6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027331; x=1786632131;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rk175A1VzOhYd+ZvXWeOt/44h2PSKZpjHj/8UOjVH1E=;
        b=O+43WgcxpeDPeZ8naD8Q3cO3Dwuk5huElqi/IWSr3UV5SecmnJwZAsaljkbC+kUvoS
         EfOzt3YHweWAWq7Jxzf2pL4C8R1xKodx6cernV+rc22tP76CtyFc8b8Uqavrg96GPDo5
         xmiMfWRIX5MXywFmyNl61Hjw24UY8XVH+mj80xU+ifvmzhgQhIEHiD6bFZhCniDZHPhW
         4grHXsOetE+v1jqEtSEvVkcVtjBUr8wKOsSK9/WEQwSov6QtZk/ZpHyLlJ0lhWj/gSZj
         FqTKABE9ACoR8Vhi9vGDsNj2BGFXYv/cEOG+cMvM5GDbsYH3D89gFG+82lWCh04iVM7h
         ctOA==
X-Forwarded-Encrypted: i=1; AHgh+RpVcisKA+QK1eISGOoAV29wGYvYxnyb3Jw3znBQMfHbWWoN0bHdeyEshQKSc0vmqyf3d8F3jlWjog==@kvack.org
X-Gm-Message-State: AOJu0Yxm1nGdmfvMjJw7Dd5hCTV26wNBJGlBBOekv5fNIRZSMm8xG/tN
	Pss8TTeDcdkDI5LGiCxCIcgMoKUKVH3mljO3MhMG3bVKMBYjcaxIR7IvKtdMKQ1q9RzW8gw4bST
	u2QCzWu4Onx20rP0SEFQ1gCSgOyFT/Pc=
X-Gm-Gg: AR+sD105xP1ppcWKo7Lgrj38x4v261gMQLeiqkyiT9OB9uUdMOQlH4Kh2u8eQcwOm9G
	kgisOuaWvKxFMdxbYlXvt7y0o/X5kFigFbZGqVmsS54RiNGcGkgPwCfQVcA0nfbdszpDgoE8RuF
	CL/d0lj4+SFyCMD7Eh1H7qe5raeO1oLXeoAfqcIsdE0XoSgb6wlYIxIEEb6srtMpzskt+Bcvd4c
	VPnW0docm4BDEd81CMsFwvZLzUfA6brfzBSR5YX1Z6Jw2o96K6rpCC5XnVCJgwYr5ooA4lsM4OY
	iHfrwhdimzQBKK5PRr/I6vXtK5pB+OdNDbLtbx3X2A==
X-Received: by 2002:a05:690c:3:b0:7ff:1a06:472 with SMTP id
 00721157ae682-8201f0c14camr93301377b3.4.1786027330666; Thu, 06 Aug 2026
 07:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260804144803.3290255-1-ekffu200098@gmail.com>
In-Reply-To: <20260804144803.3290255-1-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 6 Aug 2026 23:41:59 +0900
X-Gm-Features: AUfX_mwkW6Yar02BfLMwTDwkxooPEuR25S_dmVd-PAuIgqBnNQ7B0lAuRmiubXI
Message-ID: <CABFDxMEdqBHRNXyHvT60tcqLhCeq_cRCgvpdVOwGTH0_SvVadg@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm/mm_init: simplify zone_spanned_pages_in_node()
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA602A0012
X-Stat-Signature: 4geu3r6fxe4r4rtwqixm3yrwcjzfba5s
X-Rspam-User: 
X-HE-Tag: 1786027331-835875
X-HE-Meta: U2FsdGVkX1+ir2konxlhj90ljIlfhUC0+8pP8ubNll84xXiRtwa6D+M8UtfUjmz9f0Q+zOwQ3ydpxgG9UbfEsYbXfL4g81iqyBcujBPsFaDuAB7MM6zB1wHB7KVnt5+WACHqD6X6D2AKV8hjEwKidFhaiD0DLARWPvistT6Y5O8z1Vly56XMg5UlQHBVktoROF4WahRCVdEulSF/dzJdTd9b19vFAz3cu89Mf0rfh79k8UcmAHTt1b91BuJbBqbKHU5wgN1jRPAdkRXN/rpZpVJFagHvROtK8w5x3ybgUpm02EgC5usHxlfmQxrqgah/9wDRcJdcieSQRaKGklGSNnrNTrdCmKFMTkdz+z+BHsB2WxUDCq5P6r0smVA3EPoq40W62zWuuQf7LMEMwfWqf8S69SONmbTHUzbgO73kEpZ+VlfvfUKONFmBzvkO5BkuYJKcDAgdzChPPzyCjpYIwEtK+mcPgALfy+c6CHuRkR/4WvqDL5CCRral8Tw4ghO0xAb1bWdCwhaLgNs69w0YC0fppug6VD9/Q0CswU7B/EZ2iP/hLDhu9ASCKA46U7Fb9ES3prfQ0crD0RyGf3P/8OxnOypLw/em+7VT2CnMcl1Px+nyPCP02xg16yJOwcsQ9ecWFktySTwW7g6zC9NWwOqbUHLk24DVxatn1F988OGe0CyOj6JfZG4LWR3EUIMIMb6QyjsxGFQONl8/lMBPeIJwHnj1Mnkw+WPMF0D2bwuphdgzFft6R6ujOM28mIioEuscLzUXhoW3X1t0+wGVmt7xEJyNcMKN2TMmonCgd7Wi2dXiN4EzZmMMXJFyFsGQJUFQY9ULzvO/Adp1m8uNjycjT9MUAq77g6zqawnS9J9Y9p4sMgHOhBdoeIyazXxGA+0ENAzRVeJnjVJSGSKblUAiBspn5ScZzMkUzP8ARi6eJ6p3c9LjyVD3gYlQO0J+9qDibj8vj8lJRYHoYCf
 pn0qFlWv
 LkPihUuIvu9CA2iYXnNST6Y5XP/ZtfSmmF8hHObBiEjayHAmMtF5yo8twQmsYH78yniYBNCzqQXYNeXiVg49DfOUjff+B2JAdn3rkUISjFXScbrq9lxeSUqXKFkMwwHOh9xmjmOqRP87SJepNWoEeh5nFQDRw76mdaa2FGzfpkyFQ+ia1RVUK+mnglBvAgW5ptNz/tWe6dsAzFa0x8MDFr+B0wCB+5eG8oHRQJdHpUtpYhj/3DiGaFhoUrFSpjJyyfCWqFbvmEwdKx03sJXLIVEzfXoMkxvYempZiCf8gMq6WHqu+8LUExVPb74n5yDSDVAUKDT8hobe2rl1w+EOuk1IwCmZnm/mDial+CbK2aSPw2ZjMrgYGg4SKUXiASk2pxIUShHNuzLVJD7CFmH4EF8PJBwn44g06MphD/tMlGtTLlEQDqJx5jAlPao8UEZ/x9x88HbxqKp+cy41WvYrH/DESfXqcJYukmLi7vYfyY1UJUGmwk9vwomLXpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 11:48=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> Hello,
>
> This series simplifies zone_spanned_pages_in_node(), which adjusts
> *zone_start_pfn and *zone_end_pfn before and after calling
> adjust_zone_range_for_zone_movable(). The helper adjusts the same two
> values, which makes the code harder to follow.
>
> Split into four patches for easier review. Squashing them into one
> patch when applying is also fine.
>
> Patch 1 folds adjust_zone_range_for_zone_movable() into the caller.
>
> Patch 2 removes the clamping to node_end_pfn, which has no effect.
>
> Patch 3 moves the check and the clamping to node_start_pfn into the
> ZONE_MOVABLE branch, which is the only place they have an effect.
>
> Patch 4 extracts a local variable and reduces the indentation level.
>
> No functional change.
>
> Sang-Heon Jeon (4):
>   mm/mm_init: fold adjust_zone_range_for_zone_movable() into its sole
>     caller
>   mm/mm_init: remove redundant clamping in zone_spanned_pages_in_node()
>   mm/mm_init: move the range check and clamping inside ZONE_MOVABLE
>     branch
>   mm/mm_init: clean up zone_spanned_pages_in_node()

A series changing the kernelcore=3Dmirror behavior [1] has already been
merged into memblock/for-next. I'll rebase and send v2.

[1] https://lore.kernel.org/all/20260630072212.624305-1-rppt@kernel.org/

>  mm/mm_init.c | 81 ++++++++++++++++++++++++----------------------------
>  1 file changed, 37 insertions(+), 44 deletions(-)
>
> --
> 2.43.0
>

