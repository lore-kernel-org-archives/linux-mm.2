Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9C8CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723086B008A; Mon, 25 May 2026 13:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2EC6B008C; Mon, 25 May 2026 13:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B236B0093; Mon, 25 May 2026 13:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41CB06B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:58:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCB5A1A01B8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:58:46 +0000 (UTC)
X-FDA: 84806702652.27.FAB1DF9
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id CD1971C0010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:58:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hCSEeYrx;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779731924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feVmNSonQyuve2/f8ir4FP2A+lXG3rLGtDpBEXfxJtU=;
	b=2noHKMidUrSCvddeR7qGQjShh8kidu6HVvwGC1Ggah1w8j14t2oLs/O5YUtZCmsknKq+xT
	q5M9S3WL8advBiHDKnqE2gq1WI13KBfp0hE+Ac27+z236kVSr8ZQ5vNkWtrYBYuoePbdl8
	bWFw/i5oWEwOd7PFdpJTuTqa7Lp1iHE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hCSEeYrx;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779731924; a=rsa-sha256;
	cv=pass;
	b=GKuczUPLGObx+8CIIB5nztKrKgMb5EDruWIadv2cNJhLDV50bUot5+RXR63dKse/B2dMIw
	zwblOul/jNTs+c/grMkzSV9FJxjHvjFWiug874HyBMhy+ZV257D+zPJn8d4z6m0P+hOEPu
	ivZam/8+EzAjWHKUgYBemQzJ01Tw+vQ=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bd56d108454so1777758766b.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 10:58:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779731923; cv=none;
        d=google.com; s=arc-20240605;
        b=KwwZ+vUBs06AgqEbWb4FU4De225ApeoG6NVue5j7iSi4cNB6y358Ha7GSrv0iXw/HZ
         OUjv5kn8S1rF8/hEnlsPTgytPXR6isrqvTj35ThONCySOykqnOUqagNrX7JnsgOg3YQe
         uNIcH9g6ToUMEozoISp/Z8R8LYAcSvwgXcOlYxo96eayVOTLfdMnmF6e4wojiahs6JNd
         faq8c7J1lE4a96c4yzlAuS+GBqL87we0Cm23KWNiajWKEZfF6QRZBBIlnhYi5AO2HQYU
         uclv/UvzFHTcINwsNTgaCyHAAguVZdgAc5+gdaEQ31ehT3xyoI0kStOK3MrrX86SY9Ca
         COIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=feVmNSonQyuve2/f8ir4FP2A+lXG3rLGtDpBEXfxJtU=;
        fh=mZJ6pMPf2s0SYBCMzh2o2Z5MO8mSAU8eLG3mdn6m/pY=;
        b=dn740gpYcNyJOgRKvxlwXhBLbSU0dMOTx3Xs0f4ZQGI9JUOzvKIM5fu2Z0vN9AoMhl
         aDKbWzGs8VwdRYmPBCF2WZR3EQqqZijOj3ralhhkSHoG2Aqa8CkvXqngqgtlhrRyHKjk
         tLLCrOfH4tgv0VdhwnRkm720UpArbARaXIPHPQdHr4YH1sa6wPajDmHlqwQ4L5wLKQim
         Q+PugypQ49LQud86khe/5cmPzr3iQRTUzkS7WLUV9hY6j23fuol1mNZYpPdH+Mx6xtCF
         IV2L6LzkJWH8fDCYBUqq4D6iQWB4qtX83UL3wTD2aY3jBwPaQC3SNqrsCXh7nPfzhGF6
         8s5Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779731923; x=1780336723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=feVmNSonQyuve2/f8ir4FP2A+lXG3rLGtDpBEXfxJtU=;
        b=hCSEeYrxfaW2DwvXdvJdWzYMNzLRbnwYpTYLCrxZqiY0qaMABRWQphVzeRWJiXmVHK
         Y6J9MA7/kXAQyy7/2x/WLomS3mReepcGGk+UxyyMb6/v4YCsFCJ7CWMmhRbScSeqVx01
         SIt9zd7zz/TULQAFMk4/qACwNVP1lvqB1N9/5p+KCK1/XOeDb0GiEEJ0FevFkhF4300I
         yRhdgnPHMU+fD/KP5LKiJgsZHp8E2Xedrrg83WB7P9MDpTA3ExIg9QqoFImHqYGjSqd+
         ZdhGbRUW70jrTZNK+AHFjeuI69ro4cTs7TXDBmKerRQ6N9rd4rbBO3S40nX2/d6IiBG/
         JFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779731923; x=1780336723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=feVmNSonQyuve2/f8ir4FP2A+lXG3rLGtDpBEXfxJtU=;
        b=mVPAlV8g5ygmZJLC4bwKdilTUlxxJmzCN930g6A/Wuvq95XRC8L1xBH3Lo3mlOmDKc
         X2We1JNgnzJbw5UW1YwjobekrcIoeGAjL+piR2RosWwrarwOH6zYXLGYUjr4+ht/X5aW
         JflKAAS+cv/prPiwgzPoDW9cDQp5qWp375o6vPg+VToPg0/lqsvyjO6DNgFmpIhtfpje
         Fs/0pC4kFZdnq3BdENqCapKK2y/mfRb8VaYl7TQS8gYgN+cJRPPoYkB2mVLNPaaU6lrY
         NVgAeXv2a+INAMEBIhY3h6L3V8LaBQv/HErftmup1wpkMbo1Wx3HZV5gjL/O7HVLWwvj
         JwOw==
