Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C1BC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2746B008C; Thu, 27 Aug 2026 13:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D056B0099; Thu, 27 Aug 2026 13:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF376B009B; Thu, 27 Aug 2026 13:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1141D6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:42:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B9A440156
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:42:28 +0000 (UTC)
X-FDA: 85147768776.09.CA4ECE0
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97258A0008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:42:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OY/Gyila";
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4g2R7hDD/VxEow4hCMhyCloS5wn9CYeEzUt4DHWtAc=;
	b=jJxQCAYtP/q4tVkzBu6H6+zo/ZLygJjswcTFLZyYzqgvy0y8jagqRGqbQ6o0QPe0xlAhmE
	FMjnxEnCR4JksnUpTAAg9raT8BhiFSjTBEX+s/5qL65VglQ6FIH/e+U+af5yCZi6eHxrAz
	3SaTcJqi0iS9Bf1hvDYA5HZ0H7+lRM4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787852546;
	b=YMJzS1tFXysEN4hnT7M10r6rbhzgV66sBx+JyCASnurr7UKBXmHNOoZLwG0FJrA2YjRfA/
	JGrzjwHJOkQLc3ssj8EPEBEzIob9VcWxJO0Yb+L2Q3bLQBwHAE/F2u3FmoEW45T12hHEhr
	RjAoMAmQ9mVY/hWMICcu/JfbqouxxTo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OY/Gyila";
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c252c7270faso19099366b.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:42:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787852545; cv=none;
        d=google.com; s=arc-20260327;
        b=sN/HNHXKwFqmkbWlj6Otvu+6AfCUB3dkg6cVQR9pqM/AHdB1RL70ZdYInQPi8/gQK/
         xSpvdttlVz1J3INQSJGOG0DFdfneEBW4jN6g7tNc9JSxcv1NtBhB/20jsdoFt1bSaeSz
         QzaUD/d+AHwEGp4aPZ8x0QAKr2cFW38SOh9lbeBeiwraVomataWIQ60AqLnJzCfv3kud
         uZdgmTofOmUlgT8kJvvcouV4iBxNhWBZDhdTLrzD3fya9B0FxqOsPqGhW3TN1aNKoDdL
         UeeDqFcdh0rUc7r6OlfPavG0BOinXEHetSvKd0OzKiMF2qQUA1IGxCMPbBGCMY50JIGv
         Y1Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D4g2R7hDD/VxEow4hCMhyCloS5wn9CYeEzUt4DHWtAc=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=J5oc/c+80TdXVmk9dR2r5Wnt4yimYWj8sR/teIk/WI2Q+m1Hhk+0T64+8Mq0F1PwbY
         qcp3Y+oZ7Im+xnX5PzykWhWu3ySn02+jt37bmjBYeueF5/tkTILteplW1QKpxqIuBiDc
         /RcRC/Dbek7zqfCQfP27ANzlyQNn7QRV9YdNV8iD2YfG+kVBa0PPAE27mJ8g8Vxf9V4S
         6p+wwvOQKx3rIxvxNQE2BF5vQftoIf2x2AKXu/ymFW9mInfy+S0WOqo3L0wX/bEhlWdh
         gP7C9u5KX0H8J/e/XZeCCAr/TLcJS+mTopZV16dvoGhhAJxuKQRHp/MOFcycq8yT+Kh/
         mvHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787852545; x=1788457345; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D4g2R7hDD/VxEow4hCMhyCloS5wn9CYeEzUt4DHWtAc=;
        b=OY/Gyila+LDCkqGNt0R9EJS9hZ/W3TSSZEHaK/BWk9h7IZRL9FVP06dPhhTOK8tWSP
         SKgOw7nCxWQtkMUDqKjIdqJHCvXOoLGGaGZFy9P1cySj7NRMU17S1NxJyqckFKW2t9tC
         rVnjIrtXA9PmDWfC0caFb1q58XBCO0jO04ZwE8VYspwcRBs1S0ueWPj3rjoWHF9PsxMX
         HrBDshrOoIy/IDPefHNppsVsJ9CuQa8S1TDLz0X2mI3LbOvtY8qYh0Snuhy+roz6kVMn
         UCkb3xMBcYg6PGwLdLziFyASB3tT7ha30JeSB82+THa/q93uI5SVdZ8EKRkNJquamaSB
         dy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787852545; x=1788457345;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D4g2R7hDD/VxEow4hCMhyCloS5wn9CYeEzUt4DHWtAc=;
        b=dFj96oYS8toDAskwbXct31vOGSNgJlmnjcnXfLP2BOO4O/FcdgB24EJUJHpPak97m4
         Zh2X3eND6mdwk6y+8xxAUzUTKWTNU1FyyDL0Uh11cMqWFxynzxEkhgtgfWQqUdpA+xnb
         SjJjV/g84aGbNF8t+piDiM8uULyvGFfIB07bbQZkVd24QWYUOJliiKV2gZRmgxCEpkUZ
         qdu2Pwg20Jec4sstKOcdwdYZ4vpEv8nfJAxdTRcS1d1cJC4a6d/GtYrI5yiT2PXxnDuE
         wxRORMQsyMRudCgJKkvMqBNmFR0DESWx+T/NEEfpu06o7nT+ZB3fAdbbhfq6+a/ojWoi
         6rDQ==
