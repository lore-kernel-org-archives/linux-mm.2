Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B34C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 13:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 995D36B0088; Fri,  4 Sep 2026 09:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D6D6B008A; Fri,  4 Sep 2026 09:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8836C6B008C; Fri,  4 Sep 2026 09:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9946B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:02:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEF8B1C34CC
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:02:41 +0000 (UTC)
X-FDA: 85176094122.06.90DC94C
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC57B20002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:02:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hy1c6ImT;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788526959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1Y7YmZWSzxr2iY3IqKw6JuwDP6OUCGK+XiwHXOkRsQ=;
	b=evDWJQWTMuPAmXqDpql4OQs/6qdxynckg+udHGwPQ9FnkuaT9MHO0oQdae3BvMFj3/9xgc
	4b7b9y5AuQGNET0PJS0X6ETHFkNoxfLzACLRcPo+Vm0tNgpQwEUCAXtoFK5YovzdrA89WU
	L8ARdv9Vkf9wR9m6gCz0+gwNuXnacDA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788526959;
	b=ay3ISBrlZDKgff84XLBTaOQoLxu0Prb0v6DZpyqbdrw9dSnECrAcEI5dkNCygnCzeC0HXX
	fsElOPxaMh3c8x8uI99ysKzqOZ4UtFmaED3t/E2wwAgo4CRgSxtYs0+C1UrdxB4tHDhXpQ
	RrK4T4Yhh0FLYfxglmLGrgRuHIoLq6k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hy1c6ImT;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c25366c9b42so100412366b.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 06:02:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788526958; cv=none;
        d=google.com; s=arc-20260327;
        b=nN4BGvTN26aYl3NJ9hOcStEgWCji3nvZtP4iBdFTYi7DM7Cx8LZPB5c9iszKZrr/Pj
         Kjtk5YkNV7WkDdW5PExg92qkjlqHicO8LyoNKepsLkVQBmgaQ7rK03J6ztadyngq7t7S
         sinNY8TILj7GsTv+rOlB6li5b8P+EZeLnkXihv6sMwqQcJnJOsNlqmSByi5SrRTWtATb
         UnjZMK2h7wVeOZkOQY85NXBcT03ZZdM80YabAKIwTdVNAJdSpQxU0vf3BIJQ6Xg5TVh/
         lSinRfsRiiY7omiEwcQ6If+StD2kf4GhdmqAxLTaM0xvbZVo1s71uCaB8Gp08YChGSxT
         FcGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A1Y7YmZWSzxr2iY3IqKw6JuwDP6OUCGK+XiwHXOkRsQ=;
        fh=ROIQv+AnMhKpkuUVObIQOVYfQImB02NU141CX6MYoOE=;
        b=oFQs60EwQsh7Rd4h/O1ji7Rx2Oc/FATSSpx9/YCTk37LCJ8y1y97Y/Sz8UubWiwAfY
         oZj51fhmFVw5roCCRcLsb+byAajHXNhdA9rTf2KStPNCSE1ih1KcJskCcjEluKowiZBm
         fMRIfqzuwdtDb0G88p7nbVzLkgIPprGb9m2nnyjZ9GQHn6uo2DgLkRlysNqjLtYQ6Mj8
         Q0McB5ZmB05O/CRrbPQcSJEHUCa0L0w2TkaBlNuCtviZusuzHQJhJxZwXTnoZpv0ruLz
         N5wUzyAhTbLUMTn5eL+RVbz9DCq8kPvqhDoDr+2MBYrrgJJDSmGMdiHhM9WB1gqUexEV
         yqgg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788526958; x=1789131758; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A1Y7YmZWSzxr2iY3IqKw6JuwDP6OUCGK+XiwHXOkRsQ=;
        b=Hy1c6ImT1QA/9NWuOcszWsOTnFxdHxGeeeClyByT1wPkI6qFmC+iIX7RoJrmxL6zTE
         jR1c4OSCpFCw1Ql8ns8uF+A/rZgiWS0oW2KXh4s7Wz0RCKTkSq94mSBrd8vJanHHNv+j
         3C8lLo8mIXxmTBZJTdtKcu2PhwlMOdAejRnegugqRLscpzf/6vipfr97io5o5NRM5wdp
         VD+FMbDr7GrJ1KudWXUyFcWD/B8SHyxT9jVvIPQbvy8/YAolzDcw7Q/k7F5EAVyZH2eM
         sd7q/nQL90Imqh70LgiUe3g45VL16ejXk7mOzkD8BE791WtP/5UbaF3v2Jbx3AxJeqCM
         AxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788526958; x=1789131758;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A1Y7YmZWSzxr2iY3IqKw6JuwDP6OUCGK+XiwHXOkRsQ=;
        b=bK3p/TZyQudG+1lIqINiqs3tH7G3qcxT9W8m6TXqOAha/PIGkWe66rUqad+Waah9BC
         bQJtsIMBstUyRnuxqfgvgwJr5RGJgl7W9gwjAQpuIo6DeAdMxqItrnH9shdYj+jY592Y
         U+wm1VApElw3DYw8tAQs6bxvkk/hQxiDlRHmj7vIlKwXZUhRb8cm4Ir82PLp3W9Dw/3n
         69TW/XLIdDSIJRfFzdTbbk4gnqBlEd8eDWiAayhk5aFt+XLJcAzMJ+xwMILHDHloeQw3
         Wczew0AkDON8LGOmDzpju1Lj5TR2zwYkuVCJzK+gxDK/+wIOAu94Fy/IrUYMwPUnXyY1
         gBjw==
