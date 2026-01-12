Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5095C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18A06B009E; Mon, 12 Jan 2026 11:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9B36B00A0; Mon, 12 Jan 2026 11:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13C36B00A3; Mon, 12 Jan 2026 11:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C23046B009E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:17:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86E7D8C25D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:17:19 +0000 (UTC)
X-FDA: 84323816598.11.3D42FC7
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id A06624000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:17:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IFUnhZdG;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768234637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vqb4Hn5493L1mZt0rxFOjY5Siy0ns6XDE52wWf3HhJM=;
	b=OJGETPI+vc8DH2y5EkvwbhOVTcVXjUb610hB/f3U4GBKIHZXXv4hASdkFgDD2TXk21UNQO
	hE5ksjQwUf7Mr8fVUBZslTWOEA7xCB8Z2txucxbuQeRk7RvORUCFwXze/5L4km+1ZGiehb
	0eIXnxqJDCJ42AJukWdAonxzLOz8+/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768234637; a=rsa-sha256;
	cv=none;
	b=l3qLqjnc7FjLNogtXlh1/P/Pjhm6wMtvhf4aT0/zGHjmBr0XVYJRUqd0zaK3K9IxPFPzoi
	lpgfVtn04yOgUNLjExCtNSZn+SKWCvn7M/aMA17mHuviel+eioBnjveGq+fL1nXtx2qQWJ
	542D9sRdja7NSbXE4hHoI3a9HCp1DBc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IFUnhZdG;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8710c9cddbso209302566b.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768234636; x=1768839436; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vqb4Hn5493L1mZt0rxFOjY5Siy0ns6XDE52wWf3HhJM=;
        b=IFUnhZdGE/huol0dPCWpw4yWyt5LVG3DZ/MaskXtxwzKDMSEAJg1fu4W231eeMSA4y
         k0ePJiLwPni3hjZyEFVMFLRfdI80t5WMKFh0LAZxXspEgeUap4xZdqUIn8ybd+vzEDK6
         //Et+YGRLFSBp74qJReR4L7ASJIYudIEk2GHtNkckvjzV36Lw5Wls2EPhZt3eC60YdTd
         8jRAcw3L7qSmkcN+xJ2u0B7khEEZE2hifNyFiETnsdR7X3gEyme7yzW1/dhIAlWkQnQ8
         Gu0wHJappNHobmUUGdmxdhP1CoEWzRGOY2RJ9jP8VuiJ+L3d4Nv1bGHH76c2oyFaNIDQ
         +lnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768234636; x=1768839436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vqb4Hn5493L1mZt0rxFOjY5Siy0ns6XDE52wWf3HhJM=;
        b=UZwnX1J40dbKho874EMwBXVjePFsL2H2AfaRgQEbcZzBY6V5d/9JxyJSJpfmg/Lkge
         e0tWksm8znXNyL+CNDS7Evsh3uf3ICUXSebDJh1RYXQPldcm8iiiZKyKpUxlzGIhWk09
         lQMBPwN0ek9qO/4wCPMX9wPRPtQmSQnw4OONQYN0TjhdtXNVUk7m0GqvbXOV3z7fDMD8
         K9pa0x1H8lc1A/TaamtxqLPiIDmYpYW5gMnYyZTNxvCkVqzFXTBensXWUwNPPzfOfC+A
         CDZOKobjRJegUEAfzdwhvwBk2+FqtIej5GGjL2wAW7THY/Vn7rV/O43if+Yp3Wmnquqb
         q5Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUOqQPzrtczx1xDolOnW3G1cnD2Rq9ONih/BgzhTyM7Q/icm8ClgMEYc48XRj+e285uTRKH8wTekQ==@kvack.org
X-Gm-Message-State: AOJu0YwxVs7LuxIWN0tHgkzUCFNSIbHB3omyJ5EzggbyXJwY5KRs4SlH
	8gGl3SMlHo/vPLLF9gFNsF5+LsXtaUPbEP6uUOZ7dSCp1jMET2nXP8YxB4knlCb1+N5fEyzPexP
	EdgRVU6krteVviwPNgXL++scG1uQzKpQ=