X-Gm-Message-State: AFuF++mrAKQpdBObuCFZHD5mR1oWyPgHFYlP4oZ/JfEEJ4oDBLMdXsNo
	P0r8NpQJnRmyxjGuOJB0aHCUaZnZivT1h+vsAI9rtsSAu3WNwUT5eKza7/gp3zjQPw8x+6G1Rm+
	71RkWVpJZxsoWASWqczwcjMU0rv9/kvU=
X-Gm-Gg: AR+sD12qUh2JIkRo6ctHDrFHVBR75eCEdj2UPjtohePL95Q8/7i3EGP4LYlqIr82Kj/
	vfiFVJspFK9RF2TCZuK8Xq6l/BDtOZxKU1fmj3FZmZC1sEm62wUbDheLxQvHdgYFM9EpiRhWtaj
	E+v7ppLPLS3OXe2fbMh3qg+BBE8B+H/oGHWU454l3mHbxmp3eKA4SktWsxoIZmWKSkaMpi/PCeA
	NmRUv7UEeifusb7If19CK4Y3hzXsAQ6b7oIvkcvuv95PJ2KM/wP2lf6BWVgw8EDoD2EJcaVof3X
	UwqbSWIT1gKi7GSQ29JNzNszfvkW60eQBtxW7vSK/wYlzD5YirpkMCXzjAMAIdgXeR5lpsUW2sY
	g
X-Received: by 2002:a17:907:6d0f:b0:c24:f8e0:f092 with SMTP id
 a640c23a62f3a-c2556bd24d2mr32286066b.1.1787852545239; Thu, 27 Aug 2026
 10:42:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-11-9b43f5163238@tencent.com> <5ee65970-abb9-47ea-b548-5430b382cf7c@kernel.org>
In-Reply-To: <5ee65970-abb9-47ea-b548-5430b382cf7c@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:41:48 +0800
X-Gm-Features: AcwNN1U7uq0MZRyrRJQyABR8mE1_Ys0frTFUmcCYhz0ueNXpbpen6JtJp3NAFzc
Message-ID: <CAMgjq7CgxBEuX0rtUdx=g5RFijONOfDuUM=A2FBqy1R2N2n-2Q@mail.gmail.com>
Subject: Re: [PATCH v3 11/18] mm/huge_memory: allow splitting mappingless swap
 cache folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97258A0008
