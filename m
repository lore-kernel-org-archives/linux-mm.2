Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CEAF588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3766B00A1; Mon, 20 Apr 2026 08:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883A16B00AC; Mon, 20 Apr 2026 08:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BAD6B00BF; Mon, 20 Apr 2026 08:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9A36B00A1
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:55:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2019FBC109
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:55:47 +0000 (UTC)
X-FDA: 84678931134.05.9E497B8
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 369D812000B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:55:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E5fZL2OF;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQDz4K1izp3M4WhTLorDD3Rkf0/nzmU6W3n3HppTCoM=;
	b=SfvC5wqyeK8zoRTOp349WTISgggiJXLFygu8nLeEqPqQxs6FHmokurArEz5ozFTyua55ig
	VXPeIgMTXVUFMt20dKD3tpeS62PW+GhRYzMVDHugYR8e33E0/A97vuN642xAmU/1oBknKn
	EqpAQH+Kro3psRWaW+NjFrX0pvhUqos=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E5fZL2OF;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776689745; a=rsa-sha256;
	cv=pass;
	b=ZAwZ65ilUw25aKCPWpyWqcsSwGSTjvGaQlzGmeHGn+MqNS0wzfM9+I4dyw6VJYruxNX6LL
	bYvsYCLK03SmsWdYMc3Z14eSZEhQpXnV7PHLQ71AFWOGIvsoT5BIRY4ys4lHRj3i/bOKHH
	WcCMey5dZet3V80bJYEoOwyiGwqdiaI=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-794719afcd4so30526807b3.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:55:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776689744; cv=none;
        d=google.com; s=arc-20240605;
        b=Ei20Bv/7Uhwog/vUm/1SGjkonWtCzfpObv74mneokJgPAiOncj7bAbCj3uZRdZfQRs
         fnpQukbiM2YwWOYwYqHEdq8c/9JDT8SI8RFAnWh9Z7yI6S9njVziBBxNvSdNreanzaZL
         jZXhL2p7FA09Ps70U6Xdbtn7SI5mwpZtPPLc3+pvL/9ck7jsih3KqZFa00l3FikZfdbp
         irQwJbxf6mp87vbQh9hAyVZWZHw5VvllnfbjgI7ODt453PVm2Sv7T6HLzSt1ivnrbYr4
         REMRCx4W+/CJV59s8YdzVohYIjDgChjeUwfNsZPNXgNCYXKQVXF+dLyLUpD0FBmgER+A
         +NLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MQDz4K1izp3M4WhTLorDD3Rkf0/nzmU6W3n3HppTCoM=;
        fh=h0MbBxqa9KgpT3ccWDwpqD3AvOFCXg0bU7Wkxol1X1s=;
        b=kb6etrrBS06MAfXNqeWsb3xvJFuaY85Z0t1ygVzB1kV5m0RxAW5WCAaQsRmEvx7YlZ
         g/c12nBcfw6a8aY8vJsdDRT59jAHTIe5jBbr4QgdN89wCrUDzitpcYoQdC3ehT+sUCMp
         1sBB09+b1FN7IEWsphS3YgB4jDPzHtYODmT+TBTHvvuuY5/lba9pSsx1yep3dC3YifIT
         Y0eQ7Rf940gVgKdO40ijfuXZHqvL6fWilORCh12X9EZKR5PkyzXmMS4x7vY3mVVrShpM
         x7IT4uyhNq4gwe0Y9Y6rUDKb/F7bwzec5MRuGgHH5x+Cc2Gv/+AQ5lw+lxEE3mq+dB60
         8sKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776689744; x=1777294544; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQDz4K1izp3M4WhTLorDD3Rkf0/nzmU6W3n3HppTCoM=;
        b=E5fZL2OFL7fW+EROqnnodyIyNj7KYoXqPKjyJhq4NMYXaDLvdsfFwdbanrOf7EmEnK
         pX3ww9rl43tYbTaUeAO76Tt1deZg4+fS/57nFk3OyGBn+E7hAZeTYrny3VEggHiR4K9j
         bAEf0YGsZNnLzkEM+EI3XevGSF8D3okko6n43yuyZQ2GuOKXGY/CQJ+RE/zGAeJOfQ7L
         lI/0Dg3/ypoJYfjCXNcdsqUJHXAp5FR0VDgNd1BTx//JhIemPMQpwFr7UV1Y8YvqzXDz
         wNx83niWUEdvmw32/BwdcVCUjG7QRJUDDRB2Q9yUmRJr3G2DRzqHcr1fS36XGlgDhVN4
         ub8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689744; x=1777294544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MQDz4K1izp3M4WhTLorDD3Rkf0/nzmU6W3n3HppTCoM=;
        b=mdMDzQgEY+tNFFVzuQwg96rJgEFNApsum3IX8SHTbYo+fweuysffkusDCQxw/ZJwQR
         DeubjHgR0sGGXopDywiUswjhzmi124TC/AqzPeOUSlHHevooNI3Wvokt4YysUF+NoI71
         nZxlxfRLa2E/MapuqmIBtXbLV9LcM44ESDzOkUA/p3VSVcBCBq8tCEuXUE80bV0jpx2Z
         1jTyyeM+89aN096zMlhtDTDEtrDmAATfGEo6iSJCfDiZF+gWfrn8EyNuFkMmCJ9z6t9C
         YlDkYnp046J6/OqKsVQj7L9EeABC3Lp7fyKqBhGrNxkHk+tUK5WQWOkCRQLhiEvok/8B
         zSvg==
