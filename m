Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF04FD9E1A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FBB6B015D; Thu, 26 Feb 2026 17:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0A26B015E; Thu, 26 Feb 2026 17:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2CD6B018B; Thu, 26 Feb 2026 17:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D57246B015D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:11:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 838DCB809B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:11:20 +0000 (UTC)
X-FDA: 84488004720.17.3CD29E9
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87734140007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:11:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=doW9DqJ8;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=yuanchu@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772143878; a=rsa-sha256;
	cv=pass;
	b=s2j/oucna5GJBz9QqYrOS7zRR85kg1qGhFemPPglQTXORo8LGWM3F1o5jVOqbR+6N9cbBw
	tiO6bUn2BV0tpI7XVrwmyXcf46HNiY1DADJEDJlHStoMnyXgzZRf2fJ9E1MbbwXHnsr/wZ
	ITCpD6lscyJAdxHEyCYDt0dZ4Q4GBdo=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=doW9DqJ8;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=yuanchu@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772143878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOhaTi5HaJ97iJf/0vPTQE+hsCcmtEeTgjTJobMqU5E=;
	b=P5aviOuP2bYZdKfQjBGRCG3dSOQGrPd1FFr1As4zdL380F8wkpK9nU8gOeqI4g0hG2tgJQ
	ovhln+D/Rqnv6Ppnr9FS4IBDABrggktWVV3mrMVkoW7YDW1bwax+XDvFskirPNJ0rdeXeh
	kPtqN2BBy3kCrfqzJK5UeN62MipZ1LA=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1270fc2bdf2so3600c88.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:11:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772143877; cv=none;
        d=google.com; s=arc-20240605;
        b=IYEeppNmSktsiI195FWZpQFopVT11poWzwiwaex46jOCzG3WIxcYBnCh9PskFScO5q
         PQmKCRhbpnLB4PixoONWJCNTzsW8UkM0FWe2L7+yOsMMyRUFXiFyvuCD3oyR+AQe71ea
         LWOccJALR6mRqRx7HVXtcTd+FUbcePyKivLEJA8/Qvb+/iV2V8d7CoDjLt98S76FiwQ1
         OeCID46Tli6KOyqWm9abfsi9k47g255zCZUD3iEyNVU1Nm7HooslbPoNklosHeRj/48v
         h8oADtZKRMHp6pL5gOrG0EX+4zRWeFj6j3henJFW7EzEjPi7C+QMoLYUFasWEu4N37EQ
         jX6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pOhaTi5HaJ97iJf/0vPTQE+hsCcmtEeTgjTJobMqU5E=;
        fh=9St5+wXzcvXWD3mq2vPh4DovynKck/tNggXmkklhxUk=;
        b=Q+oSznNHKbQCJxjReLB9R3cfm0wut84JLs4RCBZ9pO/eA+wNfyeOp0v7GIIdz9+b2B
         cLg4WSokbVJUIVhUVPr1EGGkYfkIivz5O8zr46BEoZ/UucGvp6eP764a8dGffT7UAufr
         fV6a4Ti4dGzhTjgY5/2sTFPx5+gNCX22+M+6gXDzadAJuCDhk42pdIxkhx6yy27OgT8p
         UnTQIUSeeHitF/8+ZZaoEsausrX456i75SDIa4BZe/NCHEcBX1Qfq4yVFQxw9O0DJC2f
         YAwjeqynoTssG0Q4shE8VhyNtBzO+nUUSKRgiQEtLIjWbRVUR7OMWtgZOJ5HoEnRI8Ra
         /+Wg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772143877; x=1772748677; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOhaTi5HaJ97iJf/0vPTQE+hsCcmtEeTgjTJobMqU5E=;
        b=doW9DqJ81NOe6KXqic2OJqOMnozRge6XpaQEEyMwcOi2ZkmM8egy/i1SHl2nin9GeK
         dHXEgW0LFCumQMLeRuGfHA0yxg5gqmxY5ELvOcLUgYdFeYx1iVzzcD/T6Cah8UQu38LY
         CwFu0x6M8b2nL8Rpp18GGaP32bK3E5qWrZL9UewsxHAFE+cC5HI480UW9kDheI7yqFu6
         woz2P+wVSZJzjImaR5kSEEbC72j2lpWNfhCk35j9ReFiefnp1KrDUG9al2RnGjJWRuBz
         WGgzFED5PJ6Y1LNtiKxWfaYyDxduZqiFNTZY5zfVNkW+1zt1Wdr4JYaZ7SldHQhWd5aG
         nWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772143877; x=1772748677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pOhaTi5HaJ97iJf/0vPTQE+hsCcmtEeTgjTJobMqU5E=;
        b=l14rIOoa3S7QUS9kIQl6ayrYjdLZwObWWlFZ6Z5VFwP80P3pdhx42jLo/2GUthDs5U
         n7x+qCZ+bmHDZtJREeTXxkHKKKP0YKycOwyQqbTtEpgFp3gdT0F9zV962ZKAXrob8Dhz
         9ZY9XY2PBsSWFNeVTStXd8kLDwqVJ0MMYt0QrJdVNbcVJRxQrfIaeKDx89HGoq6iGN/i
         S4QKbxN18wn9121STkyMDBOV5dPyrrxIOJQ1gqhsBrNes6DOu0iTWUxMXkPMkXKdNbqg
         rVOOq/pLCrvzsKoUD3rIE/ygZiYaI+27twfHH5BMWab6jJTvPv5a8VqtspN0uPXvkmmu
         4nkg==