X-Stat-Signature: 74wrqfa34pft766ngq5k1d99qz1p4xju
X-HE-Tag: 1787852546-402272
X-HE-Meta: U2FsdGVkX1+pH/Dfq37lTNNw9QdbpVz0LRJrSiAqtjsxCMFdk4oEjSeFaXxB/iNSAmCzwJ+sbkyCCHCyeixljU7+HvJ2suZbH2ZvucKoLP4V2B5PsGtdmXG8F1t8r08op1gPEA5r5Chw4SR8ePz/jVdQXBwMJ3wvBEmYz4lVY7OWic9BzrYLYxpqDfijCgec85GlggfhCDyxHPdDUYxKs/7RT0KDDZuA8xo/GqrMKS7pc6g4UGoiqYoKsJjWdhUFZWOn2XgpYU18nF4l5kZxaIwIlPdG0hNBBetoW9BsxuJMNabl0F5y1DwgtfvhQI3AGc0uZUMeb20OjmUb9Bg7kI7Vyvs+4pQpxPJtvjowtT4aVTMLEeQCdT4rxfHvxMO3lzsh9G7gr4hud5/177jNPxq066DI9AZo0lWuvUaWArrPOSsOvFjTEir9iudAIlP8N5eCX0xN5oJSIUdGZ87/SgznOa4PSXE7Jy5w4WjEwAQF4IsulnQ4OfHA/5u1mTCmU4G4At3XksZhKDyKW3dVMF7iyhfvGMBApXtM5XV82D4LPuczSvWcGWXzj6Kz1xniGZPmMXFvGGMa3Xuj6hwclZRGwzsbojtmJCkvRqeMhC47V3AeGgepNFCi5ngj6G4dqxFfL+cDRt8VOMS4tmH94ymh0u6h+FM8IbljLaBLpT7V3tuVTD8SxypALsSLpwaSmTMdYBZKPevpMQDIoKdpdh1nT4ccOGNYfyuuKLQNuF/06hoaZfDXc17QJWeXHWepE5Bd7wShc/4g8zzppFxU5h6q5D/yJIAF5r5o0CeHddatyirEWiWiHSz2vXMATYl6Y8a2LbL+Jat3n96Fuy2WCFIagqSawFrjzc8HkZxpia49gNvxMMI/KABBwfekE0qTWM7C6kjXB3V+lmhLhtMNHOLVRH7bpXbAG6zfxl7VBgUgz1cc86SJBAAfOjhh9dO9X/F+pGOSV+Co+RXEMUQ
 TdH3ADuJ
 bmSjqz90mSft3s/5L6C+Pv7L8wCDVNhlJFw4ErHzqQKwNmwIWMz0pZtzEMIGySfcrZEZm2hd+tq0bd9CM+0RMrI8l4s3ExBEhH8DMKIPLS+m/etkbTPJN2YtGHt9ST/oTQYgACEHBsjW19U8+IhfwYwAIjD2uX4+M8HFhHllgh+YdmXJAzOmqAjmpOI56A5U/etxbBRb7hBjhjehtDyL83DHNbVnjd6r7pGmDf5Hq4yfnQ0LVOqVbNfVgWN8vgHmGNVSsrCmDEQCHKxidatEoYhEPx9aT7A5xOU3Krnl4lOgJvgYcuYdOfvZV1AE/YU3YosZXTVxaHV4AtXjDvKD3MB05148fZ1gicyp6l+B+wJGK385H6zpg9ZOh6MYvSXPTn83rY+2VHDe9onNhXl5kGNMA6H37IHHTIByUrlVFIrR8ZFUxCiEqOCvExpVmlhbMToNkTMINP9PsMmXhTYIJ/85Qkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
> > +     if (anon_vma) {
> >               if (!ret && !folio_is_device_private(folio))
> >                       ttu_flags =3D TTU_USE_SHARED_ZEROPAGE;
> >               remap_page(folio, 1 << old_order, ttu_flags);
> > @@ -4259,6 +4261,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >               struct page *split_at, struct page *lock_at,
> >               struct list_head *list, enum split_type split_type)
> >  {
> > +     bool is_swapcache =3D folio_test_swapcache(folio);
> >       struct folio *end_folio =3D folio_next(folio);
> >       bool is_anon =3D folio_test_anon(folio);
> >       int old_order =3D folio_order(folio);
> > @@ -4285,8 +4288,11 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
> >       }
> >
> >       if (is_anon)
> > -             ret =3D __folio_split_unmap_and_freeze_anon(folio, new_or=
der, split_at, true,
> > -                                                       true, list, spl=
it_type);
> > +             ret =3D __folio_split_unmap_and_freeze(folio, new_order, =
split_at, true,
> > +                                                  true, list, split_ty=
pe);
> > +     else if (is_swapcache)
> > +             ret =3D __folio_split_unmap_and_freeze(folio, new_order, =
split_at, true,
> > +                                                  false, list, split_t=
ype);
>
> These two boolean parameters are really a pain. There must be a better wa=
y.
>
> Also, I don't like that __folio_split_unmap_and_freeze() sounds generic a=
gain.
>
> There must be a better way for that as well. We had a clean split and now=
 we
> mangle it again.
>
>
> ... but I am just before my PTO and out of puff, so others can brainstorm=
 on how
> to do this cleaner :)

What if we just keep the __folio_split_unmap_and_freeze_anon name? And
have that "bool remap" mentioned in previous reply? Clean swap cache
could be considered "anon compatible" as they might become anon
anytime, and even for shmem, shmem shares the same IO and LRU like
anon, so considering clean swap cache "psudo anon" seems not too bad?