X-Forwarded-Encrypted: i=1; AFNElJ8zo/dXZN2jKvxxTqNPGwBq7uTUcLfPBFCtaetN/HilW8qO61SoH5wxEku13kYPPb6SIHkhhDvhDg==@kvack.org
X-Gm-Message-State: AOJu0YzWCLAnf2U/1z3ge+at1UamIwgraLQ4noq0keR3Aw8GyF+0+43T
	1GI42hgvwTm4sKJ1eb/mC7eOX0lhwDn/8IFlpOKtyprl1COLzIhORHT96iHHxYGWek+RdwfuU6B
	ScE12qQNiXsW3t5AWn572TDJHJ2dhSXM=
X-Gm-Gg: AeBDietZCP53dYNm81Emm9Fye0DpsNscfOsm4I5j4w53lxePgKDaMxzbNjkV/Hy+Do1
	0BBzGcYlPIs5ZyVOCIa5Qi0qc/1bCfZR/IgRuph+OQS7lSXVYip82ouFUW6cB1hvcc+MbFNE+GU
	WMDgl4F+9XmdPjNwlI505an4MAd/2M40zUJMiS1xHCRvhr6xicSDFpfsc5JYeFln5A6Z1CrmQrn
	Q+5MEeZyZUGlRltrjKkb6R2lYY6PkpseCpHnh3GRh6I1Sk2N/t2k9kao6rRVvlpYv/ui6E0HFBK
	bEZpRSkIneyAcPs=
X-Received: by 2002:a05:690c:289:b0:7b8:3b51:c9b2 with SMTP id
 00721157ae682-7b9ecf7571bmr132794027b3.23.1776689744164; Mon, 20 Apr 2026
 05:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260419144225.2875654-1-ekffu200098@gmail.com> <aeXMZzb_zECfEayR@kernel.org>