X-Forwarded-Encrypted: i=1; AKwUvBx5Yj+WocyUquWWQpcoxxTQ1fWwFAcThKKAOTN9wy6ZXTC1UdTJFtWmNHHw0VDKw0j3DOo/JzcrPg==@kvack.org
X-Gm-Message-State: AFuF++ngHWO1IffrrkGlaGC2HoCk3wZsujMXk6yw8T6d72RJ594sEwCv
	gJNuwSm9KM01hBpCYXuMXh3R+4AbRPbHeYhyCwiDrpMLRP4hUP+E1NaGTMlmVCvhXy6mnK9bqFc
	ze+0dpG0+JAIwTIblkSoO4E0YmMubkjg=
X-Gm-Gg: AYBFou13pSg2WmMeT2LluyI4ffOtPbiPnf/z2Elcef0h0lI7Y5HIP4y4W8tHFghd+vk
	vnXNHWGWOzkkj95hzyIDH2orMrDw75Kn1cIcfhr45m/qLptk9KZgLL7Heh6yuGUmKqwTXM/B5Sq
	CLjuIUMQJ0WaXesLBIJaZHwJ3XiylXegiZaJ/ZUZ6/H7rBe+66tUXPCZp9/F4AKzPUFcEWs/3g9
	3buTNQcZe1NW7NJ03yQK7O9UiORk16ETIm+UMFKGPAdjq8exG5p3/KHa/n+XLP7SVTEX2dIUvhu
	Qcdi0Pxdl3OEk5gajGiD4TYlSsIzrkuedAn0eCPJubNYDDrDTO5ggXu/94U5fKHswJ3WJaTtCxe
	fvQ==
X-Received: by 2002:a17:907:807:b0:c26:19de:912d with SMTP id
 a640c23a62f3a-c2619dea0a3mr112357266b.32.1788526957825; Fri, 04 Sep 2026
 06:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
 <appvhlPleahTRklV@yjaykim-PowerEdge-T330> <20260904100900.21517-1-lianux.mm@gmail.com>
In-Reply-To: <20260904100900.21517-1-lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 4 Sep 2026 21:02:00 +0800
X-Gm-Features: AcwNN1Vm-0llheBPana_0CljCj4L1V8rcsjZv3MdI7EdXVkr6QNxUdxDIn19Bb4
Message-ID: <CAMgjq7Bh0hdVoRcS4xMRL0YG-zmjh-TxyF9xXCmP2MRarAyksQ@mail.gmail.com>
Subject: Re: [RESEND RFC PATCH v2 00/13] mm/swap: introduce per-priority
 allocation queues