X-Forwarded-Encrypted: i=1; AFNElJ+KdIvzmo2I9O6PBZZOU8PPYHMEgIAvBe5mLWHXZEETPn0QNSjAYllipgrlwMNOPzn5L9apT9or3g==@kvack.org
X-Gm-Message-State: AOJu0YwehneGzKwZEnuinNGp3IXJ31n34VZhrE+C+M3Jau45+xPfHC97
	zk4l/92vZAuRgpKDaO7jFtnw8Qy0pKErPmMIEhOX+g04uc8FWnkMu4ynuHgblUVcwh06K1odygx
	Ck+eJ3L9r0mymTh0F41rcyL6T/cs8sS4=
X-Gm-Gg: Acq92OFmjxz8CY7NXoqk/lSkVSr0QKfXOUF0sRi1TdQIW2BmH23VxMB6WPMs1GK8Hkf
	As4C588wuOg8SbH4P5VHFRRgVYwfaR557Rmt5ctZZTOdc7BtN98/QfDbWRqAomYFMU9aKgmcTef
	f5/UIHoTQvhUdZGC5AWvoqlA6ym5+/OaPgoFdw62vHaQidctPnQ6Aob9NKNy+a+yP5jpEHeHQeI
	2VNICNs91Nb2lhPjWP4OU9izOjLqYAO6UUxNFjcRpfe1JoYCADxVCGKf3koKjrCfxQq8a8X9KSp
	VikgWpjCdG3eDmIOvZ07kVVq/I656hmCny8s0B/b
X-Received: by 2002:a17:907:b5a3:b0:bcb:98cf:1a82 with SMTP id
 a640c23a62f3a-bdd2360224fmr671988666b.14.1779731922861; Mon, 25 May 2026
 10:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260525123205.51874-1-baohua@kernel.org>
In-Reply-To: <20260525123205.51874-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 26 May 2026 01:58:05 +0800
X-Gm-Features: AVHnY4Jhs0zQl2u7DMk1pPpWZxRTNjrOwwryz7Gpu5de8nODNv5mzqUR1NZi27g
Message-ID: <CAMgjq7CZt+EFoVqSti93QpKUNJ4VySxm5TAOgkMmpkS+73QyZA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: use folio_mark_accessed to replace folio_set_active
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Pedro Falcato <pfalcato@suse.de>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	wangzicheng <wangzicheng@honor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, Matthew Wilcox <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, 
	Kalesh Singh <kaleshsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5d6qopw3pnxrnadaouen9mhzheem3jc5