X-Forwarded-Encrypted: i=1; AJvYcCVugBRKolZ+PC1YNxu9y3ivffz47wHVi/r6GeDdZiihz7SArL26pQkEmE9DsH4vgRkMs/rK4jkqdg==@kvack.org
X-Gm-Message-State: AOJu0YzdZeE0jsLSFlv/mhhHhAfXq3L+dalh+lQWA6SbMvcchEGGThPS
	nqxerzBqf/XxdjsSUwH9ve9RqCKCUAuFWgamQ6uquRMu8hOUKp+BLCi8K9OZ6ADnTzRb8tBvogD
	rd/HjXUUo4OCUg8c9+pG0qNoqaEK89sLX7o/NOeB3
X-Gm-Gg: ATEYQzySyAOKGs7HuBqdhCdakfHyFbtoMWd6sJTYUQWNO/zlovJ9WJrhSylI2OpH3Is
	eDhdK/l85frGUGZ7Xjb/ZvA9ukEZzAvHvfyQ61mT9I7XpdeaLjfiMB9f5h5mDApxMt6i35gKLU9
	b8WBetdU6DFmmwzpn0e0kwG8Y9VfZZjvCj0ERfwVjI8hZoOLYWJpgEtmauzijLHkQeOrgXBU9Y3
	wGchnh0img0svMCTz2uL78LikNXcEJOQrG9zSRfvXquBlatNRks7nhlRt1+d+Hl7b4Vz+3t49mv
	Qe09mL5evrQX5WTasa/59Th5X6l2WfuwgI8KAw==
X-Received: by 2002:a05:7022:983:b0:123:3640:33e4 with SMTP id
 a92af1059eb24-12788fdf4cfmr293567c88.18.1772143876621; Thu, 26 Feb 2026
 14:11:16 -0800 (PST)
MIME-Version: 1.0
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com> <CAGsJ_4zatnuLkCJyDe_o_yXmhngpc54kV6b7M3tu6JyvF-ZxDw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zatnuLkCJyDe_o_yXmhngpc54kV6b7M3tu6JyvF-ZxDw@mail.gmail.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Thu, 26 Feb 2026 16:10:59 -0600
X-Gm-Features: AaiRm53duTGxs5_rOU69bwiqKsWqvxGqDIz55VhSjBILktAbzzPIrPzsTkwYxkE
Message-ID: <CAJj2-QEHAk-H6SSJY5OmLYuVyLRacSEgUupKaKefFFwGg7CftA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and Challenges
To: Barry Song <21cnbao@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, 
	wangtao <tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, 
	zhouxiaolong <zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "weixugc@google.com" <weixugc@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"willy@infradead.org" <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87734140007
X-Stat-Signature: q3t79d3dugir6mopj615znn5cdmorza1
X-Rspam-User: 
X-HE-Tag: 1772143878-295082
X-HE-Meta: U2FsdGVkX1/igrprN30gyGj629numVSJM8YFk/5ULxuPFRWNmV9NsH0ujnczKvai5o7gfuDlOhFyg/5pdorgggd3pdmWR++DtDyxU8GjSpxHUuRxZZuEC6wf5Dab099nOlw4IkoAPZlBxzCBholie2WtRn1jBvwce1YMZhDGJAFZqW+Gyi2NkeiogrFpyh5HcL04Ufo0G2EzHmo+8EdFZNhcXDmt//1H/9B57JdTORDUfrBTyfAMdwf0bciTUNL3sXLqx0hvPLfPSibz0FV2wl86t1/H1wCyYb9oUzwWQYP70cHYyKCphZgIsB2E5VjOAMJP1wROFxGp1y4koOV8S9np62bIl8Tman71v3nVZts/7O+zlisZDg1QT7WxphqDZq3ke00u8Hvlrwn8fGP1G0amgVfQX4EsgzM5QlUU3UOC4r0VneFfKrLtViHUuLjsRraYlPtJjkvXzeBZ/cCgiHq6ewdZtJkMxvUQLLryidc1h6/ZXhLVxGuAulW7a7YjIHXW8C8IvCKqJIww1sDkY4UrZQa8Y49nxCp3Ze2gOVGzblo5o6vgfyerTigbuLfCTlhNBXV5bo7cNGO1xvvubO4Gp+XU4s6jXnF1rj2aQ0qbRQ+BJmqhscyNA5ghI49NO6d/id+Cr1X9d3EGF8LqZ8A4wevlPGoMmwOpnFhnRSus3yYtBX8+SaItQ12xuO7jWkFo4JT2zyyJZS9TcJz0RNuXPX3V1O4JrDzkKNt8vhhUeTgc9p8nfsyajGd2324GPkS7a4btnIgr4EuBPrIRZ9KyokUpQ1SjfZr9WIy6BPMHTfuIB+5w9WOXsk0ivfEo8dSCe/G/xY8349W3aNoPUmGcHFarb2Jv7bv8utUt13msDtHvhp26bqLOwA5b6t+hC8pKnlk62gVbKzwKFEp6c4D/ntOgIRcoGMaaf4cx/Foff8A6MfsivM4c8CZ48rboLOzSi0nrB2b1xggVS4g
 u+PdrfCo
 DR2Kccldy4LamF068zcaextVwPkpvT9tqIvZt9KuAHkGWZdGXgZx1ChYkDKokX4+BgamqNzhFXDXQWHTyyTXfZj0UFwruGy2x1hPQWg+MauU4nvERr15VRVO8IVL9oA3Ay8eZuJYEIzynSqU/fQMJ+ecBeNPoO2nKXfGDpE4K/Ez7GBJlSn309NeoCMwIvzibFUhH9b5e/dMtdVqTd4uW8zH7tpH77gTlkEFXrHkllAqz6h/W0TUuWfayVvAOG4EuAn0Ih7jEkS7vcvjAli9GZcrmQaRCXK/W/bW/6BNnaPajaQHJqh6x8yTjBhDZLO2oSlqQ1/OVVskBND7UqxBOIxWAe6jQBnU7EhUiHo6McAD6v+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry and Zicheng,