To: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Jihan LIN <linjh22s@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7xmbas1wdf4y656mt8jxr1zfyt9wp68j
X-Rspamd-Queue-Id: EC57B20002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788526959-543115
X-HE-Meta: U2FsdGVkX1+EQWmYuoQhNypo4bJCHRp/48u8u5FgjxwVC5MOuMqjq3sIwwIc57J+2atbqCv8GUH4VU0QSFtGsyzULXIkUukgKRt/dHQrk6hwQpkjua+8A2/yaqin6kzxbL7BEMQV57Cn0B2bf9pW+4Ja33lE9WmHeVs7LrCe3nYqQpgsJinqLllPi34H1AourXIxpaJ8YT593sdmHDvOUaOsj+vVhEyVU5E5NKRM1tiFJCmxfsNpYN/M0xH/TBGpRhTe+YD/+8Zkp2+TEjjG1af0mU8lD1mQqDx7jhd0NR0ddrHpRIeTaseSKg9GuVOJ5wLrXrPNH3l51gCGy7OCGQvnELCVE0jgO0cbj5iNFyd6VTJXxqpkwHGHKsDYT1KMPHCfkdrNVPd4KAr4eK6aPmuAxfWVnbsPtVTUNGkQ7q6nGjHem6ymM+b0Mwlx5HQWC7A3oApEU8cZwvDTBo+2dVmV3q8Fqnppboj7SbUZ6MeoP97snAcPAyr+XABeeDtVSe4WASy4Ezjv9DFNehEs0OSwthFQEjO1jY5yTjMU7pGEYA+2+tQ33RofUibtW3vyG5TgyWxwXVw9ACaldIwErOsKoEzuPz/W9iWmCXJwfB3QUtGdhwIurNfRrwQp32IqKACHgfd0cxP1bYoJg74iZAIRn9zqTlBt3u52zWIWT5qoa4gZLIfSLgwqPKbM+YEUza7ijbzSHPDkKf1umubVtlgzL8MpBOi9CqzWJ1c182sYe30hR42dHzCEaBMyW1gjsXiCChnUz35qjy+HI4Zsr2ZBTjfXHvxC1aFsUlbH8M0wOUdLsKfY9m5JReDKv7Tc6AyXTmphNthM7KVxkb6MQoJy8vHtVTn/HfEtS33fgvYrmc5du6HaNsnCexNxcMu8I5bkqOQuWPYsYRlso9vHbbY79ogRSqjQgAIxD6hWoeMppk7MzI4cCeT14ZwPSSxEL5y+6V+IAICv2k2K6Zd
 6zXLnouA
 sr2fAOvIupuA7Req3iS5spWZ11h9tWVe+WJK65QbKwKNUP5fIahsE4wcG8KsCqDVswoWtlqs5tsNKN/Us5hQ6xbT/iyRk+VLrtmoa0uyPBD/YvTsP7dxp/kq1ZxGwK1sUOPcYl1yUdSReHV6TBJN8r1psFz8tJP/2LECLPqTKvXsR+FChsBaCI6FdVuT+xsur8HwKWIRcLkRX93dhuYNCQvo+I6aBTHqFeOIkLGod3rh+t5moAszx3cCCYskb6DI2Fy/ELzPLBAVjC5cjzZu2kSwXCBsTj10nIX5iVwTLA9vYR5qJSZF0v6t/BFLMw7MpsW0rHYMq97J+HiJU8EyLjsVPVv1NjVlV5x0LeWnts2R0c3BwIpG/JYTXKKLt+dNc1SLkDB0dh6Okilvw9jjcKCV6KEIevphLTSr9jLef1PTV78NFfH3f+mzBFAzoGOqzcbM/u0SdTYP/GT2LuGAQXBugwy2egRezayIxf2YhTQvpSso8b+6L1Moh33hwSs9HZuV38vrudGbGkpq6U9xBhuyvcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 6:12=E2=80=AFPM Lian Wang (ProcessMission)
<lianux.mm@gmail.com> wrote:
>
> On Fri, 4 Sep 2026 16:13:10 +0900 Youngjun Park <youngjun.park@lge.com> w=
rote:
>
> > Since tiers come up further down, I'd like to raise a point about the
> > patch subject line too. As Kairui mentioned in RFC v1 that we would
> > stay aligned with tiers, would it make sense to frame this RFC as a
> > per-tier allocation policy (or something along those lines)? Kairui,
> > what's your opinion?
>
> Thanks for the thoughtful feedback and for taking an initial pass over
> the series.
>
> I agree that this queue could naturally become an in-tier allocation
> policy. For this RFC, I would prefer to keep it separate and scoped to
> the existing priority semantics while the tier and virtual-swap
> directions are still being settled. We can revisit the subject and
> naming once that boundary is clearer.

Hi All!

We can start with adpating the default priority if tiering still needs
more time to land, Not changing the user interface means less risk.
It's also fine to implement tiering first, there are some other
blocking issues for tier though.

With tiering I think we will still need rotation of devices in the
same priorities / tier. Once tier is ready, we can further extend the
rotation in the same tier; that's something to discuss.

>
> I will also sync with Kairui when he has time. He has several things in
> flight, but his view on the ownership and framing would be valuable.
>
> > Devices assigned to the same tier already share the same priority, so

Hmm, the current posted tier is a band of priorities. Do you mean that
when tiering is enabled, devices in the same tier, despite of having
different priority, will be used equally? And is priority ineffective
then?

> > I don't think the allocation policy needs more than one option for
> > that case (I can't think of a use case that would need it).
> >
> > 1. For legacy swap with no tier configured, define it as a single
> >    priority treated as one tier.
> > 2. When priorities match, allocation naturally falls to a single
> >    policy (not a queue). the concrete policy here is this
> >    queue-based scheme.
> > 3. When tiers are enabled, devices previously assigned under legacy
> >    swap are reassigned to tiers at runtime.
> >    (This means different swap device on same tier handled like same pri=
ority device)
>
> These are useful design points. I would like to study the concrete v11
> before deciding between runtime, boot-time, or compile-time tier
> assignment. It seems safer not to bind this queue RFC to a permanent
> tier interface while those semantics and the virtual-swap backend model
> are still under discussion.
>
> > I think this feature will also be needed on the virtualized swap side,
> > which makes me wonder whether this patch should go back into the swap
> > tier series instead. Kairui, Lian, what do you think? (Or separately?)

I'm fine as long as there won't be a regression. I remember V10 of
tier didn't touch this yet so the regression is limited to tier
enabled case, so no existing case will experience any issue, that is
fine. Causing a performance regression for existing usecases is
usually a bad idea.