X-Rspamd-Queue-Id: CD1971C0010
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779731924-182526
X-HE-Meta: U2FsdGVkX1/Cb1udl0vgheUUFSTFnFHvHvEzxyu9PnXcuO5ZKN5Uohob3fs30398vQ2ghqOdpZLsvCiw5VoFSiLOKolTFSGs+X5RiAng4wYW6JjsDKIoTEdWSJi7EhhCc0+9+yY0tvxSPLio9PM/FzEDjlOdiLa0e6DvC3zqYXG+QntQp3DcxABPkNTy2WsPijCfsmH21n3ds6woDh1KtRNj+tjyX6xbx5E4Br8D3MT9iXv6Yn9i70d/q/QtvMK8tI/Y0TBlxL3DeasgOjYiv+zFxxUmCDy4RyPLKVG02LIoi615VuR6eGsVPjPvqxBURvqfigPeyjB8uQI6uwHnrhgF/eG2aA6mWOQ9xr2K4EQa/MjOlKP/ZMw+LiWluHAPDWYyWeb6e67rsQpAiKsk+VGLhpll3svBoyZ+MPl+3PKbV29xak22/xgC8HuDMMWuVIPMqIES7DRBFCG5oZZyL0ZzE3B1BfQMNht4i4LRCB0TUya8tbe1bBW0W6+hXi2lL4kxECrrJgRjBpyn1Azz/soMHlChgh0ALTdzfKUc5SEAvHjcaPiqjkId2kYFSFhMhu/xmECRXnVHa4i2Pgxrfjpsy/ul9TU8Fg+FLoLowwEEZBwtNfHaf9IBqQqUYF+bN2qrq0ZyLRI7u+R0w+FJWBdqm3lrqczfLHrT7cKfKZAMhjOuyH267MvBGJJL915amfIdNuejyXYGF7DmZqsXnEsT2N6aeouGhnAJXa7GLf8ek9psCgpKkiq79J5gJn3MjeEBvpRriMPE8mAQHJRSY94QCipkt8qEKVlz4llmaMQdEDgdJmrL7r8B/BU+tGgnN3zctdJQZsmP7ZJyLVwHVUOA0CPtsKRW4CBPxFry47ltFAzk52OS4b42tTV+l/7K8Yhw55bKYvtSSBBO8SSUdthywUyhGHCu0Qa43FhjyGgjqV+7Trac+tMlEsja+8TljDbmrdM3jafM6JyEAxb
 qUMf5rwW
 YPwFIOGEtkMdzsoxXbuh4xy4wQ/WgJlOJ5p+s9BJei7If1ZiSbWFjRVSmvSZhUrLqQvlyM4wyuYe6mXrc9u1yMC1H18Ck+geS38OgdU1DaFzfrqANRamweD6T1i0ybYZAUOl+pjbYdY3+AbcQFqaQFvRBEFqddZDYLSIjMxonJtxyWEMkKSwpSXuSllz8trTokmCazD6al/QvX9bSFvRPBV9DzUq9FXAtu4hBPc1XpemAYeTahcICnZLnc3OilvazLLK1EARYFWhwxOx8UQGGYMr1YPYbTHu3tYuXX/8qf+i4EXTG3TLE5d3TCeJtraCzsziwcKnjItdav9IqEPeAFAlCZWcCOuKbyEfswnH0vfitVox+46T6g4GKdVyEU/Xw+cJv14BjcAXmllJh469MJ9AuptJCpkke0IJZWbC72fngiB0ofaBOtrHA4b+4ggdo0eMs+8fDfIesbj3tsy7akxi8CTjMiYznoQmKUuQQzWn7bhr2enDS+mx+MpZbQoEoPTAdj6HNE0Y+MxYhzHiV6HqhL+wtbErIrs1T0jS+TYCYfuD+o1JiGkaqk87MeRRneN1GWSoGB8g+Xw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 8:32=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> MGLRU gives high priority to folios mapped in page tables. As a result,
> folio_set_active() is invoked for all folios read during page faults. In
> practice, however, readahead can bring in many folios that are never
> accessed via page tables.
>
> A previous attempt by Lei Liu proposed introducing a separate LRU for
> readahead[1] to make readahead pages easier to reclaim, but that approach
> is likely over-engineered.
>
> Before commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
> folios with PG_active were always placed in the youngest generation,
> leading to over-protection and increased refaults. After that commit,
> PG_active folios are placed in the second youngest generation, which is
> still too optimistic given the presence of readahead. In contrast, the
> classic active/inactive scheme is more conservative.
>
> This patch switches to using folio_mark_accessed(). If
> folio_check_references() later detects referenced PTEs, the folio
> will be promoted based on the reference flag set by
> folio_mark_accessed(). We should also adjust
> WORKINGSET_ACTIVATE and lru_gen_folio_seq(); for example, we should
> not unconditionally protect anon folios accordingly.
>
> The following uses a simple model to demonstrate why the current code is
> not ideal. It runs fio-3.42 in a memcg, reading a file in a strided
> pattern=E2=80=944KB every 64KB=E2=80=94to simulate prefaulted pages that =
may not be
> accessed.

Thanks so much for the update! This looks much better than V1 RFC.

> Without the patch, we observed 12883855 file refaults and a very low
> bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy hot
> positions, continuously pushing out the real working set and causing
> incorrect reclaim. With the patch, we observed 0 refaults and bandwidth
> increased to 5078 MiB/s.
>
> Running the same test on x86:
> w/o patch:
> File Refault Delta is 3240029
> READ: bw=3D13.2MiB/s io=3D1183MiB
>
> w/ patch:
> File Refault Delta is 0
> READ: bw=3D7708MiB/s io=3D676GiB