X-Gm-Gg: AY/fxX45Lp8CUmJFsdP7Q3SAWj+HohGXmGiAoOZq+3YsJ/Ll5Ptajydib7C5Km0yRrp
	COfcojx6fPQ/cIenjYmXGL2ECGW0ic8UlBtsaJU3/uV8hJRwxtdp+MO7nR2ih0HPKLcb9a/rttD
	uJjY8Mvvzxl/gnY0ZftY9f752Vmeadm0SNw7ol0aml40iidKZz4N1nTqqQAjil5yrOQjXEu0emy
	/73r5avkwN0qyI+NqtlhqZDL93jK63kpyk9rvvwIIBcVXrEYpEK9WhWTKWG7xPfsQPmcH/VnoUw
	Vu+8wgZ27v71g09wvr35edwT3jyA
X-Google-Smtp-Source: AGHT+IEHT2Wmj8ARHOeq+QXdeZhO2RV1mWXnMgHXcWT0v3RIri68i3/VYSsb62Dl7FZ899QtqfuzeanTuJydxAH+Cf8=
X-Received: by 2002:a17:907:3c94:b0:b79:f4e4:b55d with SMTP id
 a640c23a62f3a-b84453a0281mr1946626666b.51.1768234635616; Mon, 12 Jan 2026
 08:17:15 -0800 (PST)
MIME-Version: 1.0
References: <20260110064613.606532-1-kartikey406@gmail.com> <aWUSyzHcaDwEg6_c@cmpxchg.org>
In-Reply-To: <aWUSyzHcaDwEg6_c@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 13 Jan 2026 00:16:39 +0800
X-Gm-Features: AZwV_QifkK-8AO58M8_ctp22Xy7Bmh0O4VYVW6iSEyCGW44qb3SEfE5iCfTbZNg
Message-ID: <CAMgjq7CMsAMZZJL1=a=EtfWCOuDFE62RKR_0hUdPC4H+QF5GfQ@mail.gmail.com>
Subject: Re: [PATCH] mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, 
	syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A06624000E