On Tue, Feb 24, 2026 at 2:23=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Feb 24, 2026 at 11:17=E2=80=AFAM wangzicheng <wangzicheng@honor.c=
om> wrote:
> > *snip*
> > Below is a short summary of what we see.
> >
> > Q1: anon/file imbalance and drop in available memory
> > Android apps workload show a persistent anon/file generational
> > imbalance under MGLRU:
> > anon pages tend to stay in the youngest 2 generations;
> > file pages are spread across multiple generations and over-reclaimed.
> > Tuning swappiness to 200 and ANON_ONLY does not fully fix this.
> > On a 16G media workload we see:
> > MGLRU: MemAvailable ~ 6060 MB
> > legacy: MemAvailable ~ 6982 MB (differs by ~1G)
> > Today we mitigate this via explicit memcg aging in Android
> > userspace [1], which is a vendor-only workaround.
>
> One fundamental design of MGLRU is that file generations and anon
> generations catch up with each other when the generation gap reaches
> two or more. As a result, even if swappiness is set very high, its
> effect on aggressively reclaiming anonymous pages is much smaller
> than with the traditional LRU.
>
> One workaround is to force old file folios to be promoted to relatively
> younger generations, but this could also cause problems by clustering
> file folios in the newer generations.
>
> I wonder if anon and file generations can progress separately to some
> extent.
>

To provide some context, the file and anon generations are coupled
primarily to simplify the MGLRU logic (Original Yu Zhao's intent).
Separating the two should allow for more flexible policies for sure.

> >
> > Q4: Lack of global hot/cold + priority view with per-app memcg
> > Android uses a per-app memcg model and foreground/background levels
> > for resource control. root reclaim lacks a cross-memcg hot/cold and
> > priority view;
> > foreground app file pages may be reclaimed and reloaded frequently,
> > causing visible stalls;
> > We currently use a hook [3] to skip reclaim for foreground apps.
>
> Interesting. This somehow reflects that the LRU lacks the user=E2=80=99s
> context, especially on Android systems=E2=80=94for example, which apps ar=
e in
> the foreground, which are in the background, and how long an app has
> been in the background.
>
> But this is not specific to MGLRU; it can also be an issue for the
> active/inactive LRU?

Pardon my lack of familiarity with the use case, in what ways are
existing memcg protection features insufficient?

>
>
> Additionally, I=E2=80=99d like to add Q5 based on my observations:
> Q5:
> MGLRU places readahead folios in the newest generation. For example, if
> a page fault occurs at address 5, readahead fetches addresses 1=E2=80=931=
6, and
> all 16 folios are put in the youngest generation, even though many may
> not be needed. This can seriously impact reclamation performance, as
> these cold readahead folios occupy active slots.
>
> See the code below and the checks performed by lru_gen_in_fault().
>
> void folio_add_lru(struct folio *folio)
> {
>         ...
>         /* see the comment in lru_gen_folio_seq() */
>         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
>             lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
>                 folio_set_active(folio);
>
>         folio_batch_add_and_move(folio, lru_add);
> }
> EXPORT_SYMBOL(folio_add_lru);
>
> I could have submitted a patchset to address this by initially marking
> only address 5 as active, and activating the other addresses later when
> they are actually mapped or accessed.

I need to read it more closely but that's a good idea.

Thanks,
Yuanchu