Really nice result here.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a171070e15f0..c637e679a450 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -242,12 +242,11 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
>                 gen =3D MIN_NR_GENS - folio_test_workingset(folio);
>         else if (reclaiming)
>                 gen =3D MAX_NR_GENS;
> -       else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(foli=
o)) ||
> -                (folio_test_reclaim(folio) &&
> -                 (folio_test_dirty(folio) || folio_test_writeback(folio)=
)))
> +       else if (folio_test_reclaim(folio) &&
> +                 (folio_test_dirty(folio) || folio_test_writeback(folio)=
))

This change is more than just "use folio_mark_accessed to replace
folio_set_active", you are changing the pattern for all anon folios
here? But I think we are mostly working with file folios here
especially in the first test you posted?

I do like your new if condition though, but maybe it's not the right
time, or better add some words about it, how anon are handled now.

>                 gen =3D MIN_NR_GENS;
>         else
> -               gen =3D MAX_NR_GENS - folio_test_workingset(folio);
> +               gen =3D MAX_NR_GENS - folio_test_workingset(folio) || fol=
io_test_referenced(folio);

Nice, this aligns exactly with what I want here :), see lru_gen_folio_seq:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-6-913619b014d9@tencen=
t.com/

But I think you got the precedence wrong? Did you mean:
(MAX_NR_GENS - folio_test_workingset(folio)) || folio_test_referenced(folio=
)

Or?
MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio)=
)

>
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de987..f320f93d60df 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -511,8 +511,12 @@ void folio_add_lru(struct folio *folio)
>
>         /* see the comment in lru_gen_folio_seq() */
>         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> -               folio_set_active(folio);
> +           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> +               if (folio_test_workingset(folio))
> +                       folio_set_active(folio);

What if we also move this set_active to mm/workingset.c? I think that
the only place where a folio with PG_workingset can get here?

> +               else if (!folio_test_referenced(folio))
> +                       folio_mark_accessed(folio);
> +       }

Same here? Also this folio_mark_accessed only means
folio_set_referenced here, which matches the folio_test_referenced
check you just added in lru_gen_folio_seq right?

>
>         folio_batch_add_and_move(folio, lru_add);
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e452cb043d46..48355f10542b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -848,7 +848,8 @@ static bool lru_gen_set_refs(struct folio *folio)
>                 return false;
>         }
>
> -       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset)=
);
> +       if (folio_test_active(folio))
> +               set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_wor=
kingset));

This looks a bit strange, PG_active is always unset for on LRU folios
for MGLRU right?

There is even a comment for that:
"PG_active is always cleared while a folio is on one of lrugen->folios[]"

And lru_gen_set_refs is mostly for on-LRU folios or isolated ones,
either would have this flag. So PG_workingset seems broken by this
point, rmap walk no longer get PG_workingset set, which removes the
"promote on 2nd access" mechanism entirely?

>         return true;
>  }
>  #else
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 07e6836d0502..2f0c08aa8623 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -319,11 +319,11 @@ static void lru_gen_refault(struct folio *folio, vo=
id *shadow)
>
>         atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
>
> -       /* see folio_add_lru() where folio_set_active() will be called */
> -       if (lru_gen_in_fault())
> -               mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type,=
 delta);
> -
>         if (workingset) {
> +               if (lru_gen_in_fault()) {
> +                       folio_set_active(folio);
> +                       mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE=
 + type, delta);
> +               }

Overall I agree with this directly that file folios shouldn't get over
protected. It will be even better if we actually activate the folio
using things like refault distance... Which can be done later.

BTW, this would break reactivation if we age periodically. That is
less of a problem compared to overprotection, I think.

And do you think we can keep a folio_set_active if folio_test_anon =3D=3D
true in swap.c? Proactive activation relies on the assumption that
applications never expect an jitter for ordinary memory access, which
holds true for anon folios, but file folios don't follow that idea.

And I'm not trying to seize the topic but my previous experiment using
refault distance-based reactivation resulted in a 500% performance
gain for some databases with no other regressions observed:
https://lwn.net/Articles/945266/

So for this patch I think it's on the right track, we can definitely
merge some follow up of this patch first, and then refine the pattern
step by step toward refault distance, MGLRU-FG or both plus others.
That will take a long time, so let's fix the low-hanging fruit first.

Really looking forward to a few more updates from this patch :) !