X-Rspam-User: 
X-Stat-Signature: spfsmoufmfzmrizi7iegjx69x78hod89
X-HE-Tag: 1768234637-826897
X-HE-Meta: U2FsdGVkX1/IR8OsLEKu4UE4O23NsEg0NzF/VB1Cz+REhlFMmfsSgvh2jByX8E6LxNhSDHEa2063koPG5xXu5LOWtRY/wmjTAOZn+6j+7pZ1bXZllz5Ie/j7i63qccs43k6slOVSkxAsKZluzeyvYqXjsTppX6xkQDgs3tyhGagEbKoM2y141OOxXp8edInvHyyWzd8tfnmY8K5zA3dsqS46uUbZLMGW9YZVzbVH1ZtoGlevgmf2oEdCeRhip4JajB3NeuZ7YDst6UP5UHAnu2Eg+Kigbd5LcIi6JNyNLoFFwP7zFRH1QIVItMDVQCG7vRRNt1d3eXOC4f1bFRw0NQZ7nERHXyomGulUYVuwzokKxRA5C+gNZBsYtM4efqbN1rr7BSmwxFBeRPtyoiG55VXXyg0s3ahjh7AR8SQ8L1FDZM+8jpzdqx5hE6ohFfcihQI7647hv6xzOUSgIEwqK33rx+Tnb9Zbqkgv6FpCVkuG2eCGTXVMwTNOPU1P9Vf0Ztj6Pz5uFcpjVhs2olV/MAX/lMGnKGJRF2e+ISRPRHZzK/UYEW2CmAVJ2IIViLPj/rh/o1Xbzo3c1rIlcLKAcxMXs6v8rN18VqCNr+tB9+9frzFjO1JVrIrR3tkjy89Us1J2/00gdYgYvlKj5aLGsFiWb78oVVUiy9Oiu/jieFTY0m8aokDq1RIwR1Gk219gVgT69urF2trDZz8yDQ0hcnPnXb7sCWkR+pmZA0tGxY4RJCoM+SC2O2AygBr1qGbY1eodUHXdZqSCtD5cSwAXAyue4Ud67x/gABr0UNC3pAWHTmGefg84fgL/GWbjCC/Flbb2HltDzGjXYvuhg1vzP5ZcZaCoZcYqfEt6Q/kFkz9zZG1SMeRGT1zhr2+Tr+7v88ZQXG7G9Er5RSTOqOXSCfvcaFRZZgccq363v51loWkrgmMFe0MohHCwr/efvIIJdO02PIUv6KSfKIaSNFW
 +lhAXKfO
 32Do41SE/1zznLvmGIt5woh7ms0Gmea3VCGzpru3kXT7q1CgpRXx0STaUOwYjI8xR/zrykhDsu1NqVtEXkLHy9TjebgbmAoVL7RGvwgc3CxoqIxDsIrlr0EjpHz3uY6fhg+AmN6NaWxRY9m13BSVEeShOs9QfKhdLFoBlU8fHuzfz2gHvfseTfOzXV7FTmtN12QkzfwqVTlF6H/0RWsofMHcX1HAaYFz20M1kD4DVHwrEG7W3tswJKU9sOqDRnlw2xJe0GMGhmFwnTAduu/RoxEHfTlu8W5+CH/KlIhCWS7Z7mmUZdL4fLu5xAv8n5S22GXczsEAo4XylWG8phIHHJVcGfAiuG4J8uDdC7YxYNd4kbX1rEF6KSvGocH8FPANqb+AH2TEO19rmMzMtFAd2UyyGdqIYArMMLsghSqDpd1I0p1c/huF7lLve+8+poSFcYJttINyQAhgau/nfSklGZ2dvaatvpClz1iSaarQ/T2Acc+mJGmRHHmlIYjS704qNItFVg6RxGh3rffAGrwpOGjGv6UkrIJZKTZwFNKVvvaqBCEIqSVkSV4vVdkT6yQqEVXrw3NzIDnCxzBaEn7W3oNbo4CVgmD3TRKAVYeaLISmGCctFOqjTUG5U7Ris5cYzAK7JqRrY7WTZC55rjqsrkvgMX5GwN491ula5J5X9S7yE63QBaCv+2+DNix+HjRWApzuy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:27=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Sat, Jan 10, 2026 at 12:16:13PM +0530, Deepanshu Kartikey wrote:
> > When using MADV_PAGEOUT, pages can remain in swapcache with their swap
> > entries assigned. If MADV_PAGEOUT is called again on these pages,
>
> This doesn't add up to me - maybe I'm missing something.
>
> memcg1_swapout() is called at the very end of reclaim, from
> __remove_mapping(), which *removes the folio from swapcache*. At this
> point the folio is exclusive to *that* thread - there are no more
> present ptes that another madvise could even be acting on.
>
> How could we reach here twice for the same swap entry?
>
> It seems more likely that we're missing a swapin notification, fail to
> clear the swap entry from the cgroup records, and then trip up when
> the entry is recycled to a totally different page down the line. No?

Thank you so much for Ccing me!

Deepanshu's patch is helpful but that's not the root cause. I did see
the problem locally sometime ago, but I completely forgot about this
one :(

I think the following fix should be good?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 453d654727c1..e8b5b8f514ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -758,8 +758,8 @@ static int __remove_mapping(struct address_space
*mapping, struct folio *folio,

                if (reclaimed && !mapping_exiting(mapping))
                        shadow =3D workingset_eviction(folio, target_memcg)=
;
-               __swap_cache_del_folio(ci, folio, swap, shadow);
                memcg1_swapout(folio, swap);
+               __swap_cache_del_folio(ci, folio, swap, shadow);
                swap_cluster_unlock_irq(ci);
        } else {
                void (*free_folio)(struct folio *);

---

It's caused by https://lore.kernel.org/linux-mm/20251220-swap-table-p2-v5-1=
2-8862a265a033@tencent.com/

Before that patch, if the folio's swap entries are already freed and
have swap count of zero, memcg1_swapout records a stalled value but
the put_swap_folio below will clear the cgroup info as it frees the
folio's swap slots. After that commit, put_swap_folio is merged into
__swap_cache_del_folio so the stalled value will stay.