In-Reply-To: <aeXMZzb_zECfEayR@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 20 Apr 2026 21:55:32 +0900
X-Gm-Features: AQROBzB1tVXHHOLPdJ_CWIQhP3lrfUl7ID8IyuEaGjHJyd0xcaXhnBb-DShBw_I
Message-ID: <CABFDxMHOSWTnvXNLy6crt-x=-Mt7VjU5XMo3Z17+zfkkeO5KRw@mail.gmail.com>
Subject: Re: [PATCH] mm/sparse: remove unnecessary NULL check before
 allocating mem_section
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q8oqtf9dnb75xbuhxn8tcymojrrwnefd
X-Rspamd-Queue-Id: 369D812000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776689745-96276
X-HE-Meta: U2FsdGVkX199RS8HLrYNXfmPfHLVru84ozJuDZqQjpZ5NLxpIWSrpaDaulQg6IVwNEpm0qSTFTIzhsHqQnW2Mar5URR/oPGD0M+vxRmuidOGZZ7krBqC4Hescg9aNM1+1st3tIJNNQQAdluC2KLyF2Ilw/0JuaB+4y2k0l2wOMze18vMILUY7krCtA3eRlNJfcOwif/fKm3i/OuN4qkRsl4B6on2mIthBR5h0w51YCYpIgVQCAfz4h1eJITHyUSMQ1q4u2NZY85PFrV+an6un/FQIDTie/7GHMqzZnENI/ZR08aIhKw1Q9FQISl6gaOil8akmHocgvGtnA1Pqdna5eyj28kPuIYlwRikqEGaWCyFnqGU/vgEYG5rplz5OZC2L239Vloz/iAqv5f5fROACxfjpc2Y88J26AkW6FXDguDLiulXPhkNg+iFBaD/Q7FSBxM+X90LhHOuuUMV8/jEUKSavNeI9KEDVT0mfKSQda89MLiCTw2SLNP6ybtU4CgnXxmj4Za86QOzWziQL3QFzWsPbZMUnbRTInKF4WYjNs9Tx6Vk3CZcX3SQ0JkoddeilIWDROsj2mLjREH5t3I1FYGvPjMoLNi5slPkRs3wYuJvxP1Z/U5012JyhFjiGUdiy24bEAgegsXuOrpQCRmlsfxFokWQTikcvYdrF9YMlnayUlMN9sn3CSmwPM+hbJb/diO195sOM9QJS05H1NVHyAq6yxYU9+s1mxHSP8k+PGxau62zqkQgCYWixAGvrhQPoDsyxEqrJKHfnfrRg84QQF0lo1/a6Px0/bcdJg8m0HCA+oEz5jkGrWDZXB1Kv4Uw7lD8UvTD6UpbI4Q+5VMhfXDxVrjP7/MEJOD2Nb/yUkAY8FpS/vKVgwQPs6LXyRHuvTDotH5W0CNU0286ivyMnCkBVZbSpo9lXTszKjEdV/PY+caE6cnD59WdN3N3Q+x+unPQ4Mg37wWfdUeavES
 UkoEOEHD
 KdH1W/ZkUJdyMBD8h7KE0/hEBepeWaxiNpPZSVOuxRmy4jgM4I5X+BYlmoxwLG56EjVXlIisuaq64mnbbkTME0t2eujsPHqJhruS4OffRiZ2oRc8NkbXQL4grYEbSYEG9spQHr7VnX72Jyvz83WT3a7aKgG+OKVF8eGc8SCWhp7UvhWl3rydFvEs3ZFqt+zIPIjZIJmBAogKbW6Aw34zlYITJhJO4Al2dwGcdNt0l9GN1xCmdtqdTXz2dRfItogFyhjU3aL87QdWjxWaMc3aU9Y6o7ez3kSzDS4+W+mh7Zs7/hpGGZ4cNkoTVT6MDVwx/rfYiH30veGE9i9+qNQ5lSiYBiNpNZatWQbqmJWL1yy8JFG+bFYeCygL7ltmq1gnYZOf8wsFI7zBBj/eBD125cPOw4ZnsqSiJJcSrjpaw5UklsWQTzHjbzVGE71lGJjT1T742QcxChqdNEvdDuLrNth+6IOWNMIf6jn50SQeqkhSNUIPojms069F+uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On Mon, Apr 20, 2026 at 3:49=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi,
>
> On Sun, Apr 19, 2026 at 11:42:25PM +0900, Sang-Heon Jeon wrote:
> > Commit 850ed20539a4 ("mm: move array mem_section init code out
> > of memory_present()") moved mem_section allocation logic
> > into memblocks_present().
> >
> > Before that move, memory_present() could be called multiple times, so
> > unlikely() matched the common case, where most calls found mem_section
> > already allocated.
> >
> > After that move, memblocks_present() is called exactly once from
> > sparse_init(). Under CONFIG_SPARSEMEM_EXTREME, mem_section is always
> > NULL when it is called.
> >
> > So remove unnecessary NULL check before allocating mem_section. No
> > functional change.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> > ---
> > Hello,
> >
> > While looking into boot information, I found a minor enhancement point.
> > If I misunderstood anything, please feel free to let me know.
>
> I would say it's more a cleanup than enhancement :)

You're right. Thanks for your kind review. That's my poor english :-(

> > Thank you for taking valuable time to review this work.
> >
> > Best Regards,
> > Sang-Heon Jeon
> > ---
> >  mm/sparse.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/sparse.c b/mm/sparse.c
> > index effdac6b0ab1..e13f9f5fa090 100644
> > --- a/mm/sparse.c
> > +++ b/mm/sparse.c
> > @@ -201,13 +201,11 @@ static void __init memblocks_present(void)
> >       int i, nid;
> >
> >  #ifdef CONFIG_SPARSEMEM_EXTREME
> > -     if (unlikely(!mem_section)) {
> > -             unsigned long size, align;
> > +     unsigned long size, align;
> >
> > -             size =3D sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> > -             align =3D 1 << (INTERNODE_CACHE_SHIFT);
> > -             mem_section =3D memblock_alloc_or_panic(size, align);
> > -     }
> > +     size =3D sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> > +     align =3D 1 << (INTERNODE_CACHE_SHIFT);
> > +     mem_section =3D memblock_alloc_or_panic(size, align);
> >  #endif
> >
> >       for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

